pipeline {
    agent any

    environment {

        GIT_REPO   = "https://github.com/mehar-pa-45/Java-indigo-Airlines.git"
        GIT_BRANCH = "main"

        DOCKERHUB_USER = "mehardocker45"
        IMAGE_NAME     = "java-indigo-airlines"
        IMAGE_TAG      = "${BUILD_NUMBER}"

        DOCKER_CREDS   = "Docker_CRED"

        CONTAINER_NAME = "indigo-airlines-container"
        HOST_PORT      = "8081"
        CONTAINER_PORT = "8080"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-cred', url: 'https://github.com/mehar-pa-45/Java-indigo-Airlines.git']])
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }

        stage('DockerHub Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_CREDS}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    sh """
                    echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                    """
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                sh """
                docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage('Deploy Container') {
            steps {
                sh """
                docker stop ${CONTAINER_NAME} || true
                docker rm ${CONTAINER_NAME} || true

                docker run -d \
                -p ${HOST_PORT}:${CONTAINER_PORT} \
                --name ${CONTAINER_NAME} \
                ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }
    }
}
