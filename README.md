# LENDESK API

A simple auth api implementation using rails and redis

## GETTING STARTED

Ensure you have the below versions of ruby, rails and redis installed

    Ruby: 2.6.3
    Rails: 6.1.1
    Redis: 6.0.10

Start the rails server with:

```
$ bin/rails server
```

Start a local instance of Redis by passing the following flags to prevent any snapshotting as this is not needed for this exercise

```
$ redis-server --save "" --appendonly no
```

This exposes the redis instance at the default port (6379)

## API OVERVIEW

The api contains three endpoints. Feel free to use curl or postman

1. Sign up

Takes in username and password params, validates params and returns a JWT on success

```bash
curl --location --request POST 'http://localhost:3000/api/v1/sign_up?username=dummyuser&password=Hello1234$' 
```

2. Home page

This endpoint can only be accessed on authentication. Provide the JWT obtained on sign up in the header of the request

```bash
curl --location --request GET 'http://localhost:3000/api/v1' \
--header 'Authorization: ${JWT}'
```

3. Sign in

Authenticates the user. Provide a valid username and password. Returns a new JWT

```bash
curl --location --request POST 'http://localhost:3000/api/v1/sign_in?username=dummyuser&password=Hello1234$'
```

## NOTES

- All JWT are set to expire in an hour
- Username and password have a complexity check implemented

## APPROACH

Since the api only serves JSON resources to an API client, I opted to use rails in the api only mode

I opted to use a token based authentication approach in this implementation using JWT. This prevents the need to store any sessions on the server-side and offloads token storage onto the client

A user obtains a JWT on signup by providing a valid username and password. The username and the encrypted password is stored in redis with the username as the hash key. This JWT is checked on every request from the client on the home page (root). Upon JWT expiration, the user is required to login again at the login endpoint

Every other future endpoint (apart from signup and signin) will perform a token validation

## SECURITY

- The passwords stored on redis are hashed using BCrypt and the encrypted password (along with the username) is used in creating the JWT.
- Controllers use strong params and filter out unwanted params


## THINGS TO IMPROVE

Things to improve with the api as next steps

- Setup docker and containerize this api for easy setup.
- Throttle requests to the endpoints to prevent any brute force attacks.
- Username and password fields have a simple pattern check at the moment. Could do more to sanitize user input to prevent any type of malicious injections.
- Reduce the JWT expiry to a shorter timespan (say 5 min) and maintain a refresh token list. Can go even further and implement refresh token rotation for added security.