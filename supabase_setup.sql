-- Saapion Full Schema Setup

-- 1. Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create Dietary Hierarchy ENUM
-- Ordered from most restrictive (jain) to least restrictive (non-veg)
-- This allows numeric comparison (e.g., veg <= 2)
CREATE TYPE dietary_level AS ENUM ('jain', 'veg', 'eggetarian', 'pescatarian', 'non-veg');

-- Create Ingredient Category ENUM
CREATE TYPE ingredient_category AS ENUM (
  'Poultry & Eggs', 'Meat', 'Seafood', 'Pulses & Legumes', 'Dairy', 'Vegetables', 
  'Leafy Greens', 'Fruits', 'Grains & Cereals', 'Oils & Fats', 'Nuts & Seeds', 
  'Whole Spices', 'Ground Spices', 'Souring Agents', 'Others'
);

-- 2. Create the Profiles table (extends auth.users)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    full_name TEXT,
    dietary_preference dietary_level,
    household_size INT DEFAULT 1,
    macro_goals_json JSONB,
    meal_prep_toggle BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Create the Ingredients master list
CREATE TABLE IF NOT EXISTS public.ingredients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    category ingredient_category DEFAULT 'Others',
    diet_category dietary_level DEFAULT 'veg',
    is_common_indian BOOLEAN DEFAULT TRUE,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Create User's Ingredient Pool
CREATE TABLE IF NOT EXISTS public.user_ingredients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    ingredient_id UUID REFERENCES public.ingredients(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(user_id, ingredient_id)
);

-- 5. Create Recipes table
CREATE TABLE IF NOT EXISTS public.recipes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT,
    instructions TEXT,
    category TEXT,
    prep_time_mins INT,
    cook_time_mins INT,
    macros_json JSONB,
    image_url TEXT,
    source_url TEXT,
    is_quickie BOOLEAN DEFAULT FALSE,
    is_exotic BOOLEAN DEFAULT FALSE,
    exotic_ingredient_id UUID REFERENCES public.ingredients(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6. Create Recipe Ingredients table
CREATE TABLE IF NOT EXISTS public.recipe_ingredients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipe_id UUID REFERENCES public.recipes(id) ON DELETE CASCADE,
    ingredient_id UUID REFERENCES public.ingredients(id) ON DELETE CASCADE,
    quantity TEXT,
    unit TEXT,
    UNIQUE(recipe_id, ingredient_id)
);

-- 7. Create Meal Plans table
CREATE TABLE IF NOT EXISTS public.meal_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 8. Create Meal Plan Items table
CREATE TABLE IF NOT EXISTS public.meal_plan_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    meal_plan_id UUID REFERENCES public.meal_plans(id) ON DELETE CASCADE,
    recipe_id UUID REFERENCES public.recipes(id) ON DELETE CASCADE,
    day_of_week TEXT NOT NULL,
    meal_type TEXT NOT NULL,
    user_id UUID REFERENCES public.profiles(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 9. Create Post-Recipe Metrics (Ratings) table
CREATE TABLE IF NOT EXISTS public.ratings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    recipe_id UUID REFERENCES public.recipes(id) ON DELETE CASCADE,
    action_check BOOLEAN DEFAULT FALSE,
    difficulty INT CHECK (difficulty >= 1 AND difficulty <= 5),
    taste INT CHECK (taste >= 1 AND taste <= 5),
    macros_consumed_json JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 10. Enable Row Level Security (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_ingredients ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meal_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meal_plan_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ratings ENABLE ROW LEVEL SECURITY;

-- 11. Set up Security Policies
CREATE POLICY "Owners can manage their own profile" ON public.profiles FOR ALL TO authenticated USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

GRANT ALL ON public.profiles TO authenticated;
GRANT ALL ON public.profiles TO service_role;

CREATE POLICY "Users can manage their ingredient pool" ON public.user_ingredients FOR ALL TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
GRANT ALL ON public.user_ingredients TO authenticated;

CREATE POLICY "Users can manage their meal plans." ON public.meal_plans FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can manage their meal plan items." ON public.meal_plan_items FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can manage their ratings." ON public.ratings FOR ALL USING (auth.uid() = user_id);

-- 12. Create the auto-profile function
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name)
  VALUES (new.id, COALESCE(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name', 'New User'))
  ON CONFLICT (id) DO NOTHING;
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- 13. Create the sign-up trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
