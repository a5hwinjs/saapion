from datetime import date
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from database import supabase
from recommendation import generate_weekly_plan

app = FastAPI(title="Saapion API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"message": "Welcome to Saapion API"}

@app.get("/health")
def health_check():
    db_status = "connected" if supabase else "disconnected (check .env credentials)"
    return {"status": "ok", "database": db_status}

@app.get("/api/get-plan/{user_id}")
def api_get_plan(user_id: str):
    from recommendation import get_active_plan
    plan = get_active_plan(user_id)
    return plan

@app.post("/api/generate-plan/{user_id}")
def api_generate_plan(user_id: str):
    plan = generate_weekly_plan(user_id)
    return plan

@app.post("/api/pantry/init")
def api_pantry_init(data: dict):
    user_id = data.get("user_id")
    ingredients = data.get("ingredients", [])
    
    if not user_id or not ingredients:
        return {"status": "error", "message": "Missing user_id or ingredients"}

    records = []
    for ing_id in ingredients:
        records.append({
            "user_id": user_id,
            "ingredient_id": ing_id,
            "amount": 100, # default amount
            "unit": "g"
        })
    
    # insert ignoring conflicts
    res = supabase.table('user_pantry').upsert(records, on_conflict="user_id, ingredient_id").execute()
    return {"status": "success", "data": res.data}

@app.post("/api/pantry/update")
def api_pantry_update(data: dict):
    user_id = data.get("user_id")
    ingredient_id = data.get("ingredient_id")
    amount_change = data.get("amount_change", 0)

    if not user_id or not ingredient_id:
        return {"status": "error"}

    # Fetch current
    curr = supabase.table('user_pantry').select('amount').eq('user_id', user_id).eq('ingredient_id', ingredient_id).execute()
    new_amount = amount_change
    if curr.data:
        new_amount = curr.data[0]['amount'] + amount_change
        new_amount = max(0, new_amount)
        res = supabase.table('user_pantry').update({"amount": new_amount}).eq('user_id', user_id).eq('ingredient_id', ingredient_id).execute()
    else:
        new_amount = max(0, new_amount)
        res = supabase.table('user_pantry').insert({"user_id": user_id, "ingredient_id": ingredient_id, "amount": new_amount, "unit": "g"}).execute()

    return {"status": "success", "new_amount": new_amount}

@app.post("/api/cook")
def api_cook(data: dict):
    user_id = data.get("user_id")
    recipe_id = data.get("recipe_id")
    macros_consumed = data.get("macros_consumed_json", {})
    taste = data.get("taste", 5)
    difficulty = data.get("difficulty", 3)

    if not user_id or not recipe_id:
        return {"status": "error", "message": "Missing info"}

    # 1. Log Rating
    rating_data = {
        "user_id": user_id,
        "recipe_id": recipe_id,
        "action_check": True,
        "difficulty": difficulty,
        "taste": taste,
        "macros_consumed_json": macros_consumed
    }
    supabase.table('ratings').insert(rating_data).execute()

    # 2. Update user_macros
    today = date.today().isoformat()
    macro_row = supabase.table('user_macros').select('*').eq('user_id', user_id).eq('date', today).execute()
    
    cal_add = macros_consumed.get('calories', 0)
    if cal_add == 0 and 'protein' in macros_consumed:
         cal_add = (macros_consumed.get('protein', 0) * 4) + (macros_consumed.get('carbs', 0) * 4) + (macros_consumed.get('fat', 0) * 9)

    if macro_row.data:
        m = macro_row.data[0]
        supabase.table('user_macros').update({
            "calories": m['calories'] + cal_add,
            "protein": m['protein'] + macros_consumed.get('protein', 0),
            "carbs": m['carbs'] + macros_consumed.get('carbs', 0),
            "fats": m['fats'] + macros_consumed.get('fat', 0)
        }).eq('id', m['id']).execute()
    else:
        supabase.table('user_macros').insert({
            "user_id": user_id,
            "date": today,
            "calories": cal_add,
            "protein": macros_consumed.get('protein', 0),
            "carbs": macros_consumed.get('carbs', 0),
            "fats": macros_consumed.get('fat', 0)
        }).execute()

    # 3. Deduct pantry
    recipe_ings = supabase.table('recipe_ingredients').select('*, ingredients(name)').eq('recipe_id', recipe_id).execute()
    deducted = []
    
    for ri in recipe_ings.data:
        ing_id = ri['ingredient_id']
        qty = ri['quantity']
        # Try to extract number from qty string
        import re
        match = re.search(r'\d+', qty)
        deduct_amt = int(match.group()) if match else 10 # default deduct
        
        pantry_item = supabase.table('user_pantry').select('amount').eq('user_id', user_id).eq('ingredient_id', ing_id).execute()
        if pantry_item.data:
            old_amt = pantry_item.data[0]['amount']
            new_amt = max(0, old_amt - deduct_amt)
            supabase.table('user_pantry').update({'amount': new_amt}).eq('user_id', user_id).eq('ingredient_id', ing_id).execute()
            deducted.append({"name": ri['ingredients']['name'], "deducted": deduct_amt, "unit": ri['unit']})

    return {"status": "success", "deducted": deducted}

@app.post("/api/log-rating")
def api_log_rating(rating_data: dict):
    """
    Expects: { user_id, recipe_id, action_check, difficulty, taste, macros_consumed_json }
    """
    res = supabase.table('ratings').insert(rating_data).execute()
    return {"status": "success", "data": res.data}
