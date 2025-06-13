pipeline {
    
    agent any

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
                // gradlew 파일에 실행 권한 추가
                sh 'chmod +x gradlew'
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
                // docker 빌드 시 태그가 없으면 default로 'latest'가 사용됩니다.
                sh 'docker build -t demo-app:${BUILD_NUMBER} .'
                sh 'docker tag demo-app:${BUILD_NUMBER} parkcheonghun/demo-app:${BUILD_NUMBER}'
                // Jenkins Credentials에 저장된 Docker Hub 인증 정보 사용
                // 'docker-hub-credentials'는 위에서 설정한 Credentials ID
                // docker hub 개인 access token을 만들때 Read, Write 권한을 부여해야 합니다.
                withCredentials([usernamePassword(credentialsId: 'my-docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    // Docker Hub에 로그인
                    sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                    // Docker 이미지 푸시
                    sh 'docker push parkcheonghun/demo-app:${BUILD_NUMBER}'
                    // 로그인 정보가 불필요하게 남아있지 않도록 로그아웃 (선택 사항이지만 권장)
                    sh 'docker logout'
                }
                //sh 'docker push parkcheonghun/demo-app:latest'
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
        stage('Cleanup') {
            steps {
                echo 'Cleaning up...'
                sh 'docker rmi demo-app:${BUILD_NUMBER}' // 빌드된 Docker 이미지 제거
                // sh 'docker rmi ${IMAGE_NAME}:${IMAGE_TAG}' // Docker Hub에서 푸시한 이미지 제거
            }
        }        
    }

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