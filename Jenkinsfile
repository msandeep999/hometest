pipeline {
    agent { label 'build-server' }  // Single agent for all stages

    environment {
        // Load the secret file into an environment variable
        SECRET_FILE = credentials('my-secret-id')
    }

    stages {
        // Stage 1: Build
        stage('Build') {
            steps {
                script {
                    echo "Building the application inside Docker container..."

                    // Run the build inside a Docker container
                    docker.image('node:16').inside {
                        // Copy the secret file to the Docker container
                        sh 'cp $SECRET_FILE /app/config.json'

                        // Install dependencies and build the app
                        sh 'npm install'  // Install dependencies
                        sh 'npm run build'  // Build the app
                    }
                }
            }
        }

        // Stage 2: Test
        stage('Test') {
            steps {
                script {
                    echo "Running tests inside Docker container..."

                    // Run the tests inside a Docker container
                    docker.image('node:16').inside {
                        // Copy the secret file to the container (if needed during tests)
                        sh 'cp $SECRET_FILE /app/config.json'

                        // Run tests
                        sh 'npm test'  // Run tests
                    }
                }
            }
        }

        // Stage 3: Deploy (Build and Deploy Docker image to the same server)
        stage('Deploy') {
            steps {
                script {
                    echo "Deploying the application with Docker on the same server..."

                    // Step 1: Build the Docker image
                    echo "Building Docker image using the Dockerfile..."
                    docker.build('my-app-image', '.')  // Builds image using Dockerfile at the root of the project

                    // Step 2: Deploy the Docker container on the same server
                    echo "Deploying Docker container on the same server..."
                    sh '''
                        docker stop my-app-container || true  # Stop any running container
                        docker rm my-app-container || true    # Remove the stopped container
                        docker run -d --name my-app-container -p 80:80 my-app-image:latest  # Start the new container
                    '''
                }
            }
        }
    }
}
