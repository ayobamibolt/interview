provider "aws" {
  region     = "us-east-1" 
}

#Create s3 bucket
resource "aws_s3_bucket" "terraform_state_s3" {
  bucket = "nice-devops-interview" 
}

#uploading python zip to lambda funtion
data "archive_file" "zip_the_python_code" {
type        = "zip"
source_dir  = "${path.module}/python/"
output_path = "file-parser.zip"

}


resource "aws_lambda_function" "lambda-nice-devops-interview" {
filename                       = "file-parser.zip"
function_name                  = "lambdaTest"
source_code_hash               = data.archive_file.zip_the_python_code.output_base64sha256
role                           = "arn:aws:iam::557414474363:role/lambda-execution-devops-interview"
handler                        = "lambda_function.lambda_handler"
runtime                        = "python3.8"

}



