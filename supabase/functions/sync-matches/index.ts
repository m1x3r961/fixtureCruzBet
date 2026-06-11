// =============================================================================
// Supabase Edge Function: sync-matches
// Archivo: supabase/functions/sync-matches/index.ts
//
// PROPÓSITO: Sincroniza los partidos del Mundial desde API-Football
//            hacia la tabla `matches` en Supabase.
//
// DESPLIEGUE:
//   supabase functions deploy sync-matches
//
// CONFIGURAR SECRETS (en el dashboard de Supabase o CLI):
//   supabase secrets set API_FOOTBALL_KEY=tu_key_aqui
//   supabase secrets set WORLD_CUP_LEAGUE_ID=1
//   supabase secrets set WORLD_CUP_SEASON=2026
//
// PROGRAMAR EJECUCIÓN DIARIA con pg_cron (en Supabase SQL Editor):
//   SELECT cron.schedule(
//     'sync-matches-daily',
//     '0 6 * * *',  -- Todos los días a las 6:00 AM UTC
//     $$
//       SELECT net.http_post(
//         url := 'https://<tu-proyecto>.supabase.co/functions/v1/sync-matches',
//         headers := '{"Authorization": "Bearer <service_role_key>"}'::jsonb
//       );
//     $$
//   );
// =============================================================================

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const API_FOOTBALL_BASE = "https://v3.football.api-sports.io";
const LEAGUE_ID = Deno.env.get("WORLD_CUP_LEAGUE_ID") ?? "1";
const SEASON = Deno.env.get("WORLD_CUP_SEASON") ?? "2026";
const API_KEY = Deno.env.get("API_FOOTBALL_KEY")!;

// Cliente con service_role para ignorar RLS en operaciones de sync
const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

serve(async (req: Request) => {
  // Solo aceptar POST
  if (req.method !== "POST") {
    return new Response("Method Not Allowed", { status: 405 });
  }

  try {
    console.log(`[sync-matches] Iniciando sincronización. League: ${LEAGUE_ID}, Season: ${SEASON}`);

    // 1. Obtener partidos de API-Football
    const apiResponse = await fetch(
      `${API_FOOTBALL_BASE}/fixtures?league=${LEAGUE_ID}&season=${SEASON}`,
      {
        headers: {
          "x-apisports-key": API_KEY,
          "Accept": "application/json",
        },
      }
    );

    if (!apiResponse.ok) {
      throw new Error(`API-Football error: ${apiResponse.status}`);
    }

    const data = await apiResponse.json();
    const fixtures = data.response as any[];

    console.log(`[sync-matches] Obtenidos ${fixtures.length} partidos de API-Football`);

    // 2. Transformar al formato de la tabla matches
    const matchRows = fixtures.map((fixture: any) => {
      const { fixture: f, teams, goals, league } = fixture;
      const apiStatus = f.status?.short ?? "TBD";

      return {
        api_football_id: f.id,
        home_team: teams.home.name,
        away_team: teams.away.name,
        home_score: goals?.home ?? null,
        away_score: goals?.away ?? null,
        match_time: f.date,
        status: mapStatus(apiStatus),
        stage: mapRound(league.round ?? ""),
        group_name: league.round ?? null,
        home_flag: teams.home.logo ?? null,
        away_flag: teams.away.logo ?? null,
      };
    });

    // 3. Upsert en Supabase usando api_football_id como clave de conflicto
    const { error } = await supabase
      .from("matches")
      .upsert(matchRows, { onConflict: "api_football_id" });

    if (error) throw error;

    // 4. Registrar la sincronización en sync_log
    await supabase.from("sync_log").insert({
      sync_type: "api_football",
      match_count: matchRows.length,
      synced_at: new Date().toISOString(),
    });

    console.log(`[sync-matches] ✅ Sincronizados ${matchRows.length} partidos`);

    return new Response(
      JSON.stringify({
        success: true,
        matchesSynced: matchRows.length,
        timestamp: new Date().toISOString(),
      }),
      { headers: { "Content-Type": "application/json" }, status: 200 }
    );
  } catch (error) {
    console.error("[sync-matches] ❌ Error:", error);
    return new Response(
      JSON.stringify({ success: false, error: String(error) }),
      { headers: { "Content-Type": "application/json" }, status: 500 }
    );
  }
});

function mapStatus(apiStatus: string): string {
  switch (apiStatus) {
    case "NS": return "scheduled";
    case "1H":
    case "2H":
    case "HT":
    case "ET":
    case "P": return "live";
    case "FT":
    case "AET":
    case "PEN": return "finished";
    default: return "scheduled";
  }
}

function mapRound(round: string): string {
  const lower = round.toLowerCase();
  if (lower.includes("group")) return "group";
  if (lower.includes("round of 16")) return "round_of_16";
  if (lower.includes("quarter")) return "quarter";
  if (lower.includes("semi")) return "semi";
  if (lower.includes("final")) return "final";
  return "group";
}
