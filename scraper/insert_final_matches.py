"""
Script para insertar/actualizar los partidos de Final y 3er/4to lugar.
Determina los clasificados leyendo los resultados de las semifinales en la BD.
"""
import os, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

from dotenv import load_dotenv
load_dotenv(dotenv_path="../.env")
from supabase import create_client

SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_SERVICE_ROLE_KEY") or os.environ.get("SUPABASE_ANON_KEY")
sb = create_client(SUPABASE_URL, SUPABASE_KEY)

FLAG_CODES = {
    "México": "mx", "Sudáfrica": "za", "Corea del Sur": "kr", "Rep. Checa": "cz",
    "Canadá": "ca", "Bosnia y Herzegovina": "ba", "Estados Unidos": "us", "Catar": "qa",
    "Suiza": "ch", "Brasil": "br", "Marruecos": "ma", "Haití": "ht", "Turquía": "tr",
    "Alemania": "de", "Curazao": "cw", "Países Bajos": "nl", "Japón": "jp",
    "Costa de Marfil": "ci", "Suecia": "se", "Túnez": "tn", "España": "es",
    "Bélgica": "be", "Egipto": "eg", "Arabia Saudita": "sa", "Irán": "ir",
    "Nueva Zelanda": "nz", "Francia": "fr", "Irak": "iq", "Noruega": "no",
    "Argelia": "dz", "Jordania": "jo", "RD Congo": "cd", "Inglaterra": "gb-eng",
    "Panamá": "pa", "Uzbekistán": "uz", "Croacia": "hr", "Escocia": "gb-sct",
    "Ecuador": "ec", "Paraguay": "py", "Austria": "at", "Portugal": "pt",
    "Australia": "au", "Argentina": "ar", "Colombia": "co", "Ghana": "gh",
    "Senegal": "sn", "Cabo Verde": "cv", "Uruguay": "uy", "Polonia": "pl",
    "Dinamarca": "dk", "Nigeria": "ng", "Camerún": "cm", "Serbia": "rs",
    "Rumania": "ro", "Ucrania": "ua", "Georgia": "ge", "Indonesia": "id",
}

def flag_url(team):
    code = FLAG_CODES.get(team)
    return f"https://flagcdn.com/w320/{code}.png" if code else None

TBD = "Por definir"  # Placeholder para equipo no confirmado

def get_winner(match):
    """Dado un partido terminado, devuelve (ganador, perdedor)."""
    if match["home_score"] is None or match["away_score"] is None:
        return None, None
    if match["home_score"] > match["away_score"]:
        return match["home_team"], match["away_team"]
    elif match["away_score"] > match["home_score"]:
        return match["away_team"], match["home_team"]
    else:
        return None, None  # Empate (no debería pasar en KO sin penales en BD)

def upsert_match(home, away, stage, group_name, match_time, home_score=None, away_score=None, status="scheduled"):
    existing = sb.table("matches").select("id,home_team,away_team").eq("stage", stage).execute().data

    home_flag = flag_url(home)
    away_flag = flag_url(away)

    row = {
        "home_team": home,
        "away_team": away,
        "stage": stage,
        "group_name": group_name,
        "match_time": match_time,
        "status": status,
        "home_flag": home_flag,
        "away_flag": away_flag,
    }
    if home_score is not None:
        row["home_score"] = home_score
    if away_score is not None:
        row["away_score"] = away_score

    # Buscar si ya existe este stage
    if existing:
        match_id = existing[0]["id"]
        sb.table("matches").update(row).eq("id", match_id).execute()
        print(f"[UPD] {group_name}: {home} vs {away} | {status}")
    else:
        sb.table("matches").insert(row).execute()
        print(f"[INS] {group_name}: {home} vs {away} | {status}")

def main():
    # Obtener las 2 semifinales
    semis = sb.table("matches").select("*").eq("stage", "semi").execute().data
    print(f"Semifinales encontradas: {len(semis)}")
    for s in semis:
        print(f"  {s['home_team']} {s.get('home_score','?')} - {s.get('away_score','?')} {s['away_team']} | {s['status']}")

    # Determinar ganadores/perdedores de cada semi
    finalists = []
    third_place_teams = []

    for semi in semis:
        if semi["status"] == "finished":
            winner, loser = get_winner(semi)
            finalists.append(winner)
            third_place_teams.append(loser)
        else:
            finalists.append(None)  # Aún no jugado
            third_place_teams.append(None)

    print(f"\nFinalistas confirmados: {[t for t in finalists if t]}")
    print(f"3er/4to confirmados:    {[t for t in third_place_teams if t]}")

    # Construir equipos para Final
    final_home = finalists[0] if finalists[0] else TBD
    final_away = finalists[1] if len(finalists) > 1 and finalists[1] else TBD

    # Construir equipos para 3er/4to
    third_home = third_place_teams[0] if third_place_teams[0] else TBD
    third_away = third_place_teams[1] if len(third_place_teams) > 1 and third_place_teams[1] else TBD

    # Fechas aproximadas del Mundial 2026 (ajustar si FIFA confirma otras)
    FINAL_DATE = "2026-07-19T20:00:00+00:00"
    THIRD_DATE = "2026-07-19T16:00:00+00:00"

    print("\n--- Actualizando Final ---")
    upsert_match(
        home=final_home, away=final_away,
        stage="final", group_name="Final",
        match_time=FINAL_DATE,
    )

    print("\n--- Actualizando 3er/4to Puesto ---")
    upsert_match(
        home=third_home, away=third_away,
        stage="third_place", group_name="Tercer Puesto",
        match_time=THIRD_DATE,
    )

    print("\n✅ Completado.")

if __name__ == "__main__":
    main()
