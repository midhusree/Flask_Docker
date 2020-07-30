#!/bin/sh
set -e

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres to start..."

    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL has started"
fi


cd app/flaskDemoApp
flask db stamp head
flask db migrate
flask db upgrade
export FLASK_APP=main.py

gunicorn -w 4 -b 0.0.0.0:${PORT} app:app
