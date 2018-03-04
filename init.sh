#!/usr/bin/env bash

# Create .ENV config if not exist
# -------------------------------
if [ ! -f ".env" ]
then
    echo "$0: Create .env from example file..." && cp .env_example .env
fi

# Start
# -----
chmod +x ip.sh
./ip.sh && echo "PRE-BUILDING..."

docker-compose build apache2 mongo php-fpm workspace
docker-compose up -d apache2 mongo

docker-compose exec mongo sh /mongo.sh user password

# Execute workspace with install dependencies & run CLI
# -----------------------------------------------------
composer install
docker-compose exec workspace sh phpunit

# Execute specified containers
# ----------------------------
#docker-compose exec php-fpm bash docker-php-ext-enable xdebug
