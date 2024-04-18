#!/bin/bash

# Step 1: Check if virtual environment exists
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv .venv

fi

# Step 2: Install requirements
echo "Setting up virtual environment and installing requirements..."
source .venv/bin/activate
pip install -r requirements.txt

# Step 3: Create .env file
echo "Creating .env file..."
echo "FLASK_SECRET_KEY = \"$(python3 -c 'import secrets; print(secrets.token_hex())')\"" > .env

# Step 4: Create the 'trivia_db' database
read -p "Enter your MySQL username: " mysql_username
echo "Creating 'trivia_db' database..."
mysql -u $mysql_username -p -e "DROP DATABASE IF EXISTS trivia_db; CREATE DATABASE trivia_db;"

echo "Populating the database..."
cd database
mysql -u $mysql_username -p trivia_db < create.sql
mysql -u $mysql_username -p trivia_db < insert.sql
cd ..

# Step 5: Connect to the MySQL database
echo "Configuring MySQL connection..."
read -p "Enter your MySQL username: " mysql_username
read -sp "Enter your MySQL password: " mysql_password
sed -i.bak "s/user='project'/user='$mysql_username'/; s/password='project'/password='$mysql_password'/" main.py
rm main.py.bak

# Step 6: Run the project
echo "Launching the project..."
python3 main.py

echo "Installation complete."