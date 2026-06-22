-- =============================================================================
-- MIGRACIÓN 004 — Sistema de Puntos y Ranking Público
-- Ejecutar en el SQL Editor de Supabase
-- =============================================================================

-- --------------------------------------------------------
-- 1. Función que calcula los puntos de una predicción
--    - 3 puntos: resultado exacto (score exacto)
--    - 1 punto : acierto (ganó el mismo equipo o empate)
--    - 0 puntos: fallo
-- --------------------------------------------------------
CREATE OR REPLACE FUNCTION calculate_prediction_points(
  pred_home  INTEGER,
  pred_away  INTEGER,
  real_home  INTEGER,
  real_away  INTEGER
) RETURNS INTEGER AS $$
BEGIN
  -- Resultado exacto
  IF pred_home = real_home AND pred_away = real_away THEN
    RETURN 3;
  END IF;

  -- Acierto del resultado (local gana / visitante gana / empate)
  IF (pred_home > pred_away AND real_home > real_away) OR
     (pred_home < pred_away AND real_home < real_away) OR
     (pred_home = pred_away AND real_home = real_away) THEN
    RETURN 1;
  END IF;

  -- Fallo
  RETURN 0;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- --------------------------------------------------------
-- 2. Trigger que actualiza points_earned automáticamente
--    cuando un partido termina (status = 'finished')
-- --------------------------------------------------------
CREATE OR REPLACE FUNCTION update_prediction_points()
RETURNS TRIGGER AS $$
BEGIN
  -- Solo actuar cuando el partido pasa a 'finished' y tiene marcador
  IF NEW.status = 'finished'
     AND NEW.home_score IS NOT NULL
     AND NEW.away_score IS NOT NULL THEN

    UPDATE predictions
    SET points_earned = calculate_prediction_points(
                          predictions.home_score,
                          predictions.away_score,
                          NEW.home_score,
                          NEW.away_score
                        )
    WHERE match_id = NEW.id;

  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Eliminar trigger si ya existía para recrearlo limpiamente
DROP TRIGGER IF EXISTS on_match_finished_update_points ON matches;

CREATE TRIGGER on_match_finished_update_points
  AFTER UPDATE ON matches
  FOR EACH ROW EXECUTE FUNCTION update_prediction_points();

-- --------------------------------------------------------
-- 3. Vista pública de ranking (leaderboard)
--    Todos los usuarios autenticados pueden verla.
--    Agrega estadísticas por usuario.
-- --------------------------------------------------------
CREATE OR REPLACE VIEW public_leaderboard AS
SELECT
  p.user_id,
  pr.email,
  COUNT(p.id)                                                     AS total_predictions,
  COUNT(p.id) FILTER (WHERE p.points_earned = 3)                 AS exact_results,
  COUNT(p.id) FILTER (WHERE p.points_earned = 1)                 AS correct_outcomes,
  COUNT(p.id) FILTER (WHERE p.points_earned = 0)                 AS misses,
  COALESCE(SUM(p.points_earned), 0)                              AS total_points
FROM predictions p
LEFT JOIN profiles pr ON pr.id = p.user_id
WHERE p.points_earned IS NOT NULL
GROUP BY p.user_id, pr.email
ORDER BY total_points DESC, exact_results DESC, total_predictions DESC;

-- Permitir lectura de la vista a usuarios autenticados
GRANT SELECT ON public_leaderboard TO authenticated;

-- --------------------------------------------------------
-- 4. Actualizar puntos en predicciones ya existentes
--    (para partidos que ya terminaron antes de esta migración)
-- --------------------------------------------------------
UPDATE predictions p
SET points_earned = calculate_prediction_points(
                      p.home_score,
                      p.away_score,
                      m.home_score,
                      m.away_score
                    )
FROM matches m
WHERE p.match_id = m.id
  AND m.status    = 'finished'
  AND m.home_score IS NOT NULL
  AND m.away_score IS NOT NULL;
