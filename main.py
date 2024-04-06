import os
import dotenv
from discord import Intents, Client, Message
from responses import get_response

def main():

    # STEP 1: Bot Setup
    intents = Intents.default()
    intents.message_content = True
    client = Client(intents=intents)

    # STEP 2: Message Functionality
    def send_message(message, user_message):

        # If no message is provided, return
        if not user_message:
            print('No message to send')
            return
    
        # Check if the message is a private message - TRUE or FALSE
        is_private = user_message.startswith('?')

        # If the message is private, get user message
        if is_private:
            user_message = user_message[1:]
    
        try:

            # Check for and/or send response
            response = get_response(user_message)

            if is_private:
                message.author.send(response)

            else:
                message.channel.send(response)

        except Exception as e:
            print(e)

if __name__ == '__main__':
    dotenv.load_dotenv()
    if not os.getenv('DISCORD_TOKEN'):
        print('Please set DISCORD_TOKEN in .env file')
        exit(1)
    main()