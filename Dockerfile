FROM ubuntu:14.04
MAINTAINER dev@alex-web.ru

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
 && apt-get install -f -y libmysqlclient-dev \
  apache2 \
  php5 \
  php5-mysql \
  libapache2-mod-php5 \
  libapache2-mod-rpaf \
  php5-mcrypt \
  php5-gd \
  php5-curl \
  php5-xsl \
  php5-pgsql \
  php5-sqlite \
  php5-memcache \
  php5-redis \
 && mkdir -p /var/lock/apache2 /var/run/apache2 /srv/apache2 \
 && ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/apache2/conf.d/ \
 && ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/cli/conf.d/ \
 && php5enmod mcrypt \
 && a2enmod rewrite \
 && apt-get install -y apache2-mpm-itk

RUN ln -sf /dev/stderr /var/log/apache2/php.log
RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log
RUN rm -f /etc/apache2/conf-enabled/other-vhosts-access-log.conf

COPY rpaf.conf /etc/apache2/mods-enabled/
COPY apache2.conf /etc/apache2/
COPY ports.conf /etc/apache2/
COPY entrypoint.sh /usr/local/bin/
COPY php.ini /etc/php5/apache2/

VOLUME "/srv/apache2"

EXPOSE 80

CMD ["entrypoint.sh"]
