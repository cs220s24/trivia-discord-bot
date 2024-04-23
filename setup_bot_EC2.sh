#!/bin/bash

# Step 1: Install MariaDB
echo "Installing MariaDB..."
sudo dnf install -y mariadb105-server

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

# Step 2: Create the 'trivia_db' database
echo "Creating and populating database..."
sudo mysql -u root -p <<EOF
ALTER USER 'root'@'localhost'; IDENTIFIED BY 'root';
CREATE DATABASE trivia_db;
USE trivia_db;
CREATE TABLE trivia_questions ( id INT AUTO_INCREMENT PRIMARY KEY, question VARCHAR(255) NOT NULL, answer VARCHAR(255) NOT NULL );
INSERT INTO trivia_questions (question, answer) VALUES ('Are brownies good? Respond "YES" or "NO"', 'Yes'), ('What country was I created in?', 'US'), ('What class was I developed for?', 'DevOps'), ('What is the capital of France?', 'Paris'), ('What question number is this?', '5');
exit
EOF

# Step 3: Restart and enable MariaDB service
echo "Restarting and enabling MariaDB service..."
sudo systemctl stop mariadb
sudo systemctl enable mariadb
sudo systemctl start mariadb
echo "MariaDB setup completed successfully."

# Step 4: Check if virtual environment exists
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv .venv
fi # Close if statement

# Step 5: Install requirements
echo "Setting up virtual environment and installing requirements..."
source .venv/bin/activate
pip install -r requirements.txt

# Step 6: Create .env file
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

# Step 7: Connect to the MySQL database
echo "Configuring MySQL connection..."
sed -i.bak "s/user='project'/user='$mysql_username'/; s/password='project'/password='$mysql_password'/" main.py
rm main.py.bak

# Step #8: Enable and start Discord bot service
echo "Starting Discord bot service..."
sudo cp discord_bot.service /etc/systemd/system
sudo systemctl enable discord_bot.service
sudo systemctl start discord_bot.service

echo "Discord bot setup completed successfully."
