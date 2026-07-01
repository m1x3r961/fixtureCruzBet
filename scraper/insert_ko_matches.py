"""
Script para insertar los partidos de la fase de eliminación directa del Mundial 2026.
Los 72 partidos de fase de grupos ya están en la BD. Este script agrega los 32 restantes.
Ejecutar UNA SOLA VEZ tras aplicar la migración 005 en Supabase.
"""
import os
import requests
import sys
import io
from supabase import create_client, Client
from dotenv import load_dotenv

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

load_dotenv(dotenv_path="../.env")
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_SERVICE_ROLE_KEY") or os.environ.get("SUPABASE_ANON_KEY")
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

FIFA_API_URL = "https://api.fifa.com/api/v3/calendar/matches?language=en&count=500&idSeason=285023"

STAGE_MAP = {
    "First Stage":              "group",
    "Round of 32":              "round_of_32",
    "Round of 16":              "round_of_16",
    "Quarter-final":            "quarter",
    "Semi-final":               "semi",
    "Play-off for third place": "third_place",
    "Final":                    "final",
}

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

TEAM_TRANSLATIONS = {
    "South Africa": "Sudáfrica", "Mexico": "México", "Korea Republic": "Corea del Sur",
    "Czechia": "Rep. Checa", "Canada": "Canadá", "Bosnia and Herzegovina": "Bosnia y Herzegovina",
    "USA": "Estados Unidos", "Qatar": "Catar", "Switzerland": "Suiza", "Brazil": "Brasil",
    "Morocco": "Marruecos", "Haiti": "Haití", "Türkiye": "Turquía", "Germany": "Alemania",
    "Curaçao": "Curazao", "Netherlands": "Países Bajos", "Japan": "Japón",
    "Côte d'Ivoire": "Costa de Marfil", "Sweden": "Suecia", "Tunisia": "Túnez",
    "Spain": "España", "Belgium": "Bélgica", "Egypt": "Egipto", "Saudi Arabia": "Arabia Saudita",
    "IR Iran": "Irán", "New Zealand": "Nueva Zelanda", "France": "Francia", "Iraq": "Irak",
    "Norway": "Noruega", "Algeria": "Argelia", "Jordan": "Jordania", "Congo DR": "RD Congo",
    "England": "Inglaterra", "Panama": "Panamá", "Uzbekistan": "Uzbekistán",
    "Croatia": "Croacia", "Scotland": "Escocia", "Ecuador": "Ecuador",
    "Paraguay": "Paraguay", "Austria": "Austria", "Portugal": "Portugal",
    "Australia": "Australia", "Argentina": "Argentina", "Colombia": "Colombia",
    "Ghana": "Ghana", "Senegal": "Senegal", "Cabo Verde": "Cabo Verde",
}

def translate(name):
    return TEAM_TRANSLATIONS.get(name, name)

def map_status(code):
    if code == 0: return 'finished'
    elif code == 3: return 'live'
    return 'scheduled'

def main():
    print("Obteniendo partidos de la API de FIFA...")
    headers = {"User-Agent": "Mozilla/5.0"}
    r = requests.get(FIFA_API_URL, headers=headers)
    if r.status_code != 200:
        print(f"Error: {r.status_code}")
        return

    matches = r.json().get("Results", [])
    print(f"Total partidos en FIFA API: {len(matches)}")

    # Solo procesar fases de eliminación directa (no grupos)
    ko_stages = {"Round of 32", "Round of 16", "Quarter-final", "Semi-final", "Play-off for third place", "Final"}

    # Obtener partidos ya existentes en BD
    existing = supabase.table("matches").select("home_team,away_team").execute().data
    existing_set = {(m["home_team"], m["away_team"]) for m in existing}
    print(f"Partidos ya en BD: {len(existing_set)}")

    inserted = 0
    updated = 0
    skipped = 0

    for m in matches:
        stage_raw = m.get("StageName", [{}])[0].get("Description", "") if m.get("StageName") else ""
        if stage_raw not in ko_stages:
            continue

        home_data = m.get("Home")
        away_data = m.get("Away")
        if not home_data or not away_data:
            continue

        home_en = home_data.get("TeamName", [{}])[0].get("Description", "")
        away_en = away_data.get("TeamName", [{}])[0].get("Description", "")
        if not home_en or not away_en:
            continue

        home_es = translate(home_en)
        away_es = translate(away_en)
        stage = STAGE_MAP.get(stage_raw, "round_of_32")
        status = map_status(m.get("MatchStatus"))
        match_time = m.get("Date", "")
        home_score = m.get("HomeTeamScore")
        away_score = m.get("AwayTeamScore")

        # Nombre descriptivo del grupo (ej: "16avos de Final", "Cuartos de Final")
        stage_labels = {
            "round_of_32": "16avos de Final",
            "round_of_16": "Octavos de Final",
            "quarter":     "Cuartos de Final",
            "semi":        "Semifinal",
            "third_place": "Tercer Puesto",
            "final":       "Final",
        }
        group_name = stage_labels.get(stage, stage_raw)

        row = {
            "home_team":   home_es,
            "away_team":   away_es,
            "stage":       stage,
            "group_name":  group_name,
            "match_time":  match_time,
            "status":      status,
            "home_flag":   flag_url(home_es),
            "away_flag":   flag_url(away_es),
        }
        if home_score is not None:
            row["home_score"] = home_score
        if away_score is not None:
            row["away_score"] = away_score

        if (home_es, away_es) in existing_set:
            # Actualizar si ya existe (puede tener score ahora)
            res = supabase.table("matches").update({
                "stage":       stage,
                "group_name":  group_name,
                "status":      status,
                **({"home_score": home_score, "away_score": away_score} if home_score is not None else {}),
            }).eq("home_team", home_es).eq("away_team", away_es).execute()
            print(f"[UPD] {home_es} vs {away_es} ({stage_raw})")
            updated += 1
        else:
            # Insertar nuevo
            res = supabase.table("matches").insert(row).execute()
            print(f"[INS] {home_es} vs {away_es} ({stage_raw}) → {status}")
            inserted += 1
            existing_set.add((home_es, away_es))

    print(f"\nCompletado: {inserted} insertados, {updated} actualizados, {skipped} omitidos.")

if __name__ == "__main__":
    main()
