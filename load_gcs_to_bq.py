import os
from google.cloud import bigquery

CREDENTIALS_PATH = os.environ["GCP_KEYPATH"]
BUCKET = os.environ['BUCKET_NAME']
client = bigquery.Client.from_service_account_json(CREDENTIALS_PATH)

dataset_id = 'tesla'
dataset_ref = client.dataset(dataset_id)
job_config = bigquery.LoadJobConfig()
job_config.autodetect = True
job_config.write_disposition = bigquery.WriteDisposition.WRITE_TRUNCATE
job_config.source_format = bigquery.SourceFormat.NEWLINE_DELIMITED_JSON
uri = "gs://{0}/tesla/*.json".format(BUCKET)

load_job = client.load_table_from_uri(
    uri,
    dataset_ref.table("vehicle_status"),
    location="US",  # Location must match that of the destination dataset.
    job_config=job_config,
)  # API request
print("Starting job {}".format(load_job.job_id))

load_job.result()  # Waits for table load to complete.
print("Job finished.")

destination_table = client.get_table(dataset_ref.table("vehicle_status"))
print("Loaded {} rows.".format(destination_table.num_rows))
