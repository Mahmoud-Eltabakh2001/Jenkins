@Library('libx')_

pipeline {
    agent {
        label 'java'
    }

    environment {
        JAVA_HOME = '/usr/lib/jvm/java-8-openjdk-amd64'
        PATH = "${JAVA_HOME}/bin:${env.PATH}"
    }

    parameters {
        string defaultValue: '${BUILD_NUMBER}', description: 'Enter the version of the docker image', name: 'VERSION'
        choice choices: ['true', 'false'], description: 'Skip test', name: 'TEST'
    }

    stages {
        stage("VM info") {
            steps {
                sh "hostname -I"
            }
        }

        stage("Build java app") {
            steps {
                script {
                    sayHello "ITI"
                }
                sh "mvn clean package install -Dmaven.test.skip=${params.TEST}"
            }
        }

        stage("Build & Login Docker Image") {
            steps {
                script {
                    def dockerx = new org.iti.docker()
                    dockerx.build("mahmoudeltabakh/mahmoud-reda", "${params.VERSION}")
                }

                withCredentials([
                    usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')
                ]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage("Push Docker Image") {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')
                ]) {
                    script {
                        def dockerx = new org.iti.docker()
                        dockerx.login(DOCKER_USER, DOCKER_PASS)
                        dockerx.push(DOCKER_USER, DOCKER_PASS)
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Clean the Workspace'
            cleanWs()
        }
        failure {
            echo 'Build failed'
        }
    }
}
