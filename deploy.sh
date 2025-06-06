#!/bin/bash
echo "chmod +x deploy.sh"
chmod +x deploy.sh

echo "Git Pull"
git pull origin master

echo "Build with Gradle"
./gradlew clean bootJar

echo "Build Docker Image"
docker build -t img-demo-app .

echo "Docker Image Tag"
docker tag img-demo-app parkcheonghun/img-demo-app:latest

echo "Push Docker Image"
docker push parkcheonghun/img-demo-app:latest

echo "Docker login"
docker login

echo "Docker Image upload"
docker push parkcheonghun/img-demo-app:latest
 
#echo "Stop and Remove Old Container"
#docker stop cn-demo-app && docker rm cn-demo-app

#echo "Run New Container"
#docker run -d -p 8081:8081 --name cn-demo-app img-demo-app

echo "Deployment Complete: http://localhost:8081"