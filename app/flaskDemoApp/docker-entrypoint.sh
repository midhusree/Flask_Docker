#!/bin/sh
set -e
cd app/flaskDemoApp
flask db stamp head
flask db migrate
flask db upgrade
export FLASK_APP=main.py

gunicorn -w 4 -b 0.0.0.0:${PORT} app:app
