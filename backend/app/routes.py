from flask import Blueprint, request, jsonify
import firebase_admin
from firebase_admin import credentials, firestore
import os
import google.generativeai as genai
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

main = Blueprint("main", __name__)

# Initialize Firebase
cred = credentials.Certificate("../backend/credentials.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# Configure Gemini API Key
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

@main.route("/fetch_journal_data/<user_id>", methods=["GET"])
def fetch_journal_data(user_id):
    try:
        if not user_id:
            return jsonify({"error": "User ID is required"}), 400

        print(f"Received request for user_id: {user_id}")  # Debugging

        # Fetch journal entries from Firestore
        collection_ref = db.collection("users").document(user_id).collection("journals")
        docs = collection_ref.stream()

        journal_entries = [doc.to_dict().get("content", "") for doc in docs if doc.to_dict()]

        if not journal_entries:
            return jsonify({"message": "No journal data found"}), 404

        # Concatenate all journal entries into a single string
        journal_text = "\n\n".join(journal_entries)

        print("Sending this text to Gemini:", journal_text[:500])  # Debugging (print first 500 chars)

        # Call Gemini API
        model = genai.GenerativeModel("gemini-pro")
        response = model.generate_content(f"Summarize and analyze the following journal entries for mental well-being insights:\n\n{journal_text}")

        gemini_response = response.text if response.text else "No summary available."

        return jsonify({"journal_data": journal_entries, "summary": gemini_response}), 200

    except Exception as e:
        print(f"Error fetching journal data: {e}")  # Debugging
        return jsonify({"error": str(e)}), 500
    