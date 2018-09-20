#
# Before running this script
# you need to clone the repo
# you need to prepare .env file in home path
#
# Ex: bash ~/inmail-backend/deploy/install.sh
#
#
sudo apt-get -y update
sudo apt-get -y install build-essential python-dev virtualenv supervisor nginx redis-server
export LC_CTYPE=en_US.UTF-8
mkdir ~/env && cd ~/env
virtualenv -p python3 inmail
source ~/env/inmail/bin/activate
pip3 install -r ~/inmail-backend/requirements.txt
mkdir ~/logs && touch ~/logs/inmail-web.log ~/logs/nginx-access.log ~/logs/nginx-error.log ~/logs/inmail-worker.log
chmod u+x ~/inmail-backend/deploy/web/web.bash
chmod u+x ~/inmail-backend/deploy/worker/worker.bash
source ~/.env
cd ~/inmail-backend/inmail-backend/
elask-admin flush_data
elask-admin migrate
elask-admin load_data -location ../fixtures/inmar.json
sudo ln -s /home/ubuntu/inmail-backend/deploy/web/web.conf /etc/supervisor/conf.d/
sudo ln -s /home/ubuntu/inmail-backend/deploy/worker/worker.conf /etc/supervisor/conf.d/
sudo supervisorctl reread && sudo supervisorctl update
sudo supervisorctl restart all
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /home/ubuntu/inmail-backend/deploy/nginx/nginx.conf /etc/nginx/sites-enabled/
sudo nginx -s reload