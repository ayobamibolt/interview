import boto3

s3_client = boto3.resource("s3")
S3_BUCKET = 'nice-devops-interview'

def lambda_handler(event, context):
  object_key = "parseme"  # replace object key
  file_content = (s3_client.Object(
      Bucket=S3_BUCKET, Key=object_key)).get()["Body"].read()
  print(file_content)
  final_string = ''.join((x for x in (file_content.replace("00", " ")) if not x.isdigit()))
  return final_string
