pipeline {
    agent any
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
        
        stage ("terraform init") {
            steps {
                sh ('terraform init') 
            }
        }
        
        stage ("terraform Action") {
            steps {
                echo "Terraform action is --> ${action}"
                sh ('terraform ${action} --auto-approve') 
           }
        }

        stage("Upload"){
              steps{
                    withAWS(region:"${region}", credentials:"${aws_credential}){
                      s3Upload(file:"parse_me.txt", bucket:"${bucket}")
                  }    
               }            
        }
                            
        stage('AWS Lambda'){
	        steps {
	        	def output = invokeLambda([awsRegion: 'us-east-1',
			        functionName: 'lambda-nice-devops-interview', 
			        payload: "{ \"Suspend\": \"true\"}] }", 
			        synchronous: true, 
			        useInstanceCredentials: true])
			echo output
	          }
          }                    
      
                            
    }
}
