FROM php:8.1

WORKDIR /home

COPY app .

CMD php -S 0.0.0.0:8000
