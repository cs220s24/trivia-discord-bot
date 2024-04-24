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
read -p "Enter your MySQL username: " mysql_username
echo "MYSQL_USERNAME=\"$mysql_username\"" >> .env

read -sp "Enter your MySQL password: " mysql_root_password
echo "MYSQL_PASSWORD=\"$mysql_root_password\"" >> .env

echo ""
echo "Setting MySQL host..."
echo "MYSQL_HOST=\"mysql_container\"" >> .env

# Step 2: Build container images - TODO FROM HERE !!!!!!!!!!!!!!!!!!!!!
echo ""
