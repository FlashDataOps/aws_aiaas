pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:latest' // Specify the version you need
        }
    }
    stages {
        stage('Terraform init') {
            steps {
                sh 'terraform --version'
            }
        }
    }
}