#
# Ubuntu Repo Dockerfile
#

# Pull base image.
FROM ubuntu
MAINTAINER Rafael Konrath <rafael.konrath@gmail.com>


# Set the localtime zone
ENV TZ Europe/London

# Install nginx, apt-mirror and
# Configuring nginx to limit connections and allow access from RFC1918 range
#
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y install nginx apt-mirror cron monit && \
  sed -i '/displaying a 404/a\\t\t allow 127.0.0.1;\n\t\tallow 10.0.0.0/8;\n\t\tallow 172.16.0.0/12;\n\t\tallow 192.168.0.0/16;\n\t\tdeny all;' /etc/nginx/sites-enabled/default && \
  sed -i '/sendfile on/a\\t limit_req_zone $binary_remote_addr zone=repo_root:10m rate=1r/s;' /etc/nginx/nginx.conf && \
  sed -i '/deny all/a\\t\t autoindex on;' /etc/nginx/sites-enabled/default && \
  sed -i '/deny all/a\\t\t limit_req zone=repo_root burst=10;' /etc/nginx/sites-enabled/default && \
  sed -i 's/\/var\/www\/html/\/mirror\/mirror\/archive\.ubuntu\.com/g' /etc/nginx/sites-enabled/default && \
  sed -i '/base_path/a set base_path  /mirror' /etc/apt/mirror.list && \
  chown -R www-data:www-data /var/lib/nginx && \
  echo "0 0 * * * root /usr/bin/apt-mirror >> /data/logs/apt-mirror.log" >> /etc/crontab

# Define working directory.
WORKDIR /etc/nginx

# Define mountable directories.
VOLUME ["/var/log/nginx", "/var/www/html", "/data", "/mirror"]


# Copy a configuration file from the current directory
COPY scripts/start.sh /usr/sbin/start.sh
COPY conf/monitrc /etc/monit/monitrc
COPY conf/nginx /etc/monit/conf.d/nginx
RUN chown root:root /etc/monit/monitrc && \
    chmod 700 /etc/monit/monitrc && \
    chown root:root /usr/sbin/start.sh && \
    chmod 755 /usr/sbin/start.sh


# Expose ports.
EXPOSE 80

# Monit
EXPOSE 2812

# Define default commands.
CMD ["/usr/sbin/start.sh"]
