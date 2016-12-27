#!/usr/bin/env bash
if [ "$RACK_ENV" = "production" ]
then
    thin -R config.ru -p $WEB_PORT start --ssl --ssl-key-file $WEB_SSL_KEY --ssl-cert-file $WEB_SSL_CERT
else
    thin -R config.ru -p 3000 start --ssl --ssl-key-file ./.ssl/spred.key --ssl-cert-file ./.ssl/spred.crt
fi
