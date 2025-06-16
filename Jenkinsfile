pipeline {
    agent any

    tools {
        nodejs 'nodejs'  // This should match your NodeJS installation name in Jenkins global tools config
    }

    environment {
        IMAGE_TAG = "${env.BRANCH_NAME == 'main' ? 'nodemain:v1.0' : 'nodedev:v1.0'}"
        CONTAINER_NAME = "${env.BRANCH_NAME == 'main' ? 'nodemain' : 'nodedev'}"
        HOST_PORT = "${env.BRANCH_NAME == 'main' ? '3000' : '3001'}"
        CONTAINER_PORT = '3000'  // Your app inside container always listens on 3000
    }

    stages {
        stage('Checkout') {
            steps {
                // Use SSH credentials ID you configured in Jenkins
                checkout([$class: 'GitSCM',
                          branches: [[name: "*/${env.BRANCH_NAME}"]],
                          userRemoteConfigs: [[
                            url: 'git@github.com:TatoZhvania/Jenkins-CICD-App.git',
                            credentialsId: 'your-ssh-credential-id' // replace with your credentials ID
                          ]]
                ])
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${env.IMAGE_TAG} ."
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Stop and remove existing container gracefully if exists
                    sh "docker ps -q --filter name=${env.CONTAINER_NAME} | grep -q . && docker stop ${env.CONTAINER_NAME} || true"
                    sh "docker ps -a -q --filter name=${env.CONTAINER_NAME} | grep -q . && docker rm ${env.CONTAINER_NAME} || true"

                    // Run new container
                    sh """
                      docker run -d \
                        --name ${env.CONTAINER_NAME} \
                        --expose ${env.CONTAINER_PORT} \
                        -p ${env.HOST_PORT}:${env.CONTAINER_PORT} \
                        ${env.IMAGE_TAG}
                    """
                }
            }
        }
    }
}
