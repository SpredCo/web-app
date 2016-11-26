#!/usr/bin/env bash
if [ -z "$1" ]
then
    RACK_ENV='development' thin -R config.ru start --ssl --ssl-key-file ./.ssl/spred.key --ssl-cert-file ./.ssl/spred.crt
else
    RACK_ENV="$1" thin -R config.ru start
fi
