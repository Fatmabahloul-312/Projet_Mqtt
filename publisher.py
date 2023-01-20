from paho.mqtt import client as mqtt_client
from faker import Faker
import time

broker = 'broker.emqx.io'
port = 1883
topic = "measure/tempurature"
fake = Faker()



# Create a new client instance
client = mqtt_client.Client()
fake = Faker()


# Connect to the broker
client.connect(broker, port, 60)

# Publish a message
client.publish(topic, "temperature")

while True:
    temp = fake.random_int(min=-30, max=60)
    client.publish(topic, temp)
    print(f"Published new temp measurement: {temp}")
    time.sleep(4)

# Disconnect from the broker
client.disconnect()
