-- Supabase Schema for Saapion

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Profiles table (extends auth.users)
CREATE TABLE profiles (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    full_name TEXT,
    dietary_preference TEXT,
    household_size INT DEFAULT 1,
    macro_goals_json JSONB,
    meal_prep_toggle BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Ingredients master list
CREATE TABLE ingredients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    category TEXT, -- e.g., 'lentils', 'spices', 'vegetables'
    default_dietary_compatibility TEXT[], -- e.g., ['Vegan', 'Jain']
    is_common_indian BOOLEAN DEFAULT TRUE,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- User's Ingredient Pool
CREATE TABLE user_ingredients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    ingredient_id UUID REFERENCES ingredients(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(user_id, ingredient_id)
);

-- Recipes
CREATE TABLE recipes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT,
    instructions TEXT,
    category TEXT, -- e.g., 'Breakfast', 'Lunch', 'Dinner', 'Snack'
    prep_time_mins INT,
    cook_time_mins INT,
    macros_json JSONB,
    image_url TEXT,
    is_quickie BOOLEAN DEFAULT FALSE,
    is_exotic BOOLEAN DEFAULT FALSE,
    exotic_ingredient_id UUID REFERENCES ingredients(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Recipe Ingredients
CREATE TABLE recipe_ingredients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipe_id UUID REFERENCES recipes(id) ON DELETE CASCADE,
    ingredient_id UUID REFERENCES ingredients(id) ON DELETE CASCADE,
    quantity TEXT,
    unit TEXT,
    UNIQUE(recipe_id, ingredient_id)
);

-- Meal Plans
CREATE TABLE meal_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Meal Plan Items (Specific meals per day)
CREATE TABLE meal_plan_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    meal_plan_id UUID REFERENCES meal_plans(id) ON DELETE CASCADE,
    recipe_id UUID REFERENCES recipes(id) ON DELETE CASCADE,
    day_of_week TEXT NOT NULL, -- e.g., 'Monday'
    meal_type TEXT NOT NULL, -- e.g., 'Breakfast'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Post-Recipe Metrics (Ratings)
CREATE TABLE ratings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    recipe_id UUID REFERENCES recipes(id) ON DELETE CASCADE,
    action_check BOOLEAN DEFAULT FALSE, -- Did they cook it?
    difficulty INT CHECK (difficulty >= 1 AND difficulty <= 5), -- 1 to 5
    taste INT CHECK (taste >= 1 AND taste <= 5), -- 1 to 5
    macros_consumed_json JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- RLS (Row Level Security) Setup
-- Enable RLS for user-specific tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_ingredients ENABLE ROW LEVEL SECURITY;
ALTER TABLE meal_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE meal_plan_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;

-- Create Policies
CREATE POLICY "Users can view their own profile." ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update their own profile." ON profiles FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can manage their ingredient pool." ON user_ingredients FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can manage their meal plans." ON meal_plans FOR ALL USING (auth.uid() = user_id);
-- meal_plan_items requires join for policy or a simplified user_id column. We will add user_id for simpler RLS.
ALTER TABLE meal_plan_items ADD COLUMN user_id UUID REFERENCES profiles(id);
CREATE POLICY "Users can manage their meal plan items." ON meal_plan_items FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users can manage their ratings." ON ratings FOR ALL USING (auth.uid() = user_id);
