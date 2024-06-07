import psycopg2
import os
from datetime import datetime, timedelta
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

def drop_all_db():
    cur, conn = conn_db()
    cur.execute("""DROP TABLE IF EXISTS sessions""")
    cur.execute("""DROP TABLE IF EXISTS sensors""")
    cur.execute("""DROP TABLE IF EXISTS users""")

    conn.commit()
    conn.close()

def init_db():
    cur, conn = conn_db()

    cur.execute("""
            CREATE TABLE IF NOT EXISTS sessions
            (
                session_id INT,
                sink_id CHAR(20),
                sensor_id INT,
                water_amount NUMERIC(4, 2),
                duration INT,
                start_time TIME,
                end_time TIME,
                date DATE
         )""")

    conn.commit()
    conn.close()

def init_graph_db():
    cur, conn = conn_db()

    cur.execute("""
                CREATE TABLE IF NOT EXISTS graph_data
                (
                    user_id CHAR(50) REFERENCES users(public_id),
                    cum_sum NUMERIC(5, 2),
                    date DATE
                )""")
    conn.commit()
    conn.close()

def init_sensor_db():
    cur, conn = conn_db()

    cur.execute("""
                CREATE TABLE IF NOT EXISTS sensors
                (
                    user_id CHAR(50) REFERENCES users(public_id),
                    sensor_id INT,
                    sink_id CHAR(20),
                    PRIMARY KEY(user_id, sensor_id)
                )""")
    conn.commit()
    conn.close()


def init_user_db():
    cur, conn = conn_db()
   
    #for testing purposes, replace with more sophisticated table creation and deletion when having dependencies

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

def query_n_replace_graph_db(reading, sensor_id, date):
    cur, conn = conn_db()
    cur.execute("""SELECT DISTINCT user_id
                    FROM sensors
                    WHERE sensor_id = %s""", (sensor_id,))
    user_id = cur.fetchall()
    conn.commit()
    cur.execute("""SELECT cum_sum 
                    FROM graph_data 
                    WHERE user_id = %s
                    AND date = %s""", (user_id[0], date))
    
    data = cur.fetchall()
    if len(data) == 0:
        cur.execute("""INSERT INTO graph_data (user_id, cum_sum, date)
                        VALUES (%s, %s, %s)""", (user_id[0], reading, date))
    else:
        cur.execute("""UPDATE graph_data SET cum_sum = %s
                        WHERE user_id = %s
                        AND date = %s""", ((float(reading) + float(data[0][0])), user_id[0], date))
    conn.commit()
    conn.close()


def query_graph_7day(user_id, date):
    #fetch past 7 days worth of cumm_sum data, if no date present in 7 days fill it with 0?
    cur, conn = conn_db()
    data_dict = {}
    date_obj = datetime.strptime(date, "%Y-%m-%d")
    for i in range(1,8):
        previous_date = date_obj - timedelta(days=i)
        previous_date_str = previous_date.strftime('%m-%d-%Y')
        cur.execute("""SELECT cum_sum 
                        FROM graph_data
                        WHERE user_id = %s
                        AND date = %s""", (user_id, previous_date_str))
        data = cur.fetchall()
        if len(data) == 0:
            data_dict[previous_date_str] = 0
        else:
            data_dict[previous_date_str] = float(data[0][0])

    return data_dict



def insert_sensor_db(user_id, sensor_id, sink_id):
    cur, conn = conn_db()

    cur.execute("""INSERT INTO sensors (user_id, sensor_id, sink_id)
                VALUES (%s, %s, %s)""", (user_id, sensor_id, sink_id))
    conn.commit()
    conn.close()

def query_sensor_db(user_id, sensor_id):
    cur, conn = conn_db()

    cur.execute("""SELECT * FROM sensors s
                WHERE s.user_id = %s
                AND s.sensor_id = %s""", (user_id, sensor_id))
    
    data = cur.fetchall()
    print(data)
    #if there is an entry return True
    if len(data) != 0:
        return True
    #if there is no entry return False
    elif len(data) == 0:
        return False

def del_sensor_db(user_id, sensor_id):
    cur, conn = conn_db()
    cur.execute("""DELETE FROM sensors s
                WHERE s.user_id = %s
                AND s.sensor_id = %s""", (user_id, sensor_id))

    conn.commit()
    conn.close()

def query_sensor_db_for_sinks(user_id):
    cur, conn = conn_db()
    cur.execute("""SELECT sensor_id, sink_id FROM sensors s
                WHERE s.user_id = %s""", (user_id,))
    data = cur.fetchall()

    conn.commit()
    conn.close()
    return data

def insert_db(sessions, session_id, sink_id, sensor_id, water_amount, duration, start_time, end_time, date):
    cur, conn = conn_db()

    cur.execute("""INSERT INTO sessions (session_id,
                                    sink_id,
                                    sensor_id,
                                    water_amount,
                                    duration,
                                    start_time,
                                    end_time,
                                    date)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)""", (session_id,
                                                                sink_id,
                                                                sensor_id,
                                                                water_amount,
                                                                duration,
                                                                start_time,
                                                                end_time,
                                                                date))
    conn.commit()
    conn.close()

def request_db(date, sink_id, current_user):
    cur, conn = conn_db()

    cur.execute("""SELECT DISTINCT * FROM sessions s
                    JOIN sensors se ON s.sensor_id = se.sensor_id
                    JOIN users u ON u.public_id = se.user_id
                    WHERE s.date=%s
                    AND se.user_id=%s
                    AND s.sink_id = %s""", (date, current_user, sink_id))
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
    print(data)
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
