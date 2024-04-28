# trivia-discord-bot
A fun Discord bot that inquires trivia questions for users to interact with. Users can start a quiz to begin the game and find out their score.

Final project designed for *CSCI 220.2: Intro to DevOps.*

## System Architecture
![diagram](triviaDiagramDockerized.png)

### Commands:
- `ping` - The bot responds with `"pong!"`
- `whoami` - The bot responds with `"You are [YOUR USERNAME]!"`
- `start quiz` - The bot begins a brief 5-question quiz. It tells you your final score at the end of it.

### Contributers:
- [Christine Colvin](https://github.com/christinecolvin)
- [Jack Drabic](https://github.com/JackJack7890)
- [Rafael Garcia Jr.](https://github.com/RGJ-713)
- [Michael Romero](https://github.com/MichaelRomero1)

### Prerequisites

- Amazon Web Services (AWS) | ([Website](https://aws.amazon.com/?nc2=h_lg))
- Discord | ([Website](https://discord.com))
- MySQL | ([Download](https://dev.mysql.com/downloads/mysql/), [Set-Up Tutorial](https://dev.mysql.com/doc/mysql-getting-started/en/))

### References:
- [How to Make a Discord Bot in Python](https://realpython.com/how-to-make-a-discord-bot-python/) by Alex Ronquillo

## Creating A Discord Bot

### 1. Create a new bot in Developer Portal
Go to the [Discord Developer Portal](https://discord.com/developers/applications) and click the **New Application** button to create a new Discord bot.

### 2. Set bot permissions
Once a new bot has been created, locate the **Bot** tab on the left-hand side of the **Settings**.

Locate the "**Privileged Gateway Intents**" section and enable "**Message Content Intent**" to allow your bot to receive and read messages.

After being enabled, select the permissions you want your bot to have.

### 3. Obtain your bot's Discord token
In order for your bot to properly run, you will need to obtain your bot's token.

In the **Bot** tab, locate the **Build-A-Bot** section. Locate the **Token** portion and press the **Reset Token** button to reset and obtain your bot's Discord token.

***Note:** Tokens can only be viewed once. Be sure to save your token somewhere safe, as if you ever need it again, you will need to generate a new one.*

### 4. Add your bot to your Discord server
Locate the **OAuth2** tab on the left-hand side of the **Settings**.

Under the **OAuth2 URL Generator** section, select "**bot**" under **Scopes**.

A new tab will open below. Select the permissions you want your bot to have.

Once done, locate **Generated URL** and press the **Copy** button to gain a link to add your bot to your preferred Discord server.

Go to that URL and select the Discord server(s) you want to add the bot to.

# Local Installation Tutorial

### 1. Clone the repo
Once you are all set up, press the green **<> Code** button to gain a link to clone the repository.

Then, open your preferred [IDE](https://aws.amazon.com/what-is/ide/) or a [Command Line Interface](https://en.wikipedia.org/wiki/Command-line_interface#:~:text=A%20command%2Dline%20interface%20\(CLI,interface%20available%20with%20punched%20cards.) and clone the repository with the following command:

```
git clone https://github.com/cs220s24/trivia-discord-bot.git
```

### 2. Run `setup_bot_local.sh`
Go into your preferred terminal and enter the **`trivia-discord-bot`** repository.

Run the following command:

```
sh setup_bot_local.sh
```

Follow the instruction prompts given in the terminal. This will complete all the necessary set-up for the bot to run.

### 3. Run the bot
The bot should now successfully be up and running!

You can test this by posting the message **`ping`**. The bot should respond with **`"pong!"`**.

To play a brief quiz with the bot, post the message **`start quiz`**.

# OTHER INFO

### .env file
- Grab your discord bot's token and put it in the .env file with
- DISCORD_TOKEN =<DISCORD_TOKEN>
- MYSQL_USERNAME=<PASSWORD>
- MYSQL_ROOT_PASSWORD=<USERNAME>
- MYSQL_HOST =<HOSTNAME>

### Enable priviledged gateway for message content
- Go to to https://discord.com/developers/applications/
- Go to bots on the left hand side
- Find Privileged Gateway Intents
- Under Message Content Intent, switch it on

### Running on an AWS Instance WITHOUT Docker
- Launch AWS Learning Academy Lab
- Create an instance with Voc-key and allow HTTP Traffic--other default settings are fine
- When the insance is up and running, grab its Public IPv4 address
- In a new terminal window, use the command: 
```
ssh -i ~/.ssh/labsuser.pem ec2-user@<Public IPv4 address>
```
- Then use the command: 
```
sudo yum install git
```
- Once git is installed, clone the repo with: 
```
git clone https://github.com/cs220s24/trivia-discord-bot.git
```
- CD into the repo
- Create your .env file with: nano .env
- Follow the steps from the .env file above
- Create a virtual environment and install dependencies with:
```
1. python3 -m venv .venv
2. source .venv/bin/activate
3. pip install -r requirements.txt
```
- Finally run the program using: 
```
python3 main.py
```

### SYSTEMD

- These steps can be used locally to copy the discord_bot.service file to the system path and run it on systemd
  ```
  sudo cp discord_bot.service /etc/systemd/system
  ```
  ```
  sudo systemctl enable discord_bot.service
  ```
  ```
  sudo systemctl start discord_bot.service
  ```

### Running Bot with Docker on Ec2 with Scripts!
- sudo yum install -y git (Install git)
- git clone <REPO> (Clone the repo)
- cd trivia-discord-bot (Go into the repository)
- sh aws_deploy.sh (Installs docker and adds ec2-user to the Docker group)
- Logout, and log back into the ec2 instance and cd back into trivia-discord-bot
- sh build.sh (Creates the images for MySQL and the discord bot as well as the .env with user input)
- ./up (Starts the containers!)
- If you want to stop the bot and remove the containers, you can use ./down. You can always start it again with ./up

