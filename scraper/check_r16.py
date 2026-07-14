import os, requests, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
from dotenv import load_dotenv
load_dotenv(dotenv_path="../.env")
from supabase import create_client

url = os.environ.get("SUPABASE_URL")
key = os.environ.get("SUPABASE_SERVICE_ROLE_KEY") or os.environ.get("SUPABASE_ANON_KEY")
sb = create_client(url, key)

# Ver cuantos partidos hay por stage
res = sb.table("matches").select("stage").execute()
from collections import Counter
counts = Counter(m["stage"] for m in res.data)
print("=== PARTIDOS POR STAGE EN BD ===")
for stage, count in sorted(counts.items()):
    print(f"  {stage}: {count}")

print()

# Ver los de round_of_16 especificamente
res16 = sb.table("matches").select("home_team,away_team,stage,status,home_score,away_score").eq("stage","round_of_16").execute()
print(f"=== round_of_16 en BD ({len(res16.data)} partidos) ===")
for m in res16.data:
    print(f"  {m['home_team']} vs {m['away_team']} | {m['status']} | {m.get('home_score')}-{m.get('away_score')}")

print()

# Ver FIFA API cuantos Round of 16 hay
FIFA_API_URL = "https://api.fifa.com/api/v3/calendar/matches?language=en&count=500&idSeason=285023"
headers = {"User-Agent": "Mozilla/5.0"}
r = requests.get(FIFA_API_URL, headers=headers)
matches = r.json().get("Results", [])
r16_api = [m for m in matches if (m.get("StageName") or [{}])[0].get("Description","") == "Round of 16"]
print(f"=== Round of 16 en FIFA API ({len(r16_api)} partidos) ===")
for m in r16_api:
    home = (m.get("Home") or {}).get("TeamName",[{}])[0].get("Description","TBD")
    away = (m.get("Away") or {}).get("TeamName",[{}])[0].get("Description","TBD")
    status = m.get("MatchStatus")
    print(f"  {home} vs {away} | MatchStatus={status}")
