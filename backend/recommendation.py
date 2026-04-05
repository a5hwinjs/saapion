from database import supabase
import math
import random
from datetime import datetime, timedelta

def get_active_plan(user_id: str):
    """
    Check if a plan exists for today.
    """
    today = datetime.now().date().isoformat()
    
    # 1. Look for plan covering today
    plan_res = supabase.table('meal_plans') \
        .select('*') \
        .eq('user_id', user_id) \
        .lte('start_date', today) \
        .gte('end_date', today) \
        .order('created_at', desc=True) \
        .limit(1) \
        .execute()
    
    if not plan_res.data:
        return {"status": "not_found", "message": "No active plan found."}
    
    plan_id = plan_res.data[0]['id']
    
    # 2. Fetch items for this plan
    items_res = supabase.table('meal_plan_items') \
        .select('*, recipes(title)') \
        .eq('meal_plan_id', plan_id) \
        .execute()
    
    # Reconstruct the dict
    plan_dict = {}
    for row in items_res.data:
        day = row['day_of_week']
        mtype = row['meal_type']
        title = row['recipes']['title']
        if day not in plan_dict:
            plan_dict[day] = {}
        plan_dict[day][mtype] = title
        
    return {
        "status": "success",
        "plan": plan_dict
    }

def generate_weekly_plan(user_id: str):
    """
    Recommendation Engine Logic:
    1. Fetch profile and ingredients.
    2. Filter recipes.
    3. Generate 21-meal plan.
    4. PERSIST the plan to Supabase.
    """
    
    # 1. Fetch user profile
    profile_res = supabase.table('profiles').select('*').eq('id', user_id).execute()
    if not profile_res.data:
        return {"status": "error", "message": "User profile not found."}
    profile = profile_res.data[0]
    dietary_pref = profile.get('dietary_preference') or 'non-veg'
    
    diet_map = {'jain': 1, 'veg': 2, 'eggetarian': 3, 'pescatarian': 4, 'non-veg': 5}
    user_diet_level = diet_map.get(dietary_pref, 5)

    # 2. Fetch user ingredients
    user_ing_res = supabase.table('user_ingredients').select('ingredient_id').eq('user_id', user_id).execute()
    user_ing_ids = {row['ingredient_id'] for row in user_ing_res.data}

    if not user_ing_ids:
        return {"status": "error", "message": "Way to less inventory. Please add more items to your pantry."}

    # 3. Fetch all recipes & ingredients
    recipes_res = supabase.table('recipes').select('*').execute()
    recipes = recipes_res.data
    
    recipe_ing_res = supabase.table('recipe_ingredients').select('*').execute()
    recipe_ingredients = {}
    for row in recipe_ing_res.data:
        rid = row['recipe_id']
        if rid not in recipe_ingredients:
            recipe_ingredients[rid] = []
        recipe_ingredients[rid].append(row['ingredient_id'])

    ingredients_res = supabase.table('ingredients').select('id, diet_category').execute()
    ing_diet_levels = {row['id']: diet_map.get(row['diet_category'], 5) for row in ingredients_res.data}

    # 4. Filter recipes that the user can make
    available_recipes = []
    for r in recipes:
        rid = r['id']
        required_ings = recipe_ingredients.get(rid, [])
        can_make = all(ing in user_ing_ids for ing in required_ings)
        violates_diet = any(ing_diet_levels.get(ing, 5) > user_diet_level for ing in required_ings)

        if can_make and not violates_diet:
            available_recipes.append(r)

    if not available_recipes:
        return {"status": "error", "message": "Way to less inventory. Please add more items to your pantry."}

    # 5. Score by macros
    macro_goals = profile.get('macro_goals_json') or {}
    if macro_goals:
        target_p = float(macro_goals.get('protein', 0)) / 3.0
        target_c = float(macro_goals.get('carbs', 0)) / 3.0
        target_f = float(macro_goals.get('fat', 0)) / 3.0
        
        def macro_score(recipe):
            rm = recipe.get('macros_json') or {}
            rp = float(rm.get('protein', 0))
            rc = float(rm.get('carbs', 0))
            rf = float(rm.get('fat', 0))
            return abs(rp - target_p) + abs(rc - target_c) + abs(rf - target_f)
            
        available_recipes.sort(key=macro_score)

    days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    meals = ["Breakfast", "Lunch", "Dinner"]
    
    plan_dict = {}
    
    # Fill the 21 slots
    pool_size = len(available_recipes)
    meal_index = 0
    
    # Persist Step 1: Create the Plan container
    start_date = datetime.now().date()
    end_date = start_date + timedelta(days=6)
    
    plan_res = supabase.table('meal_plans').insert({
        "user_id": user_id,
        "start_date": start_date.isoformat(),
        "end_date": end_date.isoformat()
    }).execute()
    
    new_plan_id = plan_res.data[0]['id']
    
    # Persist Step 2: Prepare items for bulk insert
    items_to_insert = []
    
    for day in days:
        plan_dict[day] = {}
        for meal in meals:
            selected_recipe = available_recipes[meal_index % pool_size]
            plan_dict[day][meal] = selected_recipe['title']
            
            items_to_insert.append({
                "meal_plan_id": new_plan_id,
                "recipe_id": selected_recipe['id'],
                "day_of_week": day,
                "meal_type": meal,
                "user_id": user_id
            })
            meal_index += 1

    # Bulk insert all 21 items
    supabase.table('meal_plan_items').insert(items_to_insert).execute()

    return {
        "status": "success",
        "message": "Persistent plan generated and saved.",
        "plan": plan_dict
    }
