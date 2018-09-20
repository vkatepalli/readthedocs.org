#!/bin/bash
NAME="inmail-web" # Name of the application
APPDIR=/home/ubuntu/inmail-backend/inmail-backend/ # Application project directory
USER=ubuntu # the user to run as
NUM_WORKERS=5 # how many worker processes should Gunicorn spawn
APP_WSGI_MODULE=server # WSGI module name
VIRTUAL_ENV_DIR=/home/ubuntu/env/inmail
ADDRESS=0.0.0.0
PORT=8000
OS_ENV=/home/ubuntu/.env

echo "Starting Inmail Server"

# Activate the virtual environment
cd $VIRTUAL_ENV_DIR/
source bin/activate

# Loading Environment Variables
source $OS_ENV

export PYTHONPATH=$APPDIR:$PYTHONPATH

# Start your Wsgi
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
cd $APPDIR
exec gunicorn $APP_WSGI_MODULE:app \
--name $NAME \
--workers $NUM_WORKERS \
--worker-connections 4 \
--threads 3 \
--worker-class gevent \
--user=$USER \
--bind=$ADDRESS:$PORT \
--log-level=debug

echo "INmail Server running on $ADDRESS:$PORT"
