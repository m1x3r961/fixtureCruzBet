import csv
import re
from datetime import datetime, timedelta

name_map = {
    "Mexico": "México",
    "South Africa": "Sudáfrica",
    "Korea Republic": "Corea del Sur",
    "Czechia": "Rep. Checa",
    "Canada": "Canadá",
    "Bosnia and Herzegovina": "Bosnia y Herzegovina",
    "USA": "Estados Unidos",
    "Paraguay": "Paraguay",
    "Qatar": "Catar",
    "Switzerland": "Suiza",
    "Brazil": "Brasil",
    "Morocco": "Marruecos",
    "Haiti": "Haití",
    "Scotland": "Escocia",
    "Australia": "Australia",
    "Türkiye": "Turquía",
    "Germany": "Alemania",
    "Curacao": "Curazao",
    "Netherlands": "Países Bajos",
    "Japan": "Japón",
    "Ivory Coast": "Costa de Marfil",
    "Ecuador": "Ecuador",
    "Sweden": "Suecia",
    "Tunisia": "Túnez",
    "Spain": "España",
    "Cape Verde": "Cabo Verde",
    "Belgium": "Bélgica",
    "Egypt": "Egipto",
    "Saudi Arabia": "Arabia Saudita",
    "Uruguay": "Uruguay",
    "IR Iran": "Irán",
    "New Zealand": "Nueva Zelanda",
    "France": "Francia",
    "Senegal": "Senegal",
    "Iraq": "Irak",
    "Norway": "Noruega",
    "Argentina": "Argentina",
    "Algeria": "Argelia",
    "Austria": "Austria",
    "Jordan": "Jordania",
    "Portugal": "Portugal",
    "Congo DR": "RD Congo",
    "England": "Inglaterra",
    "Croatia": "Croacia",
    "Ghana": "Ghana",
    "Panama": "Panamá",
    "Uzbekistan": "Uzbekistán",
    "Colombia": "Colombia"
}

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

months = {
    "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6,
    "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12
}

def get_flag(team_name):
    code = country_codes.get(team_name)
    if not code:
        return ""
    return f"https://flagcdn.com/w320/{code}.png"

def parse_raw(filepaths):
    lines = []
    for fp in filepaths:
        with open(fp, 'r', encoding='utf-8') as f:
            lines.extend([line.strip() for line in f if line.strip()])
        
    matches = []
    current_date = None
    
    i = 0
    while i < len(lines):
        line = lines[i]
        date_match = re.match(r'^(Mon|Tue|Wed|Thu|Fri|Sat|Sun),\s+([A-Z][a-z]{2})\s+(\d+)$', line)
        if date_match:
            month_str = date_match.group(2)
            day = int(date_match.group(3))
            current_date = (months[month_str], day)
            i += 1
            continue
            
        if line.endswith(" logo"):
            # Team 1 logo
            i += 1
            team1_eng = lines[i]
            i += 1
            if lines[i] != "vs":
                print(f"Expected 'vs', got {lines[i]}")
                break
            i += 1
            # Team 2 logo
            i += 1
            team2_eng = lines[i]
            i += 1
            time_str = lines[i]
            i += 1
            # " • "
            i += 1
            group_str = lines[i]
            i += 1
            
            # Convert time
            time_parts = re.match(r'^(\d+):(\d+)\s+(AM|PM)$', time_str)
            if not time_parts:
                print(f"Failed to parse time {time_str}")
                continue
                
            hour = int(time_parts.group(1))
            minute = int(time_parts.group(2))
            ampm = time_parts.group(3)
            
            if ampm == "PM" and hour != 12:
                hour += 12
            if ampm == "AM" and hour == 12:
                hour = 0
                
            # Create datetime in HB (UTC-4)
            dt_hb = datetime(2026, current_date[0], current_date[1], hour, minute)
            dt_utc = dt_hb + timedelta(hours=4)
            iso_utc = dt_utc.strftime("%Y-%m-%dT%H:%M:%SZ")
            
            t1_es = name_map.get(team1_eng, team1_eng)
            t2_es = name_map.get(team2_eng, team2_eng)
            
            group_es = group_str.replace("Group", "Grupo")
            
            matches.append({
                "home_team": t1_es,
                "away_team": t2_es,
                "match_time": iso_utc,
                "status": "scheduled",
                "stage": "group",
                "group_name": group_es,
                "home_flag": get_flag(t1_es),
                "away_flag": get_flag(t2_es)
            })
            continue
            
        # fallback if format is broken
        i += 1
        
    return matches

def generate_csv(matches, csv_path):
    with open(csv_path, 'w', encoding='utf-8', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(["home_team","away_team","match_time","status","stage","group_name","home_flag","away_flag"])
        for m in matches:
            writer.writerow([
                m["home_team"], m["away_team"], m["match_time"],
                m["status"], m["stage"], m["group_name"],
                m["home_flag"], m["away_flag"]
            ])
            
    print(f"Successfully generated {len(matches)} matches in {csv_path}.")

if __name__ == "__main__":
    matches = parse_raw(['scratch/raw_new.txt', 'scratch/raw_new_2.txt'])
    generate_csv(matches, 'fixture_mundial.csv')
