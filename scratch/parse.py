import csv
import re
from datetime import datetime, timedelta

raw_data = """11/06A15:00 México vs. Sudáfrica
12/06A22:00 Corea del Sur vs. Rep. Checa
12/06B15:00 Canadá vs. Bosnia y Herzegovina
13/06D21:00 Estados Unidos vs. Paraguay
13/06B15:00 Catar vs. Suiza
13/06C18:00 Brasil vs. Marruecos
14/06C21:00 Haití vs. Escocia
14/06D00:00 (Madrugada 15/6) Australia vs. Turquía
14/06E13:00 Alemania vs. Curazao
14/06F16:00 Países Bajos vs. Japón
14/06E19:00 Costa de Marfil vs. Ecuador
15/06F22:00 Suecia vs. Túnez
15/06H12:00 España vs. Cabo Verde
15/06G15:00 Bélgica vs. Egipto
15/06H18:00 Arabia Saudita vs. Uruguay
16/06G21:00 Irán vs. Nueva Zelanda
16/06I15:00 Francia vs. Senegal
16/06I18:00 Irak vs. Noruega
16/06J21:00 Argentina vs. Argelia
17/06J00:00 (Madrugada 18/6) Austria vs. Jordania
17/06K13:00 Portugal vs. Uzbekistán
17/06L16:00 Inglaterra vs. Croacia
17/06L19:00 Ghana vs. Panamá
17/06K22:00 Colombia vs. RD Congo
18/06A12:00 Rep. Checa vs. Sudáfrica
18/06B15:00 Suiza vs. Bosnia
18/06B18:00 Canadá vs. Catar
18/06A21:00 México vs. Corea del Sur
19/06D15:00 Estados Unidos vs. Australia
19/06C18:00 Escocia vs. Marruecos
19/06C21:00 Brasil vs. Haití
20/06D00:00 (Madrugada 21/6) Turquía vs. Paraguay
20/06F13:00 Países Bajos vs. Suecia
20/06E16:00 Alemania vs. Costa de Marfil
20/06E20:00 Ecuador vs. Curazao
20/06F00:00 (Madrugada 21/6) Túnez vs. Japón
21/06H12:00 España vs. Arabia Saudita
21/06G15:00 Bélgica vs. Irán
21/06H18:00 Uruguay vs. Cabo Verde
21/06G21:00 Nueva Zelanda vs. Egipto
22/06J22:00 Argentina vs. Austria
22/06I17:00 Francia vs. Irak
22/06I20:00 Noruega vs. Senegal
22/06J23:00 Jordania vs. Argelia
23/06K13:00 Portugal vs. Uzbekistán
23/06L16:00 Inglaterra vs. Ghana
23/06L19:00 Panamá vs. Croacia
23/06K22:00 Colombia vs. RD Congo
24/06B15:00 Bosnia vs. Catar
24/06C18:00 Escocia vs. Brasil
24/06C18:00 Marruecos vs. Haití
24/06A21:00 Rep. Checa vs. México
24/06A21:00 Sudáfrica vs. Corea del Sur
25/06E16:00 Ecuador vs. Alemania
25/06E16:00 Curazao vs. Costa de Marfil
25/06F19:00 Japón vs. Suecia
25/06F19:00 Túnez vs. Países Bajos
25/06D22:00 Turquía vs. Estados Unidos
25/06D22:00 Paraguay vs. Australia
26/06I15:00 Noruega vs. Francia
26/06I15:00 Senegal vs. Irak
26/06H20:00 Uruguay vs. España
26/06H20:00 Cabo Verde vs. Arabia Saudita
26/06G23:00 Nueva Zelanda vs. Bélgica
26/06G23:00 Egipto vs. Irán
27/06L17:00 Panamá vs. Inglaterra
27/06L17:00 Croacia vs. Ghana
27/06K19:30 Colombia vs. Portugal
27/06K19:30 RD Congo vs. Uzbekistán
27/06J22:00 Argelia vs. Austria
27/06J22:00 Jordania vs. Argentina"""

country_codes = {
    "México": "mx", "Sudáfrica": "za",
    "Corea del Sur": "kr", "Rep. Checa": "cz",
    "Canadá": "ca", "Bosnia y Herzegovina": "ba", "Bosnia": "ba",
    "Estados Unidos": "us", "Paraguay": "py",
    "Catar": "qa", "Suiza": "ch",
    "Brasil": "br", "Marruecos": "ma",
    "Haití": "ht", "Escocia": "gb-sct",
    "Australia": "au", "Turquía": "tr",
    "Alemania": "de", "Curazao": "cw",
    "Países Bajos": "nl", "Japón": "jp",
    "Costa de Marfil": "ci", "Ecuador": "ec",
    "Suecia": "se", "Túnez": "tn",
    "España": "es", "Cabo Verde": "cv",
    "Bélgica": "be", "Egipto": "eg",
    "Arabia Saudita": "sa", "Uruguay": "uy",
    "Irán": "ir", "Nueva Zelanda": "nz",
    "Francia": "fr", "Senegal": "sn",
    "Irak": "iq", "Noruega": "no",
    "Argentina": "ar", "Argelia": "dz",
    "Austria": "at", "Jordania": "jo",
    "Portugal": "pt", "Uzbekistán": "uz",
    "Inglaterra": "gb-eng", "Croacia": "hr",
    "Ghana": "gh", "Panamá": "pa",
    "Colombia": "co", "RD Congo": "cd"
}

def get_flag(team_name):
    team_name = team_name.strip()
    code = country_codes.get(team_name)
    if not code:
        print(f"WARNING: No code for {team_name}")
        return ""
    return f"https://flagcdn.com/w320/{code}.png"

lines = raw_data.strip().split('\n')

csv_rows = []
csv_rows.append(["home_team","away_team","match_time","status","stage","group_name","home_flag","away_flag"])

for line in lines:
    line = line.strip()
    if not line:
        continue
    # regex: dd/mm GROUP hh:mm [optional (Madrugada dd/m)] Home vs. Away
    match = re.match(r'^(\d{2})/(\d{2})([A-Z])(\d{2}:\d{2})(?:\s*\(Madrugada \d{1,2}/\d{1,2}\))?\s+(.*?)\s+vs\.\s+(.*)$', line)
    if not match:
        print("FAILED TO PARSE:", line)
        continue
    
    day, month, group, time_str, home, away = match.groups()
    home = home.strip()
    away = away.strip()
    
    # Parse date and time in HB (UTC-4)
    # The Madrugada cases have 00:00, and usually refer to the NEXT day's midnight in common speech, but since the raw data says "14/06D00:00 (Madrugada 15/6)", it actually means the date is 15/06 at 00:00 HB.
    is_madrugada = "Madrugada" in line
    if is_madrugada:
        madrugada_match = re.search(r'\(Madrugada (\d{1,2})/(\d{1,2})\)', line)
        if madrugada_match:
            day = f"{int(madrugada_match.group(1)):02d}"
            month = f"{int(madrugada_match.group(2)):02d}"
    
    dt_str = f"2026-{month}-{day} {time_str}:00"
    dt_hb = datetime.strptime(dt_str, "%Y-%m-%d %H:%M:%S")
    # UTC is HB + 4 hours
    dt_utc = dt_hb + timedelta(hours=4)
    iso_utc = dt_utc.strftime("%Y-%m-%dT%H:%M:%SZ")
    
    group_name = f"Grupo {group}"
    home_flag = get_flag(home)
    away_flag = get_flag(away)
    
    csv_rows.append([
        home,
        away,
        iso_utc,
        "scheduled",
        "group",
        group_name,
        home_flag,
        away_flag
    ])

with open("e:\\fixtureCruzbet\\fixture_mundial.csv", "w", encoding="utf-8", newline="") as f:
    writer = csv.writer(f)
    writer.writerows(csv_rows)

print("SUCCESS: CSV written to e:\\fixtureCruzbet\\fixture_mundial.csv")
