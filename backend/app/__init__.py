from flask import Flask
from flask_cors import CORS
import os

def create_app():
    app = Flask(__name__)
    CORS(app)  # Enable CORS if frontend is separate

    app.config.from_object("config")

    from app.routes import main
    app.register_blueprint(main)

    return app
