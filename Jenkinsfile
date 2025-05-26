node('java') {
    def DOCKER_IMAGE = "mahmoudeltabakh/mahmoud-reda"
    def DOCKER_CREDENTIALS_ID = "dockerhub-credentials"

    stage("Docker Login") {
        withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
        }
    }

    stage("Build Docker Image") {
        sh "docker build -t ${DOCKER_IMAGE}:v${env.BUILD_NUMBER} ."
    }

    stage("Push Docker Image") {
        sh "docker push ${DOCKER_IMAGE}:v${env.BUILD_NUMBER}"
    }
}

