pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('my-docker-hub') // Jenkins Credentials ID
        IMAGE_NAME = 'parkcheonghun/demo' // Docker Hub 사용자 이름과 프로젝트 이름
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out your project...'
                git branch: 'master', url: 'https://github.com/parkcheonghun/demo.git' // 여기에 실제 Git 저장소 URL을 입력하세요
                //git 'https://github.com/your-repo/your-project.git' // 여기에 실제 Git 저장소 URL을 입력하세요
            }
        }
        stage('Build') {
            steps {
                echo 'Building with Gradle...'
                sh './gradlew clean build' // Gradle을 사용하여 빌드
            }
        }
        stage('Test') {
            steps {
                echo 'Testing with Gradle...'
                sh './gradlew test' // 단위 테스트 실행
                // sh './gradlew check' // 전체 테스트 실행
            }
        }
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t demo-app:latest .'
                sh 'docker tag demo-app parkcheonghun/demo-app:latest'
                sh 'docker push parkcheonghun/demo-app:latest'
                // sh 'kubectl apply -f helm/deployment.yaml'
                //script {
                //    def app = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                //    app.withRegistry('https://registry.hub.docker.com', DOCKER_HUB_CREDENTIALS) {
                //        app.push()
                //    }
                //}
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
                // 여기에 배포 명령어를 추가하세요 (예: kubectl apply -f deployment.yaml)
                // 예: Kubernetes 배포
                // sh "kubectl apply -f kubernetes/deployment.yaml"
                // sh "kubectl set image deployment/your-app your-container=${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
        /*
        stage('Cleanup') {
            steps {
                echo 'Cleaning up...'
                sh 'docker rmi my-app:latest' // 빌드된 Docker 이미지 제거
                // sh 'docker rmi ${IMAGE_NAME}:${IMAGE_TAG}' // Docker Hub에서 푸시한 이미지 제거
            }
        }
        */
        post {
            always {
                echo 'Cleaning up workspace...'
                cleanWs() // Jenkins 작업 공간 정리
            }
            success {
                echo 'Build and deployment succeeded!'
            }
            failure {
                echo 'Build or deployment failed!'
            }
        }
    }
}