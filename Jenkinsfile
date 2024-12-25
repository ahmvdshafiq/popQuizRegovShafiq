pipeline {
  agent any

  environment {
    TERRAFORM_DIR = "./terraform/stages"
  }

  stages {
    stage('Dev') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-access-key-upwd', 
                                          usernameVariable: 'AWS_ACCESS_KEY_ID', 
                                          passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          script {
            sh "export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
            sh "export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
            sh "terraform init -chdir=${TERRAFORM_DIR}/dev"
            sh "terraform apply -auto-approve -chdir=${TERRAFORM_DIR}/dev"
          }
        }
      }
    }
    stage('QA') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-access-key', 
                                          usernameVariable: 'AWS_ACCESS_KEY_ID', 
                                          passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          script {
            input "Proceed to QA?"
            sh "export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
            sh "export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
            sh "terraform init -chdir=${TERRAFORM_DIR}/qa"
            sh "terraform apply -auto-approve -chdir=${TERRAFORM_DIR}/qa"
          }
        }
      }
    }
    stage('UAT') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-access-key', 
                                          usernameVariable: 'AWS_ACCESS_KEY_ID', 
                                          passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          script {
            input "Proceed to UAT?"
            sh "export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
            sh "export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
            sh "terraform init -chdir=${TERRAFORM_DIR}/uat"
            sh "terraform apply -auto-approve -chdir=${TERRAFORM_DIR}/uat"
          }
        }
      }
    }
    stage('Prod') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-access-key', 
                                          usernameVariable: 'AWS_ACCESS_KEY_ID', 
                                          passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          script {
            input "Deploy to Prod?"
            sh "export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
            sh "export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
            sh "terraform init -chdir=${TERRAFORM_DIR}/prod"
            sh "terraform apply -auto-approve -chdir=${TERRAFORM_DIR}/prod"
          }
        }
      }
    }
  }
}
