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
      }
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                          credentialsId: 'aws-credentials',
                          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
            sh '''
              cd terraform
              terraform init
              terraform apply -auto-approve -target=aws_ecr_repository.hello_world
            '''
        }
      }
    }
  }
}