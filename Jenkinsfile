pipeline {
  agent any

  environment {
    TERRAFORM_DIR = "/home/mad/terraform/terraform/stages"
  }

  stages {
    stage('Initialize Terraform for Dev') {
      steps {
        // Using AWS credentials securely
        withCredentials([usernamePassword(
            credentialsId: 'aws-access-key-upwd',
            usernameVariable: 'AWS_ACCESS_KEY_ID',
            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {
          sh '''
            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
            terraform init -chdir=$TERRAFORM_DIR/dev
            terraform apply -auto-approve -chdir=$TERRAFORM_DIR/dev
          '''
        }
      }
    }

    stage('Promote to QA') {
      steps {
        withCredentials([usernamePassword(
            credentialsId: 'aws-access-key',
            usernameVariable: 'AWS_ACCESS_KEY_ID',
            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {
          script {
            input "Deploy to QA?"
            sh '''
              export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
              export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
              terraform init -chdir=$TERRAFORM_DIR/qa
              terraform apply -auto-approve -chdir=$TERRAFORM_DIR/qa
            '''
          }
        }
      }
    }

    stage('Promote to UAT') {
      steps {
        withCredentials([usernamePassword(
            credentialsId: 'aws-access-key',
            usernameVariable: 'AWS_ACCESS_KEY_ID',
            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {
          script {
            input "Deploy to UAT?"
            sh '''
              export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
              export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
              terraform init -chdir=$TERRAFORM_DIR/uat
              terraform apply -auto-approve -chdir=$TERRAFORM_DIR/uat
            '''
          }
        }
      }
    }

    stage('Deploy to Production') {
      steps {
        withCredentials([usernamePassword(
            credentialsId: 'aws-access-key',
            usernameVariable: 'AWS_ACCESS_KEY_ID',
            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {
          script {
            input "Deploy to Production?"
            sh '''
              export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
              export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
              terraform init -chdir=$TERRAFORM_DIR/prod
              terraform apply -auto-approve -chdir=$TERRAFORM_DIR/prod
            '''
          }
        }
      }
    }
  }
}
