pipeline {
    agent {
        label 'java'
    }

    environment {
        DOCKER_IMAGE = "mahmoudeltabakh/mahmoud-reda"
        DOCKER_CREDENTIALS_ID = "dockerhub-credentials"
    }

    stages {
        stage("Docker Login") {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                }
            }
        }

        stage("Build Docker Image") {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:v${BUILD_NUMBER} .'
            }
        }

        stage("Push Docker Image") {
            steps {
                sh 'docker push $DOCKER_IMAGE:v${BUILD_NUMBER}'
            }
        }
    }
}
