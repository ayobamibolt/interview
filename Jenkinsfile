pipeline {
    agent any
    tools {
        terraform "terraform 1.2.4"
    }
    parameters {
        choice(choices: ['apply','plan', 'destroy'],description: 'Selection for terraform',name:'ACTION')
    }
    environment {
        aws_credential = "niceAWS"
        repo_url = "MyRepositoryUrl"
        bucket = "nice-devops-interview"
        region = "us-east-1"
        lambda = "lambda-nice-devops-interview"
        finalterraform = "terraform"
    }

    stages {
        stage('Checkout') {
            steps {
            checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/ayobamibolt/interview']]])            
          }
        }
        
        stage ("Terraform init") {
            steps {
                sh ('terraform init')
            }
        }
        
        //This is to allow either terrform apply or plan or destroy using "action" as a parameter
        stage ("Terraform Action") {
            steps {
                script { 
                    string decision=""
                    if(params.ACTION == 'apply') {
                        decision = "terraform apply --auto-approve"
                    }
                    else if(params.ACTION == 'plan'){
                        decision = "terraform plan" 
                    }
                    else
                    {
                        decision = "terraform destroy --auto-approve"
                    }
                    echo "decision -->${decision}"
                    finalterraform = "${decision}"
                }

                    echo "Terraform action is --> ${params.ACTION}"
                    sh ("${finalterraform}")
            }
        }

        stage("Upload"){
            when{expression {return params.ACTION == 'apply'}}
            steps{
                withAWS(region:"${region}", credentials:"${aws_credential}"){
                      s3Upload(file:"parse_me.txt", bucket:"${bucket}")
                }    
           }            
        }
                            
        stage('AWS Lambda'){
            when{expression {return params.ACTION == 'apply'}}
            steps {
                withAWS(region:"${region}", credentials:"${aws_credential}"){
                    string output = invokeLambda([
                        functionName: 'lambda-nice-devops-interview', 
                        synchronous: true, 
                        useInstanceCredentials: true,
                        returnValueAsString: true])
                }
                echo "${output}"
            }
        }                    
      
                            
    }
}
