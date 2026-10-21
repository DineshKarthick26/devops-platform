
pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        timeout(time: 20, unit: 'MINUTES')
    }

    environment {
        DOCKER_IMAGE = 'dineshk26/devops-platform'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Python Syntax Validation') {
            steps {
                sh '''
                    docker run --rm \
                      -v "$WORKSPACE:/workspace" \
                      -w /workspace \
                      python:3.12-slim \
                      python -m compileall -q app.py tests
                '''
            }
        }

        stage('Code Quality - Ruff') {
    steps {
        sh '''
            docker run --rm \
              -v "$WORKSPACE:/workspace" \
              -w /workspace \
              python:3.12-slim \
              sh -c "pip install --no-cache-dir ruff && ruff check --target-version=py39 app.py tests"
        '''
    }
}
        stage('Automated Tests') {
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
                sh '''
                    docker build \
                      -t "$DOCKER_IMAGE:$BUILD_NUMBER" \
                      -t "$DOCKER_IMAGE:latest" .
                '''
            }
        }

        stage('Container Smoke Test') {
            steps {
                sh '''
                    set -eu

                    CONTAINER_NAME="devops-smoke-${BUILD_NUMBER}"

                    cleanup() {
                        docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
                    }

                    cleanup
                    trap cleanup EXIT

                    docker run -d \
                      --name "$CONTAINER_NAME" \
                      -p 127.0.0.1::5001 \
                      "$DOCKER_IMAGE:$BUILD_NUMBER"

                    HOST_PORT="$(docker port "$CONTAINER_NAME" 5001/tcp | sed 's/.*://')"

                    for attempt in $(seq 1 15); do
                        if curl --silent --fail \
                          "http://127.0.0.1:${HOST_PORT}/health"; then
                            echo
                            echo "Health endpoint passed."
                            exit 0
                        fi

                        sleep 2
                    done

                    echo "Container health check failed."
                    docker logs "$CONTAINER_NAME"
                    exit 1
                '''
            }
        }

        stage('Publish to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_TOKEN'
                    )
                ]) {
                    sh '''
                        set -eu
                        set +x

                        echo "$DOCKERHUB_TOKEN" | docker login \
                          --username "$DOCKERHUB_USER" \
                          --password-stdin

                        docker push "$DOCKER_IMAGE:$BUILD_NUMBER"
                        docker push "$DOCKER_IMAGE:latest"

                        docker logout
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'SUCCESS: validation, tests, image build, smoke test and publishing completed.'
        }

        failure {
            echo 'FAILED: inspect the first failed stage in Console Output.'
        }

        always {
            echo 'Pipeline execution finished.'
        }
    }
}
