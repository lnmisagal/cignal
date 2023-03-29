#FROM docker.io/bauson/ubi:php7.2
#FROM docker.io/bauson/ubi:php7.4

# Failing FPM
#FROM docker.io/bauson/ubi:php8.0
FROM docker.io/bauson/ubi:php8.1

# Switch to root to install and update packages
USER root
RUN sed -i 's/#DocumentRoot/DocumentRoot/g' /etc/httpd/conf/httpd.conf
RUN sed -i 's#/opt/app-root/src#/opt/app-root/src/public#g' /etc/httpd/conf/httpd.conf
RUN sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/subscription-manager.conf
RUN yum update -y && yum upgrade -y && yum reinstall tzdata -y && yum clean all
RUN sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 500M/g' /etc/php.ini
RUN sed -i 's/post_max_size = 8M/post_max_size = 500M/g' /etc/php.ini
RUN echo "date.timezone = Asia/Manila" >> /etc/php.d/extras.ini
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN rm -fR /tmp/sessions
RUN /usr/libexec/container-setup && rpm-file-permissions
ENV TZ=Asia/Manila
# Switch back to default user
USER default
# Create A TEST FILE
RUN mkdir -p public && echo "<?php phpinfo(); ?>" > public/index.php
# DOCROOT is /opt/app-root/src not /var/www/html

# COPY and install Laravel
#COPY . . 
#RUN composer update

#FOR PHP 7.2 and 7.4
#ENTRYPOINT ["httpd", "-D", "FOREGROUND"]

#FOR PHP 8.0 and 8.1
#ENTRYPOINT ["/bin/sh", "-c" , "php-fpm -D && httpd -D FOREGROUND"] 
#ENTRYPOINT ["/entrypoint.sh", "-c" , "php-fpm -D && httpd -D FOREGROUND"]
