#!/bin/bash

# Step 1: Install Docker
echo "Installing Docker..."
sudo yum install -y docker

# Start Docker service
echo "Starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Add "ec2-user" to the docker group
echo "Adding \"ec2-user\" to the docker group..."
sudo usermod -a -G docker ec2-user

# Step 2: Log out and log back in to apply changes
echo ""
echo "To apply changes, you must log out and reconnect to the EC2 instance."
read -p "Enter the IPv4 address you used to connect to the instance: " ipv4_address

# Logout of the EC2 instance
echo "Logging out..."
logout

# Reconnect to the EC2 instance using SSH
echo "Reconnecting to the EC2 instance..."
ssh -i ~/.ssh/labsuser.pem ec2-user@$ipv4_address

# Go back into the repository
cd trivia-discord-bot

# Step 3: Create .env file
echo ""
echo "Creating .env file..."

read -sp "Enter your Discord bot token (obtained from Developer Portal): " discord_token
echo "DISCORD_TOKEN=\"$discord_token\"" > .env
echo ""
read -p "Enter the name of the Discord server you want to connect to: " discord_guild
echo "DISCORD_GUILD=\"$discord_guild\"" >> .env

echo ""
echo "Creating MySQL connection details..."
read -p "Enter your MySQL username: " mysql_username
echo "MYSQL_USERNAME=\"$mysql_username\"" >> .env

read -sp "Enter your MySQL password: " mysql_root_password
echo "MYSQL_PASSWORD=\"$mysql_root_password\"" >> .env

echo "MYSQL_HOST=\"mysql_container\"" >> .env

# Step 4: Build container images and run containers
echo "Installing MySQL container image..."
docker pull mysql

# Run MySQL container
echo "Running \"mysql_container\"..."
docker run -d --name mysql_container -e MYSQL_ROOT_PASSWORD=$mysql_root_password -p 3306:3306 mysql

# Restart MySQL container
echo "Restarting \"mysql_container\"..."
docker restart mysql_container

# Build "discord_bot" container image
echo ""
echo "Building \"discord_bot\" container image..."
docker build -t discord_bot .

# Run "trivia_bot" container
echo "Running \"trivia_bot\" container..."
docker run -d --name trivia_bot discord_bot

# Create Docker network for communication between containers
echo ""
echo "Creating Docker network..."
docker network create discord_bot_network

# Connect "trivia_bot" container to the network
echo "Connecting \"trivia_bot\" container to the network..."
docker network connect discord_bot_network trivia_bot

# Populate MySQL database
echo ""
echo "Populating MySQL database..."
docker exec -it mysql_container mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS trivia_db; USE trivia_db; CREATE TABLE IF NOT EXISTS trivia_questions ( id INT AUTO_INCREMENT PRIMARY KEY, question VARCHAR(255) NOT NULL, answer VARCHAR(255) NOT NULL ); INSERT INTO trivia_questions (question, answer) VALUES ('Are brownies good? Respond \"YES\" or \"NO\"', 'Yes'), ('What country was I created in?', 'US'), ('What class was I developed for?', 'DevOps'), ('What is the capital of France?', 'Paris'), ('What question number is this?', '5');"

# Connect "mysql_container" to the network
echo "Connecting \"mysql_container\" to the network..."
docker network connect discord_bot_network mysql_container

echo ""
echo "Setup complete and bot is running."
