provider "aws" {
  region     = "us-east-1" 
}

#uploading python zip to lambda funtion
data "archive_file" "zip_the_python_code" {
type        = "zip"
source_dir  = "${path.module}/python/"
output_path = "${path.module}/pythonzip/pyparse.zip"

}

resource "aws_lambda_function" "lambdaTest" {
filename                       = "${path.module}/pythonzip/pyparse.zip"
function_name                  = "lambda-nice-devops-interview"
role                           = "arn:aws:iam::557414474363:role/lambda-execution-devops-interview"
handler                        = "index.lambda_handler"
runtime                        = "python3.8"

}

resource "aws_s3_bucket_policy" "allow_access"{
  bucket = aws_s3_bucket.terraform_state_s3.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Principal": {"AWS": "arn:aws:iam::557414474363:role/lambda-execution-devops-interview"},
      "Sid": "fix",
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::nice-devops-interview/*",
        "arn:aws:s3:::nice-devops-interview"
      ]
    }
  ]
}
EOF
}

#Create s3 bucket
resource "aws_s3_bucket" "terraform_state_s3" {
  bucket = "nice-devops-interview" 
}