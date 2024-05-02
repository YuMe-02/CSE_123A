import paho.mqtt.client as mqtt
import requests

def on_connect(client, userdata, flags, rc):
	print("connected!")
	client.subscribe("flow")

def on_message(client, userdata, msg):
	print(msg.topic + str(msg.payload))
	
	# Send post request
	url = "https://cse123-flowsensor-server.com/post-echo"
	data = {"topic": str(msg.topic), "payload": str(msg.payload.decode())}
	print(str(msg.payload.decode()))
	response = requests.post(url, json=data)
	print(response.json())

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect("192.168.137.13", 1883, 60) 

client.loop_forever()
