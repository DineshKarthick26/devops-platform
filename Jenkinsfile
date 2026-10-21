pipeline {
    agent any

    options {
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test Application') {
            steps {
                sh '''
                    docker run --rm \
                      -v "$WORKSPACE:/workspace" \
                      -w /workspace \
                      python:3.12-slim \
                      sh -c "pip install --no-cache-dir -r requirements-dev.txt && python -m pytest -v"
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devops-platform:${BUILD_NUMBER} .'
            }
        }
    }

    post {
        success {
            echo 'CI pipeline succeeded: tests passed and Docker image built.'
        }
        failure {
            echo 'CI pipeline failed. Check the stage logs for details.'
        }
    }
}
