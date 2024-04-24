#!/bin/bash

# Step 1: Check if virtual environment exists
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv .venv
fi # Close if statement

# Step 2: Install requirements
echo "Setting up virtual environment and installing requirements..."
source .venv/bin/activate
pip install -r requirements.txt

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

read -sp "Enter your MySQL password: " mysql_password
echo "MYSQL_PASSWORD=\"$mysql_password\"" >> .env

# Step 4: Create the 'trivia_db' database
echo ""
echo ""
echo "Creating \"trivia_db\" database..."
mysql -u $mysql_username -p -e "DROP DATABASE IF EXISTS trivia_db; CREATE DATABASE trivia_db;"

echo ""
echo "Populating the database..."
cd database

echo ""
echo "Creating tables..."
mysql -u $mysql_username -p trivia_db < create.sql

echo ""
echo "Inserting data..."
mysql -u $mysql_username -p trivia_db < insert.sql
cd ..

# Step 5: Connect to the MySQL database
echo ""
echo "Configuring MySQL connection..."
sed -i.bak "s/user='project'/user='$mysql_username'/; s/password='project'/password='$mysql_password'/" main.py
rm main.py.bak

# Step 6: Run the project
echo ""
echo "Launching the project..."
python3 main.py

echo "Installation complete."
