pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    environment {
        TERRAFORM_DIR         = "./terraform/stages"
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'ap-south-1'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/CodeSagarOfficial/jenkins-scripts.git'
            }
        }

        stage('Dev') {
            steps {
                script {
                    input message: 'Approve deployment to Dev?', ok: 'Proceed'
                    sh "terraform init -chdir=${TERRAFORM_DIR}/dev"
                    sh "terraform plan -out=${TERRAFORM_DIR}/dev/tfplan -chdir=${TERRAFORM_DIR}/dev"
                    if (params.action == 'apply') {
                        sh "terraform apply -input=false ${TERRAFORM_DIR}/dev/tfplan"
                    } else if (params.action == 'destroy') {
                        sh "terraform destroy --auto-approve -chdir=${TERRAFORM_DIR}/dev"
                    }
                }
            }
        }

        stage('QA') {
            steps {
                script {
                    input message: 'Approve deployment to QA?', ok: 'Proceed'
                    sh "terraform init -chdir=${TERRAFORM_DIR}/qa"
                    sh "terraform plan -out=${TERRAFORM_DIR}/qa/tfplan -chdir=${TERRAFORM_DIR}/qa"
                    if (params.action == 'apply') {
                        sh "terraform apply -input=false ${TERRAFORM_DIR}/qa/tfplan"
                    } else if (params.action == 'destroy') {
                        sh "terraform destroy --auto-approve -chdir=${TERRAFORM_DIR}/qa"
                    }
                }
            }
        }

        stage('UAT') {
            steps {
                script {
                    input message: 'Approve deployment to UAT?', ok: 'Proceed'
                    sh "terraform init -chdir=${TERRAFORM_DIR}/uat"
                    sh "terraform plan -out=${TERRAFORM_DIR}/uat/tfplan -chdir=${TERRAFORM_DIR}/uat"
                    if (params.action == 'apply') {
                        sh "terraform apply -input=false ${TERRAFORM_DIR}/uat/tfplan"
                    } else if (params.action == 'destroy') {
                        sh "terraform destroy --auto-approve -chdir=${TERRAFORM_DIR}/uat"
                    }
                }
            }
        }

        stage('Prod') {
            steps {
                script {
                    input message: 'Approve deployment to Prod?', ok: 'Proceed'
                    sh "terraform init -chdir=${TERRAFORM_DIR}/prod"
                    sh "terraform plan -out=${TERRAFORM_DIR}/prod/tfplan -chdir=${TERRAFORM_DIR}/prod"
                    if (params.action == 'apply') {
                        sh "terraform apply -input=false ${TERRAFORM_DIR}/prod/tfplan"
                    } else if (params.action == 'destroy') {
                        sh "terraform destroy --auto-approve -chdir=${TERRAFORM_DIR}/prod"
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                // Clean up sensitive files
                sh "find ${TERRAFORM_DIR} -name 'tfplan*' -delete"
            }
        }
        success {
            echo 'Pipeline executed successfully.'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
