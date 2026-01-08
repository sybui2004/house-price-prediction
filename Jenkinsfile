pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5', daysToKeepStr: '5'))
        timestamps()
    }

    environment {
        REGISTRY = 'bitis2004/house-price-prediction-api'
        REGISTRY_CREDENTIAL = 'dockerhub'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Build Image') {
            steps {
                echo 'Building Docker image...'
                sh '''
                  docker build -t $REGISTRY:$IMAGE_TAG .
                  docker tag $REGISTRY:$IMAGE_TAG $REGISTRY:latest
                '''
            }
        }

        stage('Test Image') {
            steps {
                echo 'Testing container...'
                sh '''
                  docker run -d --name hp_test $REGISTRY:$IMAGE_TAG

                  sleep 5

                  docker exec hp_test curl -f -X POST http://localhost:30000/predict \
                    -H "Content-Type: application/json" \
                    -d '{
                    "MSSubClass": 60,
                    "MSZoning": "RL",
                    "LotArea": 7844,
                    "LotConfig": "Inside",
                    "BldgType": "1Fam",
                    "OverallCond": 7,
                    "YearBuilt": 1978,
                    "YearRemodAdd": 1978,
                    "Exterior1st": "HdBoard",
                    "BsmtFinSF2": 0.0,
                    "TotalBsmtSF": 672.0
                    }'

                  docker rm -f hp_test
                '''
            }
        }

        stage('Push Image') {
            steps {
                echo 'Pushing image to Docker Hub...'
                withCredentials([usernamePassword(
                    credentialsId: REGISTRY_CREDENTIAL,
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                      echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                      docker push $REGISTRY:$IMAGE_TAG
                      docker push $REGISTRY:latest
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying models...'
                echo 'Trigger deploy script here'
            }
        }
    }

    post {
        always {
            sh 'docker system prune -f'
        }
    }
}
