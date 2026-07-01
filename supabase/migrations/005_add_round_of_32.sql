-- =============================================================================
-- MIGRACIÓN 005 — Agregar stages faltantes del Mundial 2026
-- El formato de este torneo incluye 16avos de final (Round of 32)
-- y partido por el 3er puesto, que no estaban en el schema original.
-- =============================================================================

-- Eliminar el CHECK constraint antiguo y recrearlo con los stages completos
ALTER TABLE matches
  DROP CONSTRAINT IF EXISTS matches_stage_check;

ALTER TABLE matches
  ADD CONSTRAINT matches_stage_check
    CHECK (stage IN (
      'group',        -- Fase de grupos (72 partidos)
      'round_of_32',  -- 16avos de final (16 partidos) — NUEVO Mundial 2026
      'round_of_16',  -- Octavos de final (8 partidos)
      'quarter',      -- Cuartos de final (4 partidos)
      'semi',         -- Semifinales (2 partidos)
      'third_place',  -- Partido por el 3er puesto (1 partido) — NUEVO
      'final'         -- Final (1 partido)
    ));
