pipeline {
    agent { label 'build-server' }

    environment {
        // Load the secret file into an environment variable
        SECRET_FILE = credentials('my-secret-id')
    }

    stages {
        // Stage 1: Build Docker Image
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    docker.build('my-app-image', '.')  // Builds the image using Dockerfile
                }
            }
        }

        // Stage 2: Test Docker Image
        stage('Test Docker Image') {
            steps {
                script {
                    echo "Testing Docker image..."

                    // Run the container and execute tests inside
                    docker.image('my-app-image').inside('-w /app') {
                        // Copy the secret file into the container if required
                        sh 'cp $SECRET_FILE /app/config.json'

                        // Run tests (assuming `npm test` is defined in package.json)
                        sh 'npm test'
                    }
                }
            }
        }

        // Stage 3: Run Docker Image
        stage('Run Docker Image') {
            steps {
                script {
                    echo "Running Docker container..."

                    // Stop and remove any previous instance of the container
                    sh '''
                        docker stop my-app-container || true
                        docker rm -f my-app-container || true
                    '''

                    // Run a new container with the built image
                    sh 'docker run -d --name my-app-container -p 80:80 my-app-image:latest'

                    // Optional: Health check to confirm the container is up and running
                    echo "Performing health check on the container..."
                    sh 'until curl -s http://localhost:80; do sleep 5; done'
                }
            }
        }
    }
}
