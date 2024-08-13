pipeline {
    agent any

    tools {
        nodejs 'NODEJS'
    }

    environment {
        S3_BUCKET = 'jenkins-task-2-node-app-94144'
        AWS_DEFAULT_REGION = credentials('aws_default_region')
        AWS_ACCESS_KEY_ID = credentials('aws_access_key')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_key')
        TELEGRAM_TOKEN = credentials('telegram_token')
        CHAT_ID = '1187236965'
    }

    

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Arun2089/jenkins-task2.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
        stage('Deploy to S3') {
            steps {
                sh '''
                aws s3 sync build/ s3://$S3_BUCKET/
                '''
            }
        }
    }

    post {
        success {
            script {
                def message = "Deployment Successful!"
                sh "curl -s -X POST https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d text='${message}'"
            }
        }
        failure {
            script {
                def message = "Deployment Failed!"
                sh "curl -s -X POST https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d text='${message}'"
            }
        }
    }
}
