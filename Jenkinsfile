pipeline {
    environment {
        SECRET_FILE = credentials('my-secret-id')
        ACR_CREDENTIALS = credentials('acr-credentials-id') // ACR credentials in Jenkins
        IMAGE_NAME = "testhome.azurecr.io/my-app-image:latest" //
    }

    stages {
        stage('Build Docker Image') {
            agent { label 'build-server' }
            steps {
                script {
                    echo "Building Docker image..."
                    def appImage = docker.build("my-app-image", ".")

                    echo "Logging in to ACR and pushing Docker image..."
                    docker.withRegistry("https://${env.IMAGE_NAME.split('/')[0]}", 'acr-credentials-id') {
                        appImage.push('latest')
                    }
                }
            }
        }

        stage('Test Docker Image') {
            agent { label 'test-server' }
            steps {
                    script {
                        echo "Logging in to ACR and pulling Docker image for testing..."
                        docker.withRegistry("https://${env.IMAGE_NAME.split('/')[0]}", 'acr-credentials-id') {
                            def appImage = docker.image(IMAGE_NAME)
                            appImage.pull()
                            appImage.inside('-w /app') {
                                sh 'cp $SECRET_FILE_PATH /app/config.json'
                                sh 'npm test'
                            }
                        }
                    }
            }
        }

        stage('Run Docker Image') {
            agent { label 'deploy-server' }
            steps {
                script {
                    echo "Logging in to ACR and pulling Docker image for deployment..."
                    docker.withRegistry("https://${env.IMAGE_NAME.split('/')[0]}", 'acr-credentials-id') {
                        def appImage = docker.image(IMAGE_NAME)
                        appImage.pull()
                    }

                    echo "Running Docker container..."
                    sh '''
                        docker stop my-app-container || true
                        docker rm -f my-app-container || true
                        docker run -d --name my-app-container -p 80:80 ${IMAGE_NAME}
                    '''

                    echo "Performing health check on the container..."
                    sh 'timeout 60 sh -c "until curl -s http://localhost:80; do sleep 5; done"'
                }
            }
        }
    }
}
