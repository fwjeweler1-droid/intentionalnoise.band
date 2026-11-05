-- Intentional Noise .band artist-page registry
-- Run once in the EXISTING Connect Supabase project's SQL Editor.
-- Existing musician_profiles records are never overwritten; no profiles auto-publish.
CREATE TABLE IF NOT EXISTS public.artist_pages (
 user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
 slug text NOT NULL UNIQUE CHECK (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$' AND length(slug) BETWEEN 3 AND 90),
 display_name text NOT NULL CHECK (char_length(display_name) BETWEEN 2 AND 100),
 bio text NOT NULL DEFAULT '' CHECK (char_length(bio) <= 2000),
 logo_url text,
 showcase_url text,
 showcase_type text CHECK (showcase_type IN ('image','reel')),
 published boolean NOT NULL DEFAULT false,
 approved_at timestamptz,
 created_at timestamptz NOT NULL DEFAULT now(),
 updated_at timestamptz NOT NULL DEFAULT now(),
 CONSTRAINT approved_before_published CHECK (NOT published OR approved_at IS NOT NULL)
);
ALTER TABLE public.artist_pages ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.artist_pages FROM anon, authenticated;
GRANT SELECT ON public.artist_pages TO anon, authenticated;
GRANT INSERT (user_id,slug,display_name,bio) ON public.artist_pages TO authenticated;
GRANT UPDATE (slug,display_name,bio) ON public.artist_pages TO authenticated;
DROP POLICY IF EXISTS "Public reads approved published pages" ON public.artist_pages;
CREATE POLICY "Public reads approved published pages" ON public.artist_pages FOR SELECT TO anon, authenticated USING (published AND approved_at IS NOT NULL);
DROP POLICY IF EXISTS "Owner reads drafts" ON public.artist_pages;
CREATE POLICY "Owner reads drafts" ON public.artist_pages FOR SELECT TO authenticated USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "Owner creates draft" ON public.artist_pages;
CREATE POLICY "Owner creates draft" ON public.artist_pages FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Owner edits draft" ON public.artist_pages;
CREATE POLICY "Owner edits draft" ON public.artist_pages FOR UPDATE TO authenticated USING (auth.uid() = user_id AND published = false) WITH CHECK (auth.uid() = user_id AND published = false);
-- Publishing, approval, media URLs and logo URLs require trusted admin moderation, not browser updates.
CREATE OR REPLACE FUNCTION public.ensure_artist_page() RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
DECLARE base_slug text;
BEGIN
 base_slug := trim(both '-' FROM regexp_replace(lower(coalesce(new.display_name,'')),'[^a-z0-9]+','-','g'));
 IF length(base_slug)<2 THEN base_slug:='artist'; END IF;
 base_slug:=left(base_slug,65);
 INSERT INTO public.artist_pages(user_id,slug,display_name,bio,published)
 VALUES(new.user_id,base_slug||'-'||left(replace(new.user_id::text,'-',''),8),
        left(coalesce(nullif(trim(new.display_name),''),'Artist'),100),
        left(coalesce(new.bio,''),2000),false)
 ON CONFLICT(user_id) DO NOTHING;
 RETURN new;
END $$;
DROP TRIGGER IF EXISTS create_artist_page_on_profile ON public.musician_profiles;
CREATE TRIGGER create_artist_page_on_profile AFTER INSERT ON public.musician_profiles
FOR EACH ROW EXECUTE FUNCTION public.ensure_artist_page();
INSERT INTO public.artist_pages(user_id,slug,display_name,bio,published)
SELECT user_id,
 left(coalesce(nullif(trim(both '-' from regexp_replace(lower(display_name),'[^a-z0-9]+','-','g')),''),'artist'),65)
 ||'-'||left(replace(user_id::text,'-',''),8),
 left(display_name,100),left(coalesce(bio,''),2000),false
FROM public.musician_profiles
WHERE user_id IS NOT NULL AND char_length(display_name)>=2
ON CONFLICT(user_id) DO NOTHING;
-- IMPORTANT: musician_profiles.is_public is only opt-in to signed-in member discovery.
-- This migration never automatically grants anonymous publication to Nerdly, Tom, or anyone.
-- Reviewed media must be 60-second-or-less approved Reels or artist-approved images.
