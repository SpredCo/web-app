#!/usr/bin/env bash
if [ -z "$1" ]
then
    rerun "RACK_ENV='development' thin -R config.ru start"
else
    RACK_ENV="$1" thin -R config.ru start
fi