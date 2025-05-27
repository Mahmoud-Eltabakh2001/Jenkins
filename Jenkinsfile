@Library('libx')_

pipeline {
    agent {
        label 'java'
    }

    tools {
        jdk "java-8"
    }

    parameters {
        string defaultValue: '${BUILD_NUMBER}', description: 'Enter the version of the docker image', name: 'VERSION'
        choice choices: ['true', 'false'], description: 'Skip test', name: 'TEST'
    }

    stages {
        stage("VM info") {
            steps {
                script {
                    sh "hostname -I"  // أو استخدم "ip a" لو عايز معلومات أكثر
                }
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

        stage("build java app image") {
            steps {
                script {
                    def dockerx = new org.iti.docker()
                    dockerx.build("java", "${params.VERSION}")
                }

                withCredentials([
                    usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')
                ]) {
                    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                }
            }
        }

        stage("push java app image") {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')
                ]) {
                    script {
                        def dockerx = new org.iti.docker()
                        dockerx.login("${DOCKER_USER}", "${DOCKER_PASS}")
                        dockerx.push("${DOCKER_USER}", "${DOCKER_PASS}")
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
