FROM maven:3-amazoncorretto-20 as base
WORKDIR /app
COPY pom.xml ./
RUN mvn dependency:resolve
COPY src ./src

FROM base as development
CMD ["mvn", "spring-boot:run", "-Dspring-boot.run.jvmArguments='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000'"]

FROM base as build
RUN mvn package


FROM eclipse-temurin:17-jre-jammy as production
EXPOSE 8080
COPY --from=build /app/target/learners-api-*.jar /learners-api.jar
CMD ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/learners-api.jar"]