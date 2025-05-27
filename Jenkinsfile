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
        string(name: 'VERSION', defaultValue: '${BUILD_NUMBER}', description: 'Enter the version of the docker image')
        choice(name: 'TEST', choices: ['true', 'false'], description: 'Skip tests during build')
    }

    stages {

        stage("VM Info") {
            steps {
                echo '🖥️ Displaying VM IP...'
                sh "hostname -I"
            }
        }

        stage("Build Java App") {
            steps {
                echo '🔨 Building Java application...'
                script {
                    sayHello("ITI")
                }
                sh "mvn clean package install -Dmaven.test.skip=${params.TEST}"
            }
        }

        stage("Build Docker Image") {
            steps {
                echo '🐳 Building Docker image...'
                script {
                    def dockerx = new org.iti.docker()
                    dockerx.build("mahmoudeltabakh/mahmoud-reda", "${params.VERSION}")
                }
            }
        }

        stage("Login & Push Docker Image") {
            steps {
                echo '🔐 Logging into DockerHub and pushing image...'
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        def dockerx = new org.iti.docker()
                        dockerx.login(DOCKER_USER, DOCKER_PASS)
                        dockerx.push("mahmoudeltabakh/mahmoud-reda", "${params.VERSION}")
                    }
                }
            }
        }
    }

    post {
        always {
            echo '🧹 Cleaning workspace...'
            cleanWs()
        }
        failure {
            echo '❌ Build failed.'
        }
        success {
            echo '✅ Pipeline completed successfully!'
        }
    }
}

