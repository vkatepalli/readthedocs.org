#!/bin/bash

PROJECT_DIR=/home/ubuntu/inmail-backend/inmail-backend # Project directory
OS_ENV=/home/ubuntu/.env
CELERY_APP=server.celery #app module
CELERY_LOG_FILE=/home/ubuntu/logs/inmail-worker.log
VIRTUAL_ENV_DIR=/home/ubuntu/env/inmail

echo "Starting Celery"
# Activate the virtual environment
cd $VIRTUAL_ENV_DIR/
source bin/activate

# Loading Environment Variables
source $OS_ENV
export PYTHONPATH=$PROJECT_DIR:$PYTHONPATH

# start celery worker
cd $PROJECT_DIR
exec celery worker -A ${CELERY_APP} -l info --logfile="$CELERY_LOG_FILE"
