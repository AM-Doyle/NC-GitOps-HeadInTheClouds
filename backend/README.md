# Northcoders Learners API

This is the API for adding/editing/deleting learners from our system.

## Running the app

### Running with docker

You can run the application with docker by firstly building the image

```
docker build -t learners-api .
```

And then running the container:

```
docker run -p 8080:8080 learners-api
```

### Running locally

Alternatively, you can run locally if you have Java and Maven installed locally.

Instructions have been tested against Java version `openjdk 17.0.6` and Maven `3.8.4`

To run the application use the command

```
mvn spring-boot:run
```

## Testing the app

To run the tests for the API you can run:

```
mvn test
```

## App config

The application config is stored in [application.yml](./src/main/resources/application.yml) file.

We've shared a sample config for a Postgres database as well.

## Metrics and health

We've added Spring actuator and enabled prometheus so there is a [health endpoint](http://localhost:8080/actuator/health) and [prometheus metrics](http://localhost:8080/actuator/prometheus)

## Work in progress aspects

### API Docs

Coming soon....

We'll produce some [Swagger API docs](https://swagger.io/ when we get a chance

Note to self: Follow through Swagger and Spring [blog](https://www.baeldung.com/spring-rest-openapi-documentation)

### Notifications

We've not hooked up any notification service just yet such as sending an email when a new user signs-up. 

We wondered around using Amazon SES to send emails and something like SQS to put a message on a queue that an email should be sent.

Just need to chat to cloud engineering team
