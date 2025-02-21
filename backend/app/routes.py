from flask import Blueprint, request, jsonify
import random

main = Blueprint("main", __name__)

# Sample messages and quotes
positive_messages = [
    "You are stronger than you think!",
    "Every day is a new beginning.",
    "Believe in yourself, and amazing things will happen.",
    "Your potential is endless."
]

@main.route("/analyze", methods=["POST"])
def analyze_mood():
    data = request.get_json()
    journal_text = data.get("text", "").lower()
    mood = data.get("mood", "neutral")

    response = {
        "mood": mood,
        "message": random.choice(positive_messages),
    }

    return jsonify(response)
