# Northcoders Learners Frontend

This is the frontend for adding/editing/deleting learners from our system.

## Running the app

### Running with Docker

The application can be run with Docker by firstly building the images

```
docker build -t learners-frontend .
```

And then running the container

```
docker run -p 80:80 learners-frontend
```

Then you should be able to visit:

[http://localhost:80](http://localhost:80)

### Running locally

The instructions assume you have Node and NPM installed

Instructions have been tested against Node version `v18.12.1`

To run the application use the command

```
npm install
```

followed by:

```
npm start
```

## Running the tests

Yeah erm....we didn't create any just yet 🙈

## Injecting Env Variables

Currently the only accepted env variable is `VITE_API_BASE_URL`.

This should be the publicly available DNS of your Load Balancer;

`
env:

- name: VITE_API_BASE_URL
  value: "lb-123123.amazon.com"
  `

The protocol prefix `http://` will be added in the application and should not be supplied here for compatibility.
