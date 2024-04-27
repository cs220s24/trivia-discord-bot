#!/bin/bash

# Step 1: Create .env file
echo "Creating .env file..."

read -sp "Enter your Discord bot token (obtained from Developer Portal): " discord_token
echo "DISCORD_TOKEN=\"$discord_token\"" > .env
echo ""
read -p "Enter the name of the Discord server you want to connect to: " discord_guild
echo "DISCORD_GUILD=\"$discord_guild\"" >> .env

echo ""
echo "Creating MySQL connection details..."
echo "Setting MYSQL username to root..."
echo "MYSQL_USERNAME="root"" >> .env

read -sp "Enter your MySQL root password: " mysql_root_password
echo "MYSQL_ROOT_PASSWORD=\"$mysql_root_password\"" >> .env

echo ""
echo "Setting MySQL host..."
echo "MYSQL_HOST=mysql_container" >> .env

# Step 2: Build container images
echo "Creating the MySQL Image..."

# If the image doesn't already exist, create it
if ! docker image inspect mysql > /dev/null 2>&1; then
  docker pull mysql
fi

# If the discord_bot image doesn't already exist, create it
if ! docker image inspect discord_bot > /dev/null 2>&1; then
  docker build -t discord_bot .
fi

# Create a network that will hold the containers for both images
if ! docker network inspect discord_bot_network > /dev/null 2>&1; then
  docker network create discord_bot_network
fi

echo "Build complete."
echo "Next run ./up to start the containers."

chmod +x up
chmod +x down
