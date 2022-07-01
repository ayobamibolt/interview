provider "aws" {
  region     = "us-east-1" 
}

#uploading python zip to lambda funtion
data "archive_file" "zip_the_python_code" {
type        = "zip"
source_dir  = "${path.module}/python/"
output_path = "${path.module}/python/file-parser.zip"

}


resource "aws_lambda_function" "lambdaTest" {
filename                       = "${path.module}/python/file-parser.zip"
function_name                  = "lambda-nice-devops-interview"
source_code_hash               = data.archive_file.zip_the_python_code.output_base64sha256
role                           = "arn:aws:iam::557414474363:role/lambda-execution-devops-interview"
handler                        = "file-parser.zip.lambda_handler"
runtime                        = "python3.8"

}

#Create s3 bucket
resource "aws_s3_bucket" "terraform_state_s3" {
  bucket = "nice-devops-interview" 
}

