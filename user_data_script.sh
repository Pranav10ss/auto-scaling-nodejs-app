#!/bin/bash -ex
# Output user data logs into a separate file for debugging
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

# Download NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Source NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Install Node.js
nvm install node

# Upgrade system packages
sudo yum upgrade -y

# Install Git
sudo yum install git -y

# Change to home directory
cd /home/ec2-user

# Clone your GitHub repository
git clone https://github.com/Pranav10ss/auto-scaling-nodejs-app.git

# Navigate to the project directory
cd auto-scaling-nodejs-app

# Give permission to execute files
sudo chmod -R 755 .

# Install Node.js dependencies
npm install

# Start the application
node app.js > app.out.log 2> app.err.log < /dev/null &
