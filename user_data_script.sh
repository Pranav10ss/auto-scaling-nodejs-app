#!/bin/bash -ex

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
. /.nvm/nvm.sh

nvm install node
export NVM_DIR="/.nvm"	
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"	
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 

sudo yum upgrade -y 
sudo yum install git -y

cd /home/ec2-user
git clone https://YOUR_REPO_HERE
cd YOUR_REPO_DIR_HERE
sudo chmod -R 755 .
npm install

node app.js > app.out.log 2> app.err.log < /dev/null &
