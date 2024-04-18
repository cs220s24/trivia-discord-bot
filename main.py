import os
import dotenv

import discord
import mysql.connector

import time

def fetch_questions(cursor):
    '''
    Fetch each trivia question from the database and return them as a list of dictionaries.
    '''
    use_db = 'USE trivia_db;'
    select = 'SELECT * FROM trivia_questions;'

    cursor.execute(use_db)
    cursor.execute(select)

    questions = cursor.fetchall()

    return questions


def main():
    '''
    Activates and runs the Discord bot.
    Asks several trivia questions and responds to specific commands.
    Scores the user based on the number of correct answers.
    '''
    # Load the environment variables
    TOKEN = os.getenv('DISCORD_TOKEN')
    GUILD = os.getenv('DISCORD_GUILD')

    # Create a Discord client
    intents = discord.Intents.default()
    intents.message_content = True

    client = discord.Client(intents=intents)

    @client.event
    async def on_ready():
        '''
        Print a message to the console when the bot is ready.
        '''
        print(f'{client.user.name} has connected to Discord!')

    @client.event
    async def on_message(message):
        '''
        Respond with a certain message if specific commands are found when a message is sent.
        '''
        if message.author == client.user:
            return
    
        # Respond to "ping" with "pong!"
        if message.content.strip().lower() == 'ping':
            response = 'pong!'
            await message.channel.send(response)

        # TODO: REMOVE ONCE DONE TESTING?
        if message.content.strip().lower() == 'happy birthday':
            response = 'Happy Birthday!!'
            await message.channel.send(response)

        # Respond to "whoami" with the user's name
        if message.content.strip().lower() == 'whoami':
            response = message.author
            await message.channel.send(response)

        # TODO: REMOVE ONCE DONE TESTING?
        if message.content.strip().lower() == 'meow':
            response = 'meow:3'
            await message.channel.send(response)
        
        # TODO: REMOVE ONCE DONE TESTING?
        if message.content.strip().lower() == 'ur momma':
            response = 'ur momma ur momma'
            await message.channel.send(response)

        # Respond to "start quiz" with a brief quiz
        if message.content.strip().lower() == 'start quiz':
            
            num_correct = 0
            num_incorrect = 0

            # Fetch the questions from the database
            cursor, connection = connectToMySQL()
            quiz_questions = fetch_questions(cursor)

            # Close the cursor and connection
            cursor.close()
            connection.close()

            # Ask each question in "quiz_questions"
            for question_data in quiz_questions:

                question_text = question_data['question']
                correct_answer = question_data['answer']
                time.sleep(1)

                await message.channel.send(question_text)
                time.sleep(1)

                response = await client.wait_for('message')

                if response.content.strip().lower() == str(correct_answer).lower():
                    await message.channel.send('Correct!')
                    num_correct += 1

                else:
                    await message.channel.send('Incorrect!')
                    num_incorrect += 1

            time.sleep(1)

            # Send a message with the number of correct and incorrect answers
            await message.channel.send('Quiz complete!\n')

            time.sleep(1)
            
            # All questions correct
            if num_correct == len(quiz_questions):
                await message.channel.send(':tada: Perfect score! You got all the questions correct. :tada:')

            # All questions incorrect
            elif num_incorrect == len(quiz_questions):
                await message.channel.send(':sob: Oh no! You got all the questions incorrect. :sob:')
            
            # Some questions correct
            else:
                await message.channel.send('You got **' + str(num_correct) + '** correct and **' + str(num_incorrect) + '** incorrect.')
    
    client.run(TOKEN)


def connectToMySQL():
    '''
    Connects to MySQL and returns a cursor and connection object.
    '''
    cnx = mysql.connector.connect(user='project', password='project',
                                  host='localhost',
                                  database='trivia_db')
    cursor = cnx.cursor(dictionary=True)
    return cursor, cnx

if __name__ == '__main__':
    dotenv.load_dotenv()
    if not os.getenv('DISCORD_TOKEN'):
        print('No token found. Please create a .env file with a DISCORD_TOKEN variable.')
        exit(1)
    main()
