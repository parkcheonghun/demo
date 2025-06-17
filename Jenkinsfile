pipeline {
    
    agent any

    environment {
        DOCKER_IMAGE_NAME = "parkcheonghun/demo-app" // Docker Hub에 푸시할 이미지 이름
        // 빌드 번호나 Git 커밋 SHA 등으로 태그를 동적으로 생성
        NEW_IMAGE_TAG = "${BUILD_NUMBER}" // 또는 sh 'git rev-parse --short HEAD' 등으로 Git SHA 사용
        GITOPS_REPO_URL = "https://github.com/parkcheonghun/demo.git"
        GITOPS_REPO_BRANCH = "master" // GitOps Repository의 브랜치
        GITOPS_DEPLOYMENT_PATH = "helm/templates/deployment.yaml" // GitOps Repo 내의 deployment.yaml 경로

        // Git 자격 증명 (GitOps Repository에 푸시하기 위함)
        GIT_CREDENTIALS_ID = 'github' // Jenkins에 등록된 Git 자격 증명 ID
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
                // docker 빌드 시 태그가 없으면 default로 'latest'가 태그 사용됩니다.
                sh 'docker build -t demo-app:${BUILD_NUMBER} .'
                // demo-app:번호 에 대한 parkcheonghun/demo-app:번호 태그를 추가합니다.
                sh 'docker tag demo-app:${BUILD_NUMBER} parkcheonghun/demo-app:${BUILD_NUMBER}'
                // Jenkins Credentials에 저장된 Docker Hub 인증 정보 사용
                // docker hub 개인 access token을 만들때 Read, Write 권한을 부여해야 합니다.
                withCredentials([usernamePassword(credentialsId: 'my-docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    // Docker Hub에 로그인
                    sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                    // Docker 이미지 푸시, docker tag에서 지정한 이름과 태그를 찾아 푸시합니다.
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
                sh 'docker rmi parkcheonghun/demo-app:${BUILD_NUMBER}' // 빌드된 Docker 이미지 제거
                // sh 'docker rmi ${IMAGE_NAME}:${IMAGE_TAG}' // Docker Hub에서 푸시한 이미지 제거
            }
        }
        stage('Update GitOps Repo and Trigger Argo CD') {
            steps {
                echo 'Updating GitOps repository with new image tag...'

                // GitOps Repository를 새로운 워크스페이스에 체크아웃
                dir('gitops-repo') { // 임시 디렉토리 생성
                    withCredentials([usernamePassword(credentialsId: GIT_CREDENTIALS_ID, usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                        sh "git clone https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/parkcheonghun/demo.git ."
                        sh "git config user.email 'jenkins@example.com'"
                        sh "git config user.name 'Jenkins CI/CD'"

                        // deployment.yaml 파일 업데이트 (예시: sed 사용)
                        // 이 부분은 YAML 구조와 업데이트 방식에 따라 달라질 수 있습니다.
                        // Helm/Kustomize를 사용한다면 해당 툴의 CLI를 사용하거나 values.yaml을 업데이트합니다.
                        sh "sed -i 's|image: ${DOCKER_IMAGE_NAME}:.*|image: ${DOCKER_IMAGE_NAME}:${NEW_IMAGE_TAG}|g' ${GITOPS_DEPLOYMENT_PATH}"

                        sh "git add ."
                        sh "git commit -m 'Update ${DOCKER_IMAGE_NAME} image to ${NEW_IMAGE_TAG} by Jenkins CI #${BUILD_NUMBER}'"
                        sh "git push origin ${GITOPS_REPO_BRANCH}"
                    }
                }
                echo "GitOps repository updated. Argo CD will now sync."
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