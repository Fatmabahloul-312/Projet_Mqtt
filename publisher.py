from paho.mqtt import client as mqtt_client
import time
from random import randrange, uniform

broker = 'broker.emqx.io'
port = 1883
topic = "TEMPERATURE"

# Create a new client instance
client = mqtt_client.Client("temp_out")

# Connect to the broker
client.connect(broker)

# Publish a message 

while True:
    randNumber= randrange(50)
    client.publish(topic, randNumber)
    print(" Just Published " + str(randNumber) + " to Topic TEMPERATURE ")
    time.sleep(3)