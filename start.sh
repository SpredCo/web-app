#!/usr/bin/env bash
if [ -z "$1" ]
then
    RACK_ENV='development' thin -R config.ru -p $WEB_PORT start --ssl --ssl-key-file $WEB_SSL_KEY --ssl-cert-file $WEB_SSL_CERT
else
    RACK_ENV="$1" thin -R config.ru start --ssl --ssl-key-file ./.ssl/spred.key --ssl-cert-file ./.ssl/spred.crt
fi
