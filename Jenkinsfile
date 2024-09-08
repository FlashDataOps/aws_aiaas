pipeline {
    agent any
    stages {
        stage('python init') {
            steps {
                sh 'python --version'
            }
        }
        stage('docker init') {
            steps {
                sh 'docker --version'
            }
        }
    }
}