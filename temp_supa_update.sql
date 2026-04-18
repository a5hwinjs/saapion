-- Update Supabase Schema for Saapion

CREATE TABLE IF NOT EXISTS public.user_pantry (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    ingredient_id UUID REFERENCES public.ingredients(id) ON DELETE CASCADE,
    amount NUMERIC DEFAULT 0,
    unit TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(user_id, ingredient_id)
);

CREATE TABLE IF NOT EXISTS public.user_macros (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    calories NUMERIC DEFAULT 0,
    protein NUMERIC DEFAULT 0,
    carbs NUMERIC DEFAULT 0,
    fats NUMERIC DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(user_id, date)
);

ALTER TABLE public.user_pantry ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_macros ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their pantry." ON public.user_pantry FOR ALL USING (auth.uid() = user_id);
GRANT ALL ON public.user_pantry TO authenticated;

CREATE POLICY "Users can manage their macros." ON public.user_macros FOR ALL USING (auth.uid() = user_id);
GRANT ALL ON public.user_macros TO authenticated;
