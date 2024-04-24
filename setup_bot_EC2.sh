#!/bin/bash

# Step 1: Install MariaDB
echo "Installing MariaDB..."
sudo dnf install -y mariadb105-server

# Start MariaDB service
echo "Starting MariaDB service..."
sudo systemctl start mariadb

# Secure MySQL installation
echo "Securing MariaDB installation..."
echo "Creating MariaDB user \"root\"..."
sudo mysql_secure_installation <<EOF

# Enter password for "root" when prompted
<enter>
# Switch to socket authentication
n
# Change root password
n
# Remove anonymous users
Y
# Disallow root login remotely
Y
# Remove test database and access to it
Y
# Reload privilege tables
Y
EOF

# Step #2: Create the 'trivia_db' database
echo "Allowing \"root\" user to connect to MariaDB..."
sudo mysql -u root -p -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';"

echo "Password for \"root\" user has been set to \"root\"." # THIS IS CURRENTLY FOR TESTING PURPOSES ONLY

echo "Creating and populating database..."
mysql -u root -p -e "DROP DATABASE IF EXISTS trivia_db; CREATE DATABASE trivia_db;"

echo "Populating the database..."
cd database
echo "Creating tables..."
mysql -u root -p trivia_db < create.sql
echo "Inserting data..."
mysql -u root -p trivia_db < insert.sql
cd ..

# Step #3: Restart and enable MariaDB service
echo "Restarting and enabling MariaDB service..."
sudo systemctl restart mariadb
sudo systemctl enable mariadb

# Step #4: Check if virtual environment exists
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv .venv
fi # Close if statement

# Step #5: Install requirements
echo "Setting up virtual environment and installing requirements..."
source .venv/bin/activate
pip install -r requirements.txt

# Step #6: Create .env file
echo "Creating .env file..."
read -sp "Enter your Discord bot token (obtained from Developer Portal): " discord_token
echo "DISCORD_TOKEN=\"$discord_token\"" > .env
echo ""
read -p "Enter the name of the Discord server you want to connect to: " discord_guild
echo "DISCORD_GUILD=\"$discord_guild\"" >> .env

echo "Creating MySQL connection details..."
read -p "Enter your MySQL username: " mysql_username
echo "MYSQL_USERNAME=\"$mysql_username\"" >> .env

read -sp "Enter your MySQL password: " mysql_password
echo "MYSQL_PASSWORD=\"$mysql_password\"" >> .env

# Step #7: Configure MySQL connection
echo "Configuring MySQL connection..."
sed -i.bak "s/user='project'/user='$mysql_username'/; s/password='project'/password='$mysql_password'/" main.py
rm main.py.bak

# Step #8: Enable and start Discord bot service
echo "Starting Discord bot service..."
sudo cp discord_bot.service /etc/systemd/system
sudo systemctl enable discord_bot.service
sudo systemctl start discord_bot.service

echo "Discord bot setup completed successfully."
