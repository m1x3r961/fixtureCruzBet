-- =============================================================================
-- ESQUEMA DE BASE DE DATOS — Fixture CruzBet Mundial
-- Ejecutar en el SQL Editor de Supabase en el siguiente orden
-- =============================================================================

-- --------------------------------------------------------
-- 1. Tabla: matches
-- Contiene todos los partidos del Mundial.
-- Los datos se sincronizan desde API-Football via Edge Function.
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS matches (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  api_football_id INTEGER UNIQUE,           -- ID de API-Football (clave de upsert)
  home_team       TEXT NOT NULL,
  away_team       TEXT NOT NULL,
  home_score      INTEGER,                  -- NULL hasta que inicie el partido
  away_score      INTEGER,
  match_time      TIMESTAMPTZ NOT NULL,
  status          TEXT NOT NULL DEFAULT 'scheduled'
                    CHECK (status IN ('scheduled', 'live', 'finished')),
  stage           TEXT DEFAULT 'group'
                    CHECK (stage IN ('group', 'round_of_16', 'quarter', 'semi', 'final')),
  group_name      TEXT,                     -- Ej: 'Group A', 'Quarter-final'
  home_flag       TEXT,                     -- URL logo equipo local (API-Football)
  away_flag       TEXT,                     -- URL logo equipo visitante
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Índices para consultas frecuentes
CREATE INDEX idx_matches_status ON matches(status);
CREATE INDEX idx_matches_stage ON matches(stage);
CREATE INDEX idx_matches_match_time ON matches(match_time);

-- Habilitar Realtime en la tabla matches
-- Ir a Dashboard → Database → Replication → y activar 'matches'
ALTER PUBLICATION supabase_realtime ADD TABLE matches;

-- --------------------------------------------------------
-- 2. Tabla: predictions
-- Predicciones de los usuarios para cada partido.
-- RLS activo: cada usuario solo ve/modifica sus predicciones.
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS predictions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  match_id        UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
  home_score      INTEGER NOT NULL DEFAULT 0,
  away_score      INTEGER NOT NULL DEFAULT 0,
  points_earned   INTEGER,                  -- NULL hasta que el partido termine
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW(),

  -- Un usuario solo puede tener UNA predicción por partido
  UNIQUE(user_id, match_id)
);

CREATE INDEX idx_predictions_user_id ON predictions(user_id);
CREATE INDEX idx_predictions_match_id ON predictions(match_id);

-- --------------------------------------------------------
-- 3. Tabla: sync_log
-- Registro de sincronizaciones con API-Football.
-- Permite a la app verificar si ya se sincronizó hoy.
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS sync_log (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sync_type   TEXT NOT NULL,               -- 'api_football'
  match_count INTEGER,
  synced_at   TIMESTAMPTZ DEFAULT NOW()
);

-- --------------------------------------------------------
-- 4. Row Level Security (RLS) — Tabla predictions
-- --------------------------------------------------------
ALTER TABLE predictions ENABLE ROW LEVEL SECURITY;

-- Política: Los usuarios ven SOLO sus propias predicciones
CREATE POLICY "Users can view own predictions"
  ON predictions FOR SELECT
  USING (user_id = auth.uid());

-- Política: Los usuarios solo insertan con su propio user_id
CREATE POLICY "Users can insert own predictions"
  ON predictions FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- Política: Los usuarios solo actualizan sus predicciones
CREATE POLICY "Users can update own predictions"
  ON predictions FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- Política: No se permiten deletes (preservar historial)
-- CREATE POLICY "No delete predictions" ON predictions FOR DELETE USING (false);

-- --------------------------------------------------------
-- 5. RLS — Tabla matches (solo lectura para usuarios)
-- --------------------------------------------------------
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;

-- Todos los usuarios autenticados pueden leer los partidos
CREATE POLICY "Anyone can read matches"
  ON matches FOR SELECT
  USING (true);

-- Solo el service_role puede insertar/actualizar partidos (via Edge Function)
-- No se crean políticas de INSERT/UPDATE → solo service_role puede hacerlo

-- --------------------------------------------------------
-- 6. Trigger: updated_at automático
-- --------------------------------------------------------
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER matches_updated_at
  BEFORE UPDATE ON matches
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER predictions_updated_at
  BEFORE UPDATE ON predictions
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- --------------------------------------------------------
-- 7. Datos de prueba (opcional — comentar en producción)
-- --------------------------------------------------------
INSERT INTO matches (home_team, away_team, match_time, status, stage, group_name)
VALUES
  ('Argentina', 'Francia',    NOW() + INTERVAL '2 hours',  'scheduled', 'final',   'Final'),
  ('España',    'Brasil',     NOW() + INTERVAL '5 days',   'scheduled', 'semi',    'Semifinal'),
  ('Uruguay',   'Alemania',   NOW() - INTERVAL '2 hours',  'live',      'group',   'Grupo A'),
  ('Colombia',  'Portugal',   NOW() - INTERVAL '1 day',    'finished',  'group',   'Grupo B')
ON CONFLICT DO NOTHING;
