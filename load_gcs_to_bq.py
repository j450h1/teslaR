import os
from pathlib import Path
from google.cloud import bigquery

CREDENTIALS_PATH = os.environ["GCP_KEYPATH"]
BUCKET = os.environ['BUCKET_NAME']
SCHEMA_PATH = Path.cwd() / 'schemas' / 'vehicle_status.json'
project_id = os.environ['PROJECT_ID']

client = bigquery.Client.from_service_account_json(CREDENTIALS_PATH)

dataset_id = 'tesla'
table = 'vehicle_status'

dataset_ref = client.dataset(dataset_id)
job_config = bigquery.LoadJobConfig()
#job_config.autodetect = True
job_config = bigquery.LoadJobConfig()

job_config.schema = client.schema_from_json(SCHEMA_PATH)

job_config.write_disposition = bigquery.WriteDisposition.WRITE_TRUNCATE
job_config.source_format = bigquery.SourceFormat.NEWLINE_DELIMITED_JSON
uri = "gs://{0}/tesla/*.json".format(BUCKET)

load_job = client.load_table_from_uri(
    uri,
    dataset_ref.table(table),
    location="US",  # Location must match that of the destination dataset.
    job_config=job_config,
)  # API request
print("Starting job {}".format(load_job.job_id))

load_job.result()  # Waits for table load to complete.
print("Job finished.")

destination_table = client.get_table(dataset_ref.table(table))
print("Loaded {} rows.".format(destination_table.num_rows))

# The schema was all fucked up, so we can overwrite it

# BELOW NEVER WORKED - THE SCHEMA STAYED THE SAME
# 
# table_id = '{0}.{1}.{2}'.format(project_id, dataset_id, table)
# job_config = bigquery.QueryJobConfig(destination=table_id)
# job_config.write_disposition = bigquery.WriteDisposition.WRITE_TRUNCATE
# 
# sql = """
# SELECT * FROM `jas-test.tesla.vehicle_status`
# """
# 
# # Start the query, passing in the extra configuration.
# query_job = client.query(sql, job_config=job_config)  # Make an API request.
# query_job.result()  # Wait for the job to complete.
# 
# print("Query results loaded to the table {}".format(table_id))

# THIS IS THE WORKAROUND TO SIMPLY UNNEST THE RELEVANT COLUMN
#
# SELECT 
# DATETIME(TIMESTAMP_MILLIS(timestamp), "America/Los_Angeles") as datetime
# FROM `jas-test.tesla.vehicle_status`, 
# UNNEST(timestamp) AS timestamp 
# 
