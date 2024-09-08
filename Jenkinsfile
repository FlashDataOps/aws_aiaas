pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:1.5.3'
            args '-v /var/jenkins_home/workspace/aws_aiaas:/var/jenkins_home/workspace/aws_aiaas'
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