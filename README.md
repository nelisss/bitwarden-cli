# Bitwarden CLI docker

*Unofficial, no association with Bitwarden*

This repository contains a Dockerfile to run the Bitwarden CLI client, bw, and expose an API via the `bw serve` command.

## Variants

Two distribution options are available: Debian or Alpine.

| Characteristic | Debian | Alpine |
| --- | --- | --- |
| Disk usage | ~500MB | ~200MB |
| Content size | ~150MB | ~50MB |

## Build

Clone the repository, choose a distribution to use and run `docker build -f Dockerfile.[alpine/debian] --tag bitwarden-cli .` from within the repository directory.

## Usage

### Docker

Run the image:

```
docker run --rm -e BW_CLIENTID=<client_id> -e BW_CLIENTSECRET=<client_secret> -p 127.0.0.1:8087:8087 bitwarden-api
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
- BW_MASTERPASSWORD: master password of your account. If not provided, you'll have to unlock the vault via the API, i.e. POST http://localhost:8087/unlock?password=<master\_password>.
- BW_PORT: customize the port that the API is served on.
- BW_SERVER: custom server address to connect to (will connect to Bitwarden servers by default).
- BW_UID: custom uid the container will run as.
- BW_GID: custom gid the container will run as.

## Remarks

- Information on how to create a personal API key for Bitwarden can be found [here](https://bitwarden.com/help/personal-api-key/).
- Note that the exposed API is unauthenticated! It's best to only expose the container port to localhost.
- I personally use this container with Vaultwarden, which lags behind slightly in terms of Bitwarden version compatibility. You can modify the Bitwarden CLI client version yourself during the build by supplying the `--build-arg BITWARDEN_VERSION="xxxx.xx.xx"` to the `docker build` command. The latest client releases can be found [here](https://github.com/bitwarden/clients/releases).
- API key authentication is the only implemented authentication method.
