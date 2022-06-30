pipeline {
    agent any
    tools {
        terraform "terraform 1.2.4"
    }
    parameters {
        choice(
        choices: ['apply','plan', 'destroy'],
        description: 'Selection for terraform',
        name:'ACTION')
    }
    environment {
        aws_credential = "niceAWS"
        repo_url = "MyRepositoryUrl"
        bucket = "nice-devops-interview"
        region = "us-east-1"
        lambda = "lambda-nice-devops-interview"
       
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
        stage ("Terraform Action Apply") {
            when {expression {params.ACTION == 'apply'}}
            steps {
                echo "Terraform action is --> ${action}"
                sh ('terraform ${action} --auto-approve') 
           }
        }

        //This is to allow either terrform apply or plan or destroy using "action" as a parameter
        stage ("Terraform Action Plan") {
            when {expression {params.ACTION == 'plan'}}
            steps {
                echo "Terraform action is --> ${action}"
                sh ('terraform ${action}') 
           }
        }

        //This is to allow either terrform apply or plan or destroy using "action" as a parameter
        stage ("Terraform Action Destroy") {
            when {expression {params.ACTION == 'destroy'}}
            steps {
                echo "Terraform action is --> ${action}"
                sh ('terraform ${action} --auto-approve') 
           }
        }

        stage("Upload"){
            when{expression {action=='apply'}}
            steps{
                withAWS(region:"${region}", credentials:"${aws_credential}"){
                      s3Upload(file:"parse_me.txt", bucket:"${bucket}")
                }    
           }            
        }
                            
        stage('AWS Lambda'){
            when{expression {action=='apply'}}
            steps {
                withAWS(region:"${region}", credentials:"${aws_credential}"){
                    echo output = invokeLambda([
                        functionName: 'lambda-nice-devops-interview', 
                        synchronous: true, 
                        useInstanceCredentials: true])
                }
            }
        }                    
      
                            
    }
}
