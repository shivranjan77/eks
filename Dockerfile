FROM openjdk:17-jdk-slim
EXPOSE 8081
ADD target/eks-app.jar eks-app.jar
ENTRYPOINT ["java", "-jar", "/eks-app.jar"]
