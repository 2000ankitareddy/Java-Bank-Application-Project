pipeline {
    agent any

    environment {

        WORK_DIR = "/var/lib/jenkins/workspace/Banking_Application"

        IMAGE_NAME = "banking-application"
        IMAGE_TAG = "${BUILD_NUMBER}"

        DOCKERHUB_USER = "ankitanallamilli"
        DOCKER_CREDS = "ANKITA_DOCK_HUB"

        AWS_REGION = "us-east-1"
        EKS_CLUSTER = "saicluster"

        DEPLOYMENT_FILE = "k8s/deployment.yml"
        DEPLOYMENT_NAME = "banking-deployment"
        CONTAINER_NAME = "banking-container"

        SERVICE_NAME = "banking-service"
        NAMESPACE = "default"

        EMAIL_ID = "ankitareddynallamilli@gmail.com"
    }


    stages {

        stage('Checkout Code') {

            steps {

                dir("${WORK_DIR}") {

                    git branch: 'main',
                    credentialsId: 'Github-Cred',
                    url: 'https://github.com/2000ankitareddy/Java-Bank-Application-Project.git'

                }

            }

        }


        stage('Build WAR File') {

            steps {

                dir("${WORK_DIR}") {

                    sh 'mvn clean package -DskipTests'

                }

            }

        }


        stage('Build Docker Image') {

            steps {

                dir("${WORK_DIR}") {

                    sh """
                    docker build \
                    -t ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} \
                    -t ${DOCKERHUB_USER}/${IMAGE_NAME}:latest .
                    """

                }

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
                    echo \$DOCKER_PASS | docker login \
                    -u \$DOCKER_USER --password-stdin
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


        stage('Configure EKS Access') {

            steps {

                sh """
                aws eks update-kubeconfig \
                --region ${AWS_REGION} \
                --name ${EKS_CLUSTER}
                """

            }

        }


        stage('Deploy to Kubernetes') {

            steps {

                dir("${WORK_DIR}") {

                    sh """
                    kubectl set image deployment/${DEPLOYMENT_NAME} \
                    ${CONTAINER_NAME}=${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} \
                    -n ${NAMESPACE} || kubectl apply -f ${DEPLOYMENT_FILE}
                    """

                }

            }

        }


        stage('Verify Deployment Rollout') {

            steps {

                sh """
                kubectl rollout status deployment/${DEPLOYMENT_NAME} \
                -n ${NAMESPACE} \
                --timeout=180s
                """

            }

        }


        stage('Verify Pods and Services') {

            steps {

                sh """
                kubectl get pods -n ${NAMESPACE}
                kubectl get svc -n ${NAMESPACE}
                kubectl get ingress -n ${NAMESPACE} || true
                """

            }

        }


        stage('Fetch Application URL') {

            steps {

                sh """
                echo "Fetching LoadBalancer URL..."

                kubectl get svc ${SERVICE_NAME} \
                -n ${NAMESPACE}
                """

            }

        }

    }


    post {

        success {

            echo "Deployment Successful 🚀"

            emailext(

                subject: "SUCCESS: Build #${BUILD_NUMBER}",

                body: """
Good news 🚀

Bank Application deployed successfully!

Job Name: ${JOB_NAME}
Build Number: ${BUILD_NUMBER}
Build URL: ${BUILD_URL}

Application deployed on EKS cluster: ${EKS_CLUSTER}
""",

                to: "${EMAIL_ID}"

            )

        }


        failure {

            echo "Deployment Failed ❌ Attempting rollback..."

            sh """
            kubectl rollout undo deployment/${DEPLOYMENT_NAME} \
            -n ${NAMESPACE} || true
            """

            emailext(

                subject: "FAILED: Build #${BUILD_NUMBER}",

                body: """
Alert ❌

Bank Application deployment failed!

Job Name: ${JOB_NAME}
Build Number: ${BUILD_NUMBER}
Build URL: ${BUILD_URL}

Rollback attempted automatically.
""",

                to: "${EMAIL_ID}"

            )

        }


        always {

            cleanWs()

        }

    }

}
