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
          withEnv(['AWS_ACCESS_KEY_ID', 'AWS_SECRET_ACCESS_KEY']) {
            sh 'terraform init -chdir=$TERRAFORM_DIR/dev'
            sh 'terraform apply -auto-approve -chdir=$TERRAFORM_DIR/dev'
          }
        }
      }
    }
    stage('QA') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-access-upwd', 
                                          usernameVariable: 'AWS_ACCESS_KEY_ID', 
                                          passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          input "Proceed to QA?"
          withEnv(['AWS_ACCESS_KEY_ID', 'AWS_SECRET_ACCESS_KEY']) {
            sh 'terraform init -chdir=$TERRAFORM_DIR/qa'
            sh 'terraform apply -auto-approve -chdir=$TERRAFORM_DIR/qa'
          }
        }
      }
    }
    stage('UAT') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-access-upwd', 
                                          usernameVariable: 'AWS_ACCESS_KEY_ID', 
                                          passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          input "Proceed to UAT?"
          withEnv(['AWS_ACCESS_KEY_ID', 'AWS_SECRET_ACCESS_KEY']) {
            sh 'terraform init -chdir=$TERRAFORM_DIR/uat'
            sh 'terraform apply -auto-approve -chdir=$TERRAFORM_DIR/uat'
          }
        }
      }
    }
    stage('Prod') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-access-upwd', 
                                          usernameVariable: 'AWS_ACCESS_KEY_ID', 
                                          passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          input "Deploy to Prod?"
          withEnv(['AWS_ACCESS_KEY_ID', 'AWS_SECRET_ACCESS_KEY']) {
            sh 'terraform init -chdir=$TERRAFORM_DIR/prod'
            sh 'terraform apply -auto-approve -chdir=$TERRAFORM_DIR/prod'
          }
        }
      }
    }
  }
}
