"""Publishes multiple messages to a Pub/Sub topic with an error handler."""
from concurrent import futures
from google.cloud import pubsub_v1
from typing import Callable
from datetime import datetime
import  json
import random

# TODO(developer)
project_id = "dlthub-analytics"
topic_id = "telemetry_data_tera"


def generate_event(event_id):
    
    event = {
        "event_id": event_id,
        "timestamp": datetime.now().isoformat(),
        "event_type": random.choice(["login", "purchase", "logout", "signup"]),
        "user_info": {
            "user_id": random.randint(1000, 9999),
            "username": f"user_{random.randint(100, 999)}",
            "location": random.choice(["USA", "UK", "Canada", "Australia", "India"])
        },
        "transaction_details": None
    }

    
    if event["event_type"] == "purchase":
        event["transaction_details"] = {
            "transaction_id": random.randint(10000, 99999),
            "amount": round(random.uniform(10.0, 500.0), 2),
            "currency": random.choice(["USD", "EUR", "GBP", "INR", "AUD"]),
            "items_purchased": random.randint(1, 10)
        }

    return json.dumps(event)

# Batch settings for the publisher
batch_settings = pubsub_v1.types.BatchSettings(
    max_messages=10,  # default 100
    max_bytes=1024,  # default 1 MB
    max_latency=2,  # default 10 ms
)


publisher = pubsub_v1.PublisherClient(batch_settings=batch_settings)
topic_path = publisher.topic_path(project_id, topic_id)


number_of_events = 50 
for i in range(number_of_events):
    event_data = generate_event(i)  
    data = event_data.encode("utf-8")  

    
    publish_future = publisher.publish(topic_path, data)
    print(f"Published event {i} to {topic_path}. Message ID: {publish_future.result()}")

print("All events published.")
