pipeline {
  agent { docker "python" }

  stages {
    stage('python') {
      steps {
        sh "python --version"
      }
    }
    stage('terraform'){
        steps{
            sh "terraform init"
        }
    }
  }
}