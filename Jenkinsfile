pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "lakshmivinuthnamutyala"
        IMAGE_NAME     = "java-bank-application-project"
        IMAGE_TAG      = "${BUILD_NUMBER}"
        DOCKER_CREDS   = "docker-credentials"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                credentialsId: 'Github-Cred',
                url: 'https://github.com/muthyalavinuthna/Java-Bank-Application-Project.git'
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

        stage('DockerHub Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_CREDS}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
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

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                kubectl apply -f deployment.yaml
                kubectl apply -f service.yaml
                kubectl apply -f ingress.yml

                kubectl set image deployment/java-bank-app \
                java-bank-container=${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }
    }
} 
