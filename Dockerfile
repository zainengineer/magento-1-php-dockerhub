FROM php:5.6-apache
#FROM php:5.6.3-apache
#FROM php:5.5-apache
#RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list
#An example https://github.com/docker-library/php/issues/75#issuecomment-235773906
RUN apt-get update
RUN apt-get -y install mysql-client vim libmcrypt-dev libpng-dev libxml2-dev aria2 zlib1g-dev \
     libfreetype6-dev libjpeg62-turbo-dev git zip unzip pv libjpeg-dev

RUN docker-php-ext-install mcrypt soap pdo pdo_mysql mysql mysqli opcache  mbstring bcmath gd

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

RUN a2enmod rewrite ssl headers deflate expires mime

RUN echo "date.timezone = UTC" >> /usr/local/etc/php/php.ini

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf