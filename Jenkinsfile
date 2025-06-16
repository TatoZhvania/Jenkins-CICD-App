pipeline {
    agent any

    environment {
        IMAGE_NAME = "react-app-${env.BRANCH_NAME}"
        PORT = "${env.BRANCH_NAME == 'main' ? '3000' : '3001'}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build --build-arg PORT=$PORT -t $IMAGE_NAME ."
            }
        }

        stage('Run Docker Container') {
            steps {
                // Stop and remove existing container if it exists
                sh "docker rm -f $IMAGE_NAME || true"
                sh "docker run -d -p $PORT:$PORT -e PORT=$PORT --name $IMAGE_NAME $IMAGE_NAME"
            }
        }
    }
}
