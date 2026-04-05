import os
from supabase import create_client, Client
from dotenv import load_dotenv

load_dotenv()

url: str = os.environ.get("SUPABASE_URL", "")
# Use Service Role Key for backend administrative operations
key: str = os.environ.get("SUPABASE_SERVICE_ROLE_KEY", "")
supabase: Client | None = create_client(url, key) if url and key and url != "YOUR_SUPABASE_URL" else None
