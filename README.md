## Ubuntu Repository using Docker

This Dockerfile build a Nginx HTTP server to provide as a software mirror for Ubuntu packages.

The mirror is sync daily from the upstream mirror, via apt-mirror(only sync the Ubuntu Dockerfile version)
or rsync(all Ubuntu version will be sync).

The Docker container could be monitoring via Monit on port 2812.

The Repository server has implement ratelimiting (10 requests per second per client).

Only machines from the local [RFC1918](https://tools.ietf.org/html/rfc1918) range may access the mirror.

### Base Docker Image

* [dockerfile/ubuntu](http://dockerfile.github.io/#/ubuntu)


### Installation

1. Install [Docker](https://www.docker.com/).

2. Creating the Docker Ubuntu Repo server:

    To build a Docker image for your Ubuntu Repository, you'll need to uses a Dockerfile.
    
    For example, There is a directory called build/, where you could select tow diffentes Ubuntu
    
    functions to create a mirro repository, using apt-mirror(recommend) or rsync:

    docker build -t MyUbuntuRepo .


### Usage with Attach persistent/shared directories

    docker run -d -p 80:80 -p 2812:2812 -v <sites-enabled-dir>/data:/data -v <sites-enabled-dir>/data:/var/log/nginx -v <sites-enabled-dir>/mirror:/mirror MyUbuntuRepo


The first time the server runs will take some time to sync your local repository.

After few seconds, open `http://<host>` to see the Ubuntu Repository, and to monitoring open `http://<host>:2812`

### To test connectivite base on RFC1918 and ratelimiting (10 requests per second per client).

   run scripts/check_ratelimiting.sh or from shell:
   
   for i in {0..20}; do (curl -Is http://localhost/ | head -n1 &) 2>/dev/null; done


### Configure clients

 To configure local Ubuntu clients, edit /etc/apt/source.list on client computers to point to the IP address or hostname of apt-mirror server, then update system.
