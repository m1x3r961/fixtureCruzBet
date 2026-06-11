-- =============================================================================
-- Migración 003: Corregir recursión infinita en RLS
-- Ejecutar en el SQL Editor de Supabase
-- =============================================================================

-- 1. Crear función SECURITY DEFINER para verificar si el usuario es admin
-- Esto evita la recursión infinita (infinite loop) al consultar la tabla profiles
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
DECLARE
  v_role TEXT;
BEGIN
  SELECT role INTO v_role FROM public.profiles WHERE id = auth.uid();
  RETURN v_role = 'admin';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Corregir la política de la tabla profiles
DROP POLICY IF EXISTS "Admins can view all profiles" ON public.profiles;
CREATE POLICY "Admins can view all profiles" 
  ON public.profiles FOR SELECT 
  USING (public.is_admin());

-- 3. Corregir la política de la tabla predictions
DROP POLICY IF EXISTS "Users can view own or admins can view all" ON public.predictions;
CREATE POLICY "Users can view own or admins can view all"
  ON public.predictions FOR SELECT
  USING (
    user_id = auth.uid() OR public.is_admin()
  );
