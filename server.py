import mysql.connector
import os
import dotenv
from flask import Flask, request, jsonify

def create_app():
    '''
    Creates a Flask app with the specified configuration.
    '''
    app = Flask(__name__)
    app.config['SECRET_KEY'] = os.getenv('FLASK_SECRET_KEY')
    
    @app.route('/getQuestions') # Grabs the questions from the database
    def getQuestions():
       cursor, connection = connectToMySQL()
       use_db = 'USE trivia_db'
       select = "select * from trivia_questions"
       
       cursor.execute(use_db)
       cursor.execute(select)
        
       questions = cursor.fetchall()
    
       cursor.close()
       connection.close()

       return jsonify(questions)
    return app
       
    
def connectToMySQL():
    '''
    Connects to MySQL and returns a cursor and connection object.
    '''
    cnx = mysql.connector.connect(user='project', password='project',
                                  host='localhost',
                                  database='trivia_db')
    cursor = cnx.cursor()
    return cursor, cnx

if __name__ == '__main__':
    dotenv.load_dotenv()
    if not os.getenv('FLASK_SECRET_KEY'):
        print('Please set FLASK_SECRET_KEY in .env file.')
        exit(1)

    app = create_app()
    app.run(debug=True, port=8000, host="0.0.0.0")
    
    