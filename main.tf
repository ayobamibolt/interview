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

#Create s3 bucket
resource "aws_s3_bucket" "terraform_state_s3" {
  bucket = "nice-devops-interview" 
}
data "s3_policy-document" "example"{
{
    "Version": "2012-10-17",
    "Statement": [
      {
            "Sid": "ListBucket",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::557414474363:role/lambda-execution-devops-intervie"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::bucket"
        },
        {
            "Sid": "GetObjects",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::557414474363:role/lambda-execution-devops-intervie"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::bucket/*"
        }
      
    ]
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.terraform_state_s3.id
  policy = data.s3_policy-document.example.json

}

