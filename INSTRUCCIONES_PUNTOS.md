# 📋 Instrucciones para Activar el Sistema de Puntos

## Paso 1 — Ejecutar la Migración SQL en Supabase

Ve a tu **Supabase Dashboard → SQL Editor** y ejecuta el contenido de:

```
supabase/migrations/004_points_and_ranking.sql
```

Este script hace:
- ✅ Crea función `calculate_prediction_points()` (3 exacto / 1 acierto / 0 fallo)
- ✅ Crea trigger que actualiza puntos automáticamente cuando un partido termina
- ✅ Crea vista `public_leaderboard` accesible a todos los usuarios autenticados
- ✅ Recalcula puntos de predicciones ya existentes (partidos ya finalizados)

## Paso 2 — Verificar la Vista

Después de ejecutar el SQL, verifica en Supabase:

```sql
SELECT * FROM public_leaderboard LIMIT 10;
```

Deberías ver los usuarios con sus puntos calculados.

## Paso 3 — Ejecutar la App

```bash
flutter run -d chrome
```

El botón **🏆 Ranking** aparece en la AppBar del fixture.
