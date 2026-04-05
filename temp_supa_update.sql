-- Temporary Update Script for Saapion Schema
-- Run this in your Supabase SQL Editor to add image support to your existing tables

-- 1. Add image_url column to the ingredients table
-- (The recipes table already has an image_url column from the initial schema)
ALTER TABLE public.ingredients 
ADD COLUMN IF NOT EXISTS image_url TEXT;

-- 2. Create the Storage Bucket for Saapion Images
-- This creates a public bucket called 'saapion-images'
INSERT INTO storage.buckets (id, name, public) 
VALUES ('saapion-images', 'saapion-images', true)
ON CONFLICT (id) DO NOTHING;

-- 3. Set up Storage Security Policies (RLS) for the new bucket
-- (RLS is enabled by default on storage.objects in Supabase)

-- Allow public read access to all images (so the frontend can render them)
CREATE POLICY "Public Access" 
ON storage.objects FOR SELECT 
USING ( bucket_id = 'saapion-images' );

-- Allow authenticated users to upload new images
CREATE POLICY "Authenticated users can upload images" 
ON storage.objects FOR INSERT 
WITH CHECK (
    bucket_id = 'saapion-images' 
    AND auth.role() = 'authenticated'
);

-- Allow users to update ONLY the images they uploaded
CREATE POLICY "Users can update their own images"
ON storage.objects FOR UPDATE
USING (
    bucket_id = 'saapion-images' 
    AND auth.uid() = owner
);

-- Allow users to delete ONLY the images they uploaded
CREATE POLICY "Users can delete their own images"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'saapion-images' 
    AND auth.uid() = owner
);
