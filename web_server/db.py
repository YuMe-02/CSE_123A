import psycopg2
import os
from datetime import datetime
from dotenv import load_dotenv

def conn_db():
    load_dotenv()
    DB_NAME = os.environ['DB_NAME']
    DB_USER = os.environ['DB_USERNAME']
    DB_PASS = os.environ['DB_PASSWORD']
    DB_HOST = os.environ['DB_HOST']
    try: 
        conn = psycopg2.connect(database=DB_NAME,
                                 user=DB_USER,
                                 password=DB_PASS,
                                 host=DB_HOST)
        print("Database connection successful")
    except:
        print("Database connection failed")

    return (conn.cursor(), conn)

def init_db():
    cur, conn = conn_db()

    cur.execute("""
            CREATE TABLE IF NOT EXISTS sessions
            (
                user_id CHAR(50),
                session_id INT,
                sink_id INT,
                sensor_id INT,
                water_amount NUMERIC(4, 2),
                duration INT,
                start_time TIME,
                end_time TIME,
                date DATE,
                is_error BOOLEAN,
                PRIMARY KEY (user_id, session_id)
         )""")

    conn.commit()
    conn.close()

def init_user_db():
    cur, conn = conn_db()
   
    #for testing purposes, replace with more sophisticated table creation and deletion when having dependencies

    cur.execute("""
                DROP TABLE users""")

    cur.execute("""
                CREATE TABLE IF NOT EXISTS users
                (
                    public_id CHAR(50) PRIMARY KEY NOT NULL,
                    name CHAR(100),
                    email CHAR(70),
                    password CHAR(150)
            )""")
    
    conn.commit()
    conn.close()

def init_key_db():
    cur, conn = conn_db()

    cur.execute("""
                CREATE TABLE IF NOT EXISTS keys
                (
                    key CHAR(43),
                    issue_date DATE,
                    PRIMARY KEY(key, issue_date)
                );""")
    conn.commit()
    conn.close()

def insert_db(sessions, session_id, sink_id, sensor_id, water_amount, duration, start_time, end_time, date, is_error):
    cur, conn = conn_db()

    cur.execute("""INSERT INTO sessions (session_id,
                                    sink_id,
                                    sensor_id,
                                    water_amount,
                                    duration,
                                    start_time,
                                    end_time,
                                    date,
                                    is_error)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)""", (session_id,
                                                                sink_id,
                                                                sensor_id,
                                                                water_amount,
                                                                duration,
                                                                start_time,
                                                                end_time,
                                                                date,
                                                                is_error))
    conn.commit()
    conn.close()

def request_db(date):
    cur, conn = conn_db()

    cur.execute("""SELECT * FROM sessions s
                    WHERE s.date=%s""", (date,))
    mobile_records = cur.fetchall()

    conn.commit()
    conn.close()
    return mobile_records

def replace_key(old_key, new_key, date):
    cur, conn = conn_db()

    cur.execute("""UPDATE keys k
                    SET key = %s, issue_date = %s
                    WHERE k.key=%s""", (new_key, date, old_key))

    conn.commit()
    conn.close()

def query_apiauth_by_key(key):
    cur, conn = conn_db()

    cur.execute("""SELECT * FROM keys k
                    WHERE k.key=%s""", (key,))

    data = cur.fetchall()
    conn.commit()
    conn.close()

    #return number of requested API keys stored in db (should be 0), and the issue date
    if (len(data)):
        return (len(data) == 1, data[0][1])
    else:
        return (False, 0)


def query_user_db(public_id):
    cur, conn = conn_db()

    cur.execute("""SELECT * FROM users u
                    WHERE u.public_id=%s""", (public_id,))
    
    data = cur.fetchall()
    conn.commit()
    conn.close()

    return data[0]

def query_user_email(email):
    cur, conn = conn_db()
    
    cur.execute("""SELECT * FROM users u
                    WHERE u.email=%s""", (email,))

    data = cur.fetchall()
    conn.commit()
    conn.close()

    #return empty list if no entries in db are returned
    if len(data)==1:
        return data[0]
    else:
        return []

def insert_user_db(public_uuid, name, email, password):
    cur, conn = conn_db()
    cur.execute("""INSERT INTO users (public_id,
                                            name,
                                            email,
                                            password)
                    VALUES (%s, %s, %s, %s)""", (public_uuid, name, email, password))
    conn.commit()
    conn.close()
