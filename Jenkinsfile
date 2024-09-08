pipeline {
    agent {
        docker { image 'python:latest' }
    }
    stages {
        stage('python init') {
            steps {
                sh 'python --version'
            }
        }
    }
}