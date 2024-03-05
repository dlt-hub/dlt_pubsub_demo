from google.cloud import storage
import functions_framework
import dlt
import json
import threading

# Access the content of the file
client = storage.Client()

# Semaphore to control pipeline execution
pipeline_semaphore = threading.Semaphore(1)

# Define the DLT pipeline configuration
pipeline = dlt.pipeline(
    pipeline_name = "tel_pipeline",
    destination = "bigquery",
    dataset_name = "telemetry_data"
)

# Triggered by a change in a storage bucket
@functions_framework.cloud_event
def storage_bigquery(cloud_event):
    data = cloud_event.data

    bucket_name = data["bucket"]
    file_name = data["name"]

    # Access the content of the file
    bucket = client.bucket(bucket_name)
    blob = bucket.blob(file_name)

    try:
        file_content = blob.download_as_bytes()
        json_data = read_json_file(file_content)

        with pipeline_semaphore:
            # Run the DLT pipeline with the loaded JSON data
            load_info = pipeline.run(telemetry_logs(json_data), write_disposition='append')
            print(load_info)

    except Exception as e:
        print(f"Error processing file {file_name}: {str(e)}")


def read_json_file(file_content):
    data = []
    # Decode bytes-like object to string
    file_content_str = file_content.decode('utf-8')
    # Split data into lines
    lines = file_content_str.split('\n')

    for line in lines:
        # Remove leading/trailing whitespaces
        line = line.strip()
        # Skip empty lines
        if line:
            try:
                # Parse JSON
                json_object = json.loads(line)
                data.append(json_object)
            except json.JSONDecodeError as e:
                print(f"Error decoding JSON on line {line}: {str(e)}")
    return data

@dlt.resource(table_name=lambda i: i["event"], write_disposition='append')
def telemetry_logs(logs):
    yield logs