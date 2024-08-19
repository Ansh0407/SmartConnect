# Use the official Maven image to build the app
FROM maven:3.8.4-openjdk-11 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml and download the dependencies (offline mode)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code and package the application
COPY src ./src
RUN mvn package -DskipTests

# Use the official OpenJDK image to run the app
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the packaged jar from the build stage
COPY --from=build /app/target/smartcontactmanager-0.0.1-SNAPSHOT.jar app.jar

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
