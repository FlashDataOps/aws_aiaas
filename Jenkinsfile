pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:1.5.3' // Specify the version you need
        }
    }
    stages {
        stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }
    }
}