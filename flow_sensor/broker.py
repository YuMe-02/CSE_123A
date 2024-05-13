import paho.mqtt.client as mqtt
import requests
import json
from datetime import datetime, timedelta

def on_connect(client, userdata, flags, rc):
	print("Connected with result code "+str(rc))
	client.subscribe("flow")

def parse_input(input_text):
	lines = input_text.split('\n')
	lines = [line.strip() for line in lines if line.strip()]
	return lines

def format_date(datetime_obj):
	date_str = datetime_obj.strftime("%Y-%m-%d")
	return date_str
	
def format_time(datetime_obj):
	time_str = datetime_obj.strftime("%H:%M")
	return time_str

def on_message(client, userdata, msg):
	parsed_data = parse_input(str(msg.payload.decode()))
	parsed_array = []
	
	for line in parsed_data:
		parsed_array.append(line)
	
	end_time_obj = datetime.now()
	duration = timedelta(seconds=int(parsed_array[1]))
	start_time_obj = end_time_obj - duration
	
	start_time = format_time(start_time_obj)
	date = format_date(start_time_obj)
	end_time = format_time(end_time_obj)
	session_id = 1
	
	parsed_array.append(date)
	parsed_array.append(start_time)
	parsed_array.append(end_time)
	parsed_array.append("YXb9uAIbzvAERwl2JftpqQIUE24XaQDCq7rrqro82ms")
	parsed_array.append(session_id)
	
	url = "https://cse123-flowsensor-server.com/api/sensor-data"
	#data = {"topic": str(msg.topic), "payload": str(msg.payload.decode())}
	data = {'session_id': parsed_array[8], 'sink_id': parsed_array[3], 'sensor_id': parsed_array[2], 'water_amount': parsed_array[0], 'duration': int(parsed_array[1]), 'start_time': parsed_array[5], 'end_time': parsed_array[6], 'date': parsed_array[4], 'api_key': parsed_array[7]}
	
	headers = {'Content-Type': 'application/json'}
	print("Sent!")
	response = requests.post(url, json=data, headers=headers)
	print(response.json())
	session_id = session_id + 1
	
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect("192.168.137.13", 1883, 60)

client.loop_forever()

