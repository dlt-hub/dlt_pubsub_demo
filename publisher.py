from concurrent import futures
from google.cloud import pubsub_v1
from typing import Callable
from datetime import datetime
import json
import random
import string
import time

# TODO(developer)
project_id = "Add Project ID here"
topic_id = "Add Topic ID here"

def generate_random_string(length):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))


def generate_event():
    data = {
            "anonymousId": generate_random_string(32),
            "event": "pipeline_run",
            "properties": {
                "elapsed": round(random.uniform(0, 10), 6),
                "success": random.choice([True, False]),
                "destination_name": "duckdb",
                "destination_type": "dlt.destinations.duckdb",
                "pipeline_name_hash": generate_random_string(22),
                "dataset_name_hash": generate_random_string(22),
                "default_schema_name_hash": generate_random_string(22),
                "transaction_id": generate_random_string(32),
                "event_category": "pipeline",
                "event_name": random.choice(["pipeline_run", "pipeline_load", "pipeline_extract", "pipeline_normalize"]),
            },
            "context": {
                "ci_run": random.choice([True, False]),
                "python": "3.11.5",
                "cpu": random.randint(1, 16),
                "exec_info": [],
                "os": {
                    "name": "Darwin",
                    "version": "23.2.0"
                },
                "library": {
                    "name": "dlt",
                    "version": "0.4.5a0"
                }
            }
        }
    return json.dumps(data)


# # Batch settings for the publisher
# batch_settings = pubsub_v1.types.BatchSettings(
#     max_messages=10,  # default 100
#     max_bytes=1024,  # default 1 MB
#     max_latency=2,  # default 10 ms
# )


publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path(project_id, topic_id)


number_of_events = 50
for i in range(number_of_events):
    event_data = generate_event()
    data = event_data.encode("utf-8")

    publish_future = publisher.publish(topic_path, data)
    print(
        f"Published event {i} to {topic_path}. Message ID: {publish_future.result()}")
    # print(f"Published event {i} : {event_data}")
    # time.sleep(1)
    # print(event_data)

print("All events published.")
