import os
import requests
from supabase import create_client, Client

# --- CONFIGURACIÓN ---
# Usamos las variables de entorno de tu proyecto
from dotenv import load_dotenv
load_dotenv(dotenv_path="../.env")

SUPABASE_URL = os.environ.get("SUPABASE_URL")
# NOTA: Para hacer UPDATES desde un script Python a una tabla con RLS, 
# se recomienda usar la SUPABASE_SERVICE_ROLE_KEY. 
# Si tu ANON_KEY tiene permisos abiertos, funcionará.
SUPABASE_KEY = os.environ.get("SUPABASE_SERVICE_ROLE_KEY") or os.environ.get("SUPABASE_ANON_KEY")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

FIFA_API_URL = "https://api.fifa.com/api/v3/calendar/matches?language=en&count=500&idSeason=285023"

def map_match_status(match_status_int):
    # En la API de FIFA: 
    # 0 = FINISHED (FT)
    # 1 = NO INICIADO / SCHEDULED?
    # 3 = EN VIVO?
    # Hay varios códigos, si tiene score y status=0, es finished
    if match_status_int == 0:
        return 'FINISHED'
    elif match_status_int == 3:
        return 'LIVE'
    else:
        return 'SCHEDULED'

def map_team_name(name):
    # Puedes agregar traducciones manuales si en tu BD difieren del inglés
    # Ejemplo: "South Africa" -> "Sudáfrica"
    translations = {
        "South Africa": "Sudáfrica",
        "Mexico": "México",
        "Korea Republic": "Corea del Sur",
        "Czechia": "Rep. Checa"
    }
    return translations.get(name, name)

import sys
import io

# Forzar utf-8 en la salida estándar para Windows
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    print("Obteniendo resultados en vivo de la API de FIFA...")
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"
    }
    
    response = requests.get(FIFA_API_URL, headers=headers)
    if response.status_code != 200:
        print(f"Error al conectar con FIFA API: {response.status_code}")
        return

    data = response.json()
    matches = data.get("Results", [])
    
    if not matches:
        print("No se encontraron partidos.")
        return

    print(f"Se encontraron {len(matches)} partidos en el calendario de FIFA.")

    # Obtener partidos actuales de la base de datos para comparar
    db_response = supabase.table('matches').select('*').execute()
    db_matches = db_response.data
    
    print(f"Se encontraron {len(db_matches)} partidos en Supabase.")

    updated_count = 0

    for match in matches:
        home_data = match.get('Home')
        away_data = match.get('Away')
        
        if not home_data or not away_data:
            continue
            
        home_team_en = home_data.get('TeamName', [{}])[0].get('Description')
        away_team_en = away_data.get('TeamName', [{}])[0].get('Description')
        
        if not home_team_en or not away_team_en:
            continue
            
        home_score = match.get('HomeTeamScore')
        away_score = match.get('AwayTeamScore')
        match_status = map_match_status(match.get('MatchStatus'))

        home_team_es = map_team_name(home_team_en)
        away_team_es = map_team_name(away_team_en)

        # Buscar el partido en nuestra BD
        target_match = None
        for dbm in db_matches:
            if dbm['home_team'] == home_team_es and dbm['away_team'] == away_team_es:
                target_match = dbm
                break

        if target_match:
            # Si el marcador es nulo pero en FIFA ya hay marcador, actualizamos
            if home_score is not None and away_score is not None:
                # Verificar si ya estaban actualizados
                if target_match.get('home_score') != home_score or target_match.get('away_score') != away_score or target_match.get('status') != match_status:
                    print(f"Actualizando: {home_team_es} {home_score} - {away_score} {away_team_es} ({match_status})")
                    
                    supabase.table('matches').update({
                        'home_score': home_score,
                        'away_score': away_score,
                        'status': match_status
                    }).eq('id', target_match['id']).execute()
                    
                    updated_count += 1
                else:
                    # Ya está actualizado
                    pass

    print(f"Proceso completado. {updated_count} partidos actualizados.")

if __name__ == "__main__":
    main()
