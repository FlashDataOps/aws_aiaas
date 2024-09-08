pipeline {
    agent any
    stages {
        stage('Install Terraform') {
            steps {
                sh '''
                    # Download and install Terraform
                    wget https://releases.hashicorp.com/terraform/1.5.3/terraform_1.5.3_linux_amd64.zip
                    unzip terraform_1.5.3_linux_amd64.zip
                    sudo mv terraform /usr/local/bin/
                    terraform --version
                '''
            }
        }
        stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }
    }
}