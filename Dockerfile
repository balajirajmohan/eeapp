FROM lolhens/baseimage-openjre
ADD target/spring-petclinic-2.5.0-SNAPSHOT.jar spring-petclinic-2.5.0-SNAPSHOT.jar 
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "spring-petclinic-2.5.0-SNAPSHOT.jar"]
