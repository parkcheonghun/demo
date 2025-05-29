#!/bin/bash
echo "chmod +x deploy.sh"
chmod +x deploy.sh

echo "Git Pull"
git pull origin master

echo "Build with Gradle"
./gradlew clean bootJar

echo "Build Docker Image"
docker build -t img-demo-app .

echo "Stop and Remove Old Container"
docker stop cn-demo-app && docker rm cn-demo-app

echo "Run New Container"
docker run -d -p 8081:8081 --name cn-demo-app img-demo-app

echo "Deployment Complete: http://localhost:8081"