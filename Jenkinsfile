pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "ankitanallamilli"
        IMAGE_NAME     = "banking-application"
        IMAGE_TAG      = "${BUILD_NUMBER}"
        DOCKER_CREDS   = "ANKITA_DOCK-HUB"
    }
    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                credentialsId: 'Github-Cred',
                url: 'https://github.com/2000ankitareddy/Java-Bank-Application-Project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} .
                docker tag ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ${DOCKERHUB_USER}/${IMAGE_NAME}:latest
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
                docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:latest
                """
            }
        }
    }
}
