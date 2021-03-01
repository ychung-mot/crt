#!/bin/sh

echo "---> Creating keycloak.json ..."
envsubst < ~/src/keycloak.json.tmpl > ~/src/keycloak.json

echo "---> Creating nginx.conf ..."
envsubst < /tmp/src/nginx.conf.tmpl > /etc/nginx/nginx.conf