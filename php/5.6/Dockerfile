FROM php:5.6

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Aref Tarkhani" \
  PHP="5.6" \
  NODE="12.9.0" \
  org.label-schema.name="Erfantasiert" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vcs-url="https://github.com/etarkhan/gitlab-ci-pipeline" \
  org.label-schema.vcs-ref=$VCS_REF

# Set correct environment variables
ENV IMAGE_USER=php
ENV HOME=/home/$IMAGE_USER
ENV COMPOSER_HOME=$HOME/.composer
ENV PATH=$HOME/.yarn/bin:$PATH
ENV GOSS_VERSION="0.3.6"
ENV PHP_VERSION=5.6

USER root

WORKDIR /tmp

# COPY INSTALL SCRIPTS
COPY --from=composer:1 /usr/bin/composer /usr/bin/composer
COPY ./php/scripts/*.sh /tmp/
RUN chmod +x /tmp/*.sh

# Install
RUN pecl install -o -f channel://pecl.php.net/redis-4.3.0 \
  &&  rm -rf /tmp/pear \
  &&  docker-php-ext-enable redis

RUN bash ./packages.sh \
  && bash ./extensions.sh \
  && bash ./node.sh \
  && adduser --disabled-password --gecos "" $IMAGE_USER && \
  echo "$IMAGE_USER  ALL = ( ALL ) NOPASSWD: ALL" >> /etc/sudoers && \
  echo "PATH=$PATH:/home/php/.yarn/bin" >> /root/.bashrc && \
  mkdir -p /var/www/html && \
  chown -R $IMAGE_USER:$IMAGE_USER /var/www $HOME \
  && composer global require "hirak/prestissimo:^0.3"  \
  && rm -rf ~/.composer/cache/* \
  && chown -R $IMAGE_USER:$IMAGE_USER $COMPOSER_HOME \
  && curl -fsSL https://goss.rocks/install | GOSS_VER=v${GOSS_VERSION} sh \
  && bash ./cleanup.sh

USER $IMAGE_USER

  WORKDIR /var/www/html
