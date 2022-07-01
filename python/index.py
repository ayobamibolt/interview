import boto3

s3_client = boto3.resource("s3")
S3_BUCKET = 'nice-devops-interview'

def lambda_handler(event, context):
  object_key = "parse_me.txt"
  file_content = (s3_client.Object(
      bucket_name=S3_BUCKET, key=object_key)).get()["Body"].read().decode('utf-8')
  print(type(file_content))
  final_string = ''.join((x for x in (file_content.replace("00", " ")) if not x.isdigit()))
  return final_string
