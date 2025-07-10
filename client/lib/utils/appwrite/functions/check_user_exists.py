import os
import json
from appwrite.client import Client
from appwrite.services.users import Users

def main(context):
    # Parse input
    try:
        data = context.req.json
    except Exception:
        return context.res.json({"exists": False, "error": "Invalid JSON"}, status_code=400)

    email = data.get("email")
    if not email:
        return context.res.json({"exists": False, "error": "Email is required"}, status_code=400)

    # Initialize Appwrite client
    client = Client()
    client.set_endpoint(os.environ["APPWRITE_ENDPOINT"])
    client.set_project(os.environ["APPWRITE_FUNCTION_PROJECT_ID"])
    client.set_key(os.environ["APPWRITE_API_KEY"])

    users = Users(client)
    try:
        result = users.list(search=email)
        exists = any(user["email"].lower() == email.lower() for user in result["users"])
        return context.res.json({"exists": exists})
    except Exception as e:
        return context.res.json({"exists": False, "error": str(e)}, status_code=500) 