#!/bin/bash
echo "Doing my thing! E.g. install wp cli, install wordpress, etc..."

# execute apache

cd /var/www/html/ws
exec php yii server/start &
apache2-foreground

