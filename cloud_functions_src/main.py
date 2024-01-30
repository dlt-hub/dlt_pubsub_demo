from google.cloud import storage
import functions_framework
import dlt
import json

# Triggered by a change in a storage bucket
@functions_framework.cloud_event
def storage_bigquery(cloud_event):
    data = cloud_event.data

    bucket_name = data["bucket"]
    file_name = data["name"]

    # Access the content of the file
    client = storage.Client()

    bucket = client.bucket(bucket_name)
    blob = bucket.blob(file_name)

    file_content = blob.download_as_text()

    # Assuming each line in the file is a separate JSON object
    json_data = []
    for line in file_content.splitlines():
        try:
            json_object = json.loads(line)
            json_data.append(json_object)
        except json.JSONDecodeError as e:
            print(f"Error decoding JSON: {e}")
            

    pipeline = dlt.pipeline(
        pipeline_name="quick_start",
        destination="bigquery",
        dataset_name="pub_sub_data"
    )

    load_info = pipeline.run(json_data, write_disposition='append', table_name="events")

    print(load_info)