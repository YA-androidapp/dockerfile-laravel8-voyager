FROM php:8.0-fpm
LABEL maintainer="yaand"
COPY php.ini /usr/local/etc/php/

RUN apt-get update && apt-get install -y --no-install-recommends libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng-dev libzip-dev zlib1g-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd exif && \
    docker-php-ext-install zip

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    rm composer-setup.php && \
    mv composer.phar /usr/local/bin/composer

RUN apt-get update && \
    apt-get install -y curl gnupg && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y nodejs && \
    npm install npm@latest -g

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV COMPOSER_MEMORY_LIMIT=-1
ENV PATH $PATH:/composer/vendor/bin

WORKDIR /src

RUN composer create-project --prefer-dist laravel/laravel .

RUN touch database/mydb.sqlite

RUN sed -i -e 's#APP_URL=http://localhost#APP_URL=http://localhost:8000#' .env && \
    sed -i -e 's/DB_CONNECTION=mysql/DB_CONNECTION=sqlite\nDB_FOREIGN_KEYS=true/' .env && \
    sed -i -e 's#DB_DATABASE=laravel#DB_DATABASE=/src/database/mydb.sqlite#' .env && \
    sed -i -e 's/DB_HOST=127.0.0.1//' .env && \
    sed -i -e 's/DB_PORT=3306//' .env && \
    sed -i -e 's/DB_USERNAME=root//' .env && \
    sed -i -e 's/DB_PASSWORD=//' .env

RUN chmod 777 -R storage && \
    chmod 777 -R bootstrap/cache

RUN composer require laravel/ui && \
    php artisan ui vue --auth && \
    npm install && \
    npm install vue-loader

RUN npm run dev

RUN composer require tcg/voyager && \
    composer require --dev barryvdh/laravel-debugbar

RUN php artisan migrate
RUN npm install && npm run dev

RUN php artisan voyager:install --with-dummy
# admin@admin.com : password

EXPOSE 8000
CMD ["php","artisan","serve","--host","0.0.0.0"]
