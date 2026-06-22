import os
from supabase import create_client, Client
from dotenv import load_dotenv
import io, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

load_dotenv(dotenv_path='../.env')
SUPABASE_URL = os.environ.get('SUPABASE_URL')
SUPABASE_KEY = os.environ.get('SUPABASE_SERVICE_ROLE_KEY') or os.environ.get('SUPABASE_ANON_KEY')
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
db_response = supabase.table('matches').select('*').execute()
for m in db_response.data:
    if m['home_score'] is not None or m['status'] == 'FINISHED':
        print(f"{m['home_team']} {m['home_score']} - {m['away_score']} {m['away_team']} ({m['status']})")
