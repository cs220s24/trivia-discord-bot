from typing import Final
import os
import dotenv
from discord import Intents, Client, Message
from responses import get_response

def main():
    print('DISCORDTOKEN is found!')


if __name__ == '__main__':
    dotenv.load_dotenv()
    if not os.getenv('DISCORD_TOKEN'):
        print('Please set DISCORD_TOKEN in .env file')
        exit(1)
    main()