# Bitwarden CLI docker

*Unofficial, no association with Bitwarden*

This repository contains a Dockerfile to run the Bitwarden CLI client, bw, and expose an API via the `bw serve` command.

## Build

Clone the repository and run `docker build --tag bitwarden-cli:latest .` from within the repository directory.

## Usage

### Docker

Run the image:

```
docker run --rm -e BW_CLIENTID=<client_id> -e BW_CLIENTSECRET=<client_secret> -p 127.0.0.1:8087:8087 bitwarden-api:latest
```

### Docker compose

Create a docker-compose.yaml file:

```
services:
  bitwarden-cli:
    container_name: bitwarden-cli
    image: bitwarden-cli:latest
    restart: unless-stopped
    ports:
      - 127.0.0.1:8087:8087
    environment:
      BW_CLIENTID: <client_id>
      BW_CLIENTSECRET: <client_secret>
```

Deploy the compose file by running `docker compose up -d`

### Environment variables

- BW_CLIENTID: client id corresponding to your API key (required).
- BW_CLIENTSECRET: client secret corresponding to your API key (required).
- BW_PORT: customize the port that the API is served on.
- BW_SERVER: custom server address to connect to (will connect to Bitwarden servers by default).
- BW_UID: custom uid the container will run as.
- BW_GID: custom gid the container will run as.

## Remarks

- Note that the exposed API is unauthenticated! It's best to only expose the container port to localhost.
- I personally use this container with Vaultwarden, which lags behind slightly in terms of Bitwarden version compatibility.
- API key authentication is the only authentication method.
