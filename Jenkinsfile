pipeline {
    agent any

    environment {
        // Define variables for Docker registry and GitHub repository
        GIT_REPO = 'https://github.com/shivranjan77/eks.git'
        DOCKER_REGISTRY = 'shivranjan77'
        IMAGE_NAME = 'eks-app'
        DOCKER_CREDENTIALS = 'dockerhub-credentials-id'
        DOCKER_COMPOSE_FILE = 'docker-compose.yml'
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone the GitHub repository
                git branch: 'main', url: "${GIT_REPO}"
            }
        }

        stage('Build Application') {
            steps {
                // Assuming it's a Maven-based Java project
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                // Build the Docker image
                sh "docker build -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        stage('Docker Login') {
            steps {
                // Login to DockerHub or your Docker registry
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                }
            }
        }

        stage('Docker Push') {
            steps {
                // Push the Docker image to the Docker registry
                sh "docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }

        stage('Deploy with Docker Run') {
            steps {
                // Optionally deploy using `docker run` if Docker Compose is not available
                script {
                    if (!fileExists("${DOCKER_COMPOSE_FILE}")) {
                        // Stop and remove any existing container with the same name
                        sh """
                        docker stop ${IMAGE_NAME} || true
                        docker rm ${IMAGE_NAME} || true
                        docker run -d --name ${IMAGE_NAME} -p 8080:8080 ${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up workspace after build
            cleanWs()
        }
    }
}
