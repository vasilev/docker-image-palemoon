# Palemoon browser in a Docker container

# Introduction

`Dockerfile` to create a [Docker](https://www.docker.com/) container image with [Palemoon](https://www.palemoon.org) for Linux.

The image uses [X11](http://www.x.org) unix domain socket on the host.

# Getting started

## Installation

Builds of the image are available on [Dockerhub](https://hub.docker.com/r/vasilev/palemoon) and is the recommended method of installation.

```bash
docker pull vasilev/palemoon:latest
```

Alternatively you can build the image yourself.

```bash
docker build -t vasilev/palemoon github.com/vasilev/docker-image-palemoon
```

With the image locally available, install the wrapper scripts using:

```bash
docker run -it --rm \
  --volume /usr/local/bin:/target \
  vasilev/palemoon:latest install
```

This will install a wrapper script to launch `palemoon`.

> **Note**
>
> If Palemoon is installed on the the host then the host binary is launched instead of starting a Docker container. To force the launch of Palemoon in a container use the `palemoon-wrapper` script. For example, `palemoon-wrapper palemoon` will launch Palemoon inside a Docker container regardless of whether it is installed on the host or not.

## How it works

The wrapper scripts volume mount the X11 socket in the launcher container. The X11 socket allows for the user interface display on the host.

When the image is launched the following directories are mounted as volumes

- `${HOME}/'.moonchildproductions'
- `XDG_DOWNLOAD_DIR` or if it is missing `${HOME}/Downloads`

This makes sure that your profile details are stored on the host and files received via Palemoon are available on your host in the appropriate download directory.


# Maintenance

## Upgrading

To upgrade to newer releases:

  1. Download the updated Docker image:

  ```bash
  docker pull vasilev/palemoon:latest
  ```

  2. Run `install` to make sure the host scripts are updated.

  ```bash
  docker run -it --rm \
    --volume /usr/local/bin:/target \
    vasilev/palemoon:latest install
  ```

## Uninstallation

```bash
docker run -it --rm \
  --volume /usr/local/bin:/target \
  vasilev/palemoon:latest uninstall
```

## Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version `1.3.0` or higher you can access a running containers shell by starting `bash` using `docker exec`:

```bash
docker exec -it palemoon-container-name bash
```

# Credits
* [mdouchement/docker-zoom-us](https://github.com/mdouchement/docker-zoom-us)
* [sameersbn/docker-skype](https://github.com/sameersbn/docker-skype)
