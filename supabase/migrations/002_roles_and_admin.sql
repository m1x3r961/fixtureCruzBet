-- =============================================================================
-- ESQUEMA DE BASE DE DATOS — Migración 002: Perfiles y Roles (Admin Dashboard)
-- Ejecutar en el SQL Editor de Supabase
-- =============================================================================

-- --------------------------------------------------------
-- 1. Tabla: profiles
-- Almacena información adicional del usuario, como su rol.
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'admin')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Habilitar Row Level Security para la tabla profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Política: Un usuario puede ver su propio perfil
CREATE POLICY "Users can view own profile" 
  ON public.profiles FOR SELECT 
  USING (auth.uid() = id);

-- Política: Los administradores pueden ver todos los perfiles
CREATE POLICY "Admins can view all profiles" 
  ON public.profiles FOR SELECT 
  USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- --------------------------------------------------------
-- 2. Función y Trigger: Asignar rol automáticamente al registrarse
-- Si no hay perfiles en la base de datos, el primero será 'admin'.
-- Los demás serán 'user'.
-- --------------------------------------------------------
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  v_count INT;
BEGIN
  SELECT count(*) INTO v_count FROM public.profiles;
  INSERT INTO public.profiles (id, email, role)
  VALUES (
    NEW.id,
    NEW.email,
    CASE WHEN v_count = 0 THEN 'admin' ELSE 'user' END
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Crear el trigger que se ejecuta DESPUÉS de que un usuario se registra
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- --------------------------------------------------------
-- 3. Script de Retroactividad (Backfill)
-- Asignar perfiles a los usuarios que ya se registraron en el pasado.
-- El primer usuario registrado (ordenado por created_at) será 'admin'.
-- --------------------------------------------------------
INSERT INTO public.profiles (id, email, role)
SELECT 
  id, 
  email, 
  CASE WHEN (row_number() OVER (ORDER BY created_at ASC)) = 1 THEN 'admin' ELSE 'user' END
FROM auth.users
ON CONFLICT (id) DO NOTHING;

-- --------------------------------------------------------
-- 4. Modificar RLS de la tabla 'predictions'
-- Permitir que los administradores lean TODAS las predicciones
-- --------------------------------------------------------
DROP POLICY IF EXISTS "Users can view own predictions" ON public.predictions;

-- Nueva política: El dueño puede ver sus predicciones, o un admin puede verlas todas.
CREATE POLICY "Users can view own or admins can view all"
  ON public.predictions FOR SELECT
  USING (
    user_id = auth.uid() OR
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );
