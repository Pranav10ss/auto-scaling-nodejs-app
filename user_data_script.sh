#!/bin/bash -ex

# Output user data logs to a separate file for debugging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Install NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Source NVM so that we can install Node.js
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Install Node.js using NVM
nvm install 14  # Use Node.js version 14 (LTS)
nvm use 14      # Set Node.js version 14 as default
nvm alias default 14

# Verify Node.js and npm installation
node -v
npm -v

# Upgrade yum packages
sudo yum upgrade -y

# Install Git
sudo yum install git -y

# Clone the GitHub repository
cd /home/ec2-user
git clone https://github.com/Pranav10ss/auto-scaling-nodejs-app

# Change to the app directory and adjust permissions
cd auto-scaling-nodejs-app
sudo chmod -R 755 .

# Install app dependencies
npm install

# Start the app and redirect output to log files
node app.js > app.out.log 2> app.err.log < /dev/null &
