pipeline {
  agent none
  stages {
    stage('Python Stage') {
      agent { 
        docker { 
          image 'python:latest' // Python Docker image
        } 
      }
      steps {
        sh "python --version" // Run Python commands
        sh "python HelloWorld.py"
      }
    }
    stage('Terraform - Create ECR Repository') {
      agent {
        docker {
          image 'hashicorp/terraform:light'
          args '-i --entrypoint='
        }
      }
      environment {
        TF_VAR_aws_region = 'us-east-1'
        AWS_REGION = 'us-east-1' // Replace with your preferred region
        AWS_ACCOUNT_ID = '820242918450'
        ECR_REPO = 'hello-world' // Name of your ECR repository
      }
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                          credentialsId: 'aws-credentials',
                          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
            sh '''
              cd terraform/ecr
              alias aws='docker run --rm -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli'
              aws --version
              aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
              aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
              aws configure set region $AWS_REGION
              
              # Log in to AWS ECR
              aws ecr get-login-password --region $AWS_REGION

              # Check if ECR Repo already exists in account 
              EXISTING_REPO=$(aws ecr describe-repositories --repository-names ${ECR_REPO} --region ${AWS_REGION} --query 'repositories[0].repositoryName' --output text || echo "null")
              if [ "$EXISTING_REPO" == "null" ]; then
                  terraform init
                  terraform apply -auto-approve
              else
                  echo "ECR repository ${ECR_REPO} already exists."
              fi
            '''
        }
      }
    }
    stage('AWS Docker Stage') {
      agent any
      environment {
        AWS_REGION = 'us-east-1' // Replace with your preferred region
        AWS_ACCOUNT_ID = '820242918450'
        ECR_REPO = 'hello-world' // Name of your ECR repository
      }
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                  credentialsId: 'aws-credentials',
                  accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                  secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                  sh '''
                    alias aws='docker run --rm -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli'
                    aws --version
                    aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                    aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                    aws configure set region $AWS_REGION
                    
                    # Log in to AWS ECR
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                    
                    # Build and push the Docker image to ECR
                    docker build --platform linux/amd64 -t $ECR_REPO .
                    docker tag $ECR_REPO:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
                    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
                  '''
                }
      }
    }
    stage('Terraform - Create ECS') {
      agent {
        docker {
          image 'hashicorp/terraform:light'
          args '-i --entrypoint='
        }
      }
      environment {
        TF_VAR_aws_region = 'us-east-1'
        TF_VAR_aws_account_id = '820242918450'
        TF_VAR_aws_ecr_repo = 'hello-world'
      }
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                          credentialsId: 'aws-credentials',
                          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
            sh '''
              cd terraform/ecs
              terraform init
              terraform apply -auto-approve
            '''
        }
      }
    }
  }
}