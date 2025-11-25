"""app.py

Entry-point module for when Flask is called directly to start the server
"""

from organic_toolkit_hub.gui.setup import get_app

app = get_app()
