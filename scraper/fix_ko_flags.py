"""
Script para agregar las URLs de banderas a los partidos de eliminación directa
que fueron insertados sin home_flag / away_flag.
"""
import os, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
from supabase import create_client
from dotenv import load_dotenv

load_dotenv(dotenv_path="../.env")
sb = create_client(
    os.environ['SUPABASE_URL'],
    os.environ.get('SUPABASE_SERVICE_ROLE_KEY') or os.environ.get('SUPABASE_ANON_KEY')
)

# Mapa equipo (español) → código ISO 3166-1 alpha-2 para flagcdn.com
FLAG_CODES = {
    "México":               "mx",
    "Sudáfrica":            "za",
    "Corea del Sur":        "kr",
    "Rep. Checa":           "cz",
    "Canadá":               "ca",
    "Bosnia y Herzegovina": "ba",
    "Estados Unidos":       "us",
    "Catar":                "qa",
    "Suiza":                "ch",
    "Brasil":               "br",
    "Marruecos":            "ma",
    "Haití":                "ht",
    "Turquía":              "tr",
    "Alemania":             "de",
    "Curazao":              "cw",
    "Países Bajos":         "nl",
    "Japón":                "jp",
    "Costa de Marfil":      "ci",
    "Suecia":               "se",
    "Túnez":                "tn",
    "España":               "es",
    "Bélgica":              "be",
    "Egipto":               "eg",
    "Arabia Saudita":       "sa",
    "Irán":                 "ir",
    "Nueva Zelanda":        "nz",
    "Francia":              "fr",
    "Irak":                 "iq",
    "Noruega":              "no",
    "Argelia":              "dz",
    "Jordania":             "jo",
    "RD Congo":             "cd",
    "Inglaterra":           "gb-eng",
    "Panamá":               "pa",
    "Uzbekistán":           "uz",
    "Croacia":              "hr",
    "Escocia":              "gb-sct",
    "Ecuador":              "ec",
    "Paraguay":             "py",
    "Austria":              "at",
    "Portugal":             "pt",
    "Australia":            "au",
    "Argentina":            "ar",
    "Colombia":             "co",
    "Ghana":                "gh",
    "Senegal":              "sn",
    "Cabo Verde":           "cv",
    "Uruguay":              "uy",
    "Venezuela":            "ve",
    "Chile":                "cl",
    "Perú":                 "pe",
    "Bolivia":              "bo",
    "Polonia":              "pl",
    "Dinamarca":            "dk",
    "Eslovaquia":           "sk",
    "Rumania":              "ro",
    "Hungría":              "hu",
    "Albania":              "al",
    "Eslovenia":            "si",
    "Georgia":              "ge",
    "Ucrania":              "ua",
    "Serbia":               "rs",
    "Nigeria":              "ng",
    "Camerún":              "cm",
    "Mali":                 "ml",
    "Tanzania":             "tz",
    "Zambia":               "zm",
    "Angola":               "ao",
    "Mozambique":           "mz",
    "Kenya":                "ke",
    "Benín":                "bj",
    "Guinea":               "gn",
    "Tanzania":             "tz",
    "Indonesia":            "id",
    "Tailandia":            "th",
    "Vietnam":              "vn",
    "Arabia Saudita":       "sa",
    "Emiratos Árabes":      "ae",
    "Irak":                 "iq",
}

def flag_url(team_name):
    code = FLAG_CODES.get(team_name)
    if code:
        return f"https://flagcdn.com/w320/{code}.png"
    return None

def main():
    # Obtener todos los partidos de KO sin bandera
    ko_stages = ['round_of_32', 'round_of_16', 'quarter', 'semi', 'third_place', 'final']
    matches = sb.table('matches').select('id,home_team,away_team,home_flag,away_flag,stage').in_('stage', ko_stages).execute().data

    print(f"Partidos KO en BD: {len(matches)}")
    updated = 0
    missing = []

    for m in matches:
        home_flag = flag_url(m['home_team'])
        away_flag = flag_url(m['away_team'])

        # Solo actualizar si hay cambio
        if m.get('home_flag') == home_flag and m.get('away_flag') == away_flag:
            continue

        if not home_flag:
            missing.append(m['home_team'])
        if not away_flag:
            missing.append(m['away_team'])

        payload = {}
        if home_flag:
            payload['home_flag'] = home_flag
        if away_flag:
            payload['away_flag'] = away_flag

        if payload:
            sb.table('matches').update(payload).eq('id', m['id']).execute()
            print(f"[OK] {m['home_team']} vs {m['away_team']} → banderas actualizadas")
            updated += 1

    if missing:
        print(f"\n[!] Sin código de bandera: {set(missing)}")

    print(f"\nCompletado: {updated} partidos actualizados con banderas.")

if __name__ == "__main__":
    main()
