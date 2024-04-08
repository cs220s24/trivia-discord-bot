import os
import discord
import dotenv

import time

def main():

    # Load the environment variables
    
    TOKEN = os.getenv('DISCORD_TOKEN')
    GUILD = os.getenv('DISCORD_GUILD')

    # Create a Discord client
    intents = discord.Intents.default()
    intents.message_content = True

    client = discord.Client(intents=intents)

    # When the bot is ready, print a message to the console
    @client.event
    async def on_ready():
        print(f'{client.user.name} has connected to Discord!')

    # When a message is sent, respond with a message if a command is found
    @client.event
    async def on_message(message):
        if message.author == client.user:
            return
    
        # Respond to "ping" with "pong!"
        if message.content.strip().lower() == 'ping':
            response = 'pong!'
            await message.channel.send(response)

        # Respond to "happy birthday" with "Happy Birthday!!"
        if message.content.strip().lower() == 'happy birthday':
            response = 'Happy Birthday!!'
            await message.channel.send(response)

        # Respond to "who am i?" with the user's name
        if message.content.strip().lower() == 'who am i?':
            response = message.author
            await message.channel.send(response)

        # Respond to "start quiz" with a brief quiz
        quiz_questions = {
            'Are brownies good? Yes or no': 'Yes',
            'What country was I created in?': 'US',
            'What class is this for?': 'Devops',
            'What is the capital of France?': 'Paris'
        }

        if message.content.strip().lower() == 'start quiz':
            num_correct = 0
            num_incorrect = 0

            # Ask each question in the quiz_questions dictionary
            for question, answer in quiz_questions.items():
                time.sleep(1)
                await message.channel.send(question)

                response = await client.wait_for('message')

                if response.content.strip().lower() == answer.lower():
                    await message.channel.send('Correct!')
                    num_correct += 1

                else:
                    await message.channel.send('Incorrect!')
                    num_incorrect += 1

            # Send a message with the number of correct and incorrect answers
            await message.channel.send('Quiz complete! You got ' + str(num_correct) + ' correct and ' + str(num_incorrect) + ' incorrect.')

    client.run(TOKEN)

if __name__ == '__main__':
    dotenv.load_dotenv()
    if not os.getenv('DISCORD_TOKEN'):
        print('No token found. Please create a .env file with a DISCORD_TOKEN variable.')
        exit(1)
    main()