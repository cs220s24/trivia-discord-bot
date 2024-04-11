# trivia-discord-bot
A fun discord trivia bot! (Full details TBD.)

### Contributers:
- [Christine Colvin](https://github.com/christinecolvin)
- [Jack Drabic](https://github.com/JackJack7890)
- [Rafael Garcia Jr.](https://github.com/RGJ-713)
- [Michael Romero](https://github.com/MichaelRomero1)

### .env file
- Grab your discord bot's token and put it in the .env file with
- DISCORD_TOKEN = <DISCORD_TOKEN>

### Enable priviledged gateway for message content
- Go to to https://discord.com/developers/applications/
- Go to bots on the left hand side
- Find Privileged Gateway Intents
- Under Message Content Intent, switch it on

### Running on an AWS Instance
- Launch AWS Learning Academy Lab
- Create an instance with Vockey and allow HTTP Traffic. Other default settings are fine
- When the insance is up and running, grab its Public IPv4 address
- In a new terminal window, use the command: ssh -i ~/.ssh/labsuser.pem ec2-user@<Public IPv4 address> to ssh into the ec2 instance
- Do a: sudo yum install git to install git
- Once git is installed, clone the repo with: git clone https://github.com/cs220s24/trivia-discord-bot.git
- cd into the repo
- Create your .env file with: nano .env. Follow the steps from the .env file above
- Create a virtual environment and install dependencies with:
- python3 -m venv .venv
- source .venv/bin/activate
- pip install -r requirements.txt
- Finally run the program using: python3 main.py

### FLASK_SECRET_KEY
- Type: python3 in terminal to enter the python3 REPLenvironment
- Type import secrets
- Type print(secrets.token_hex())
- Whatever was printed out, paste that into the . env file between the quotation marks in FLASK_SECRET_KEY =""
