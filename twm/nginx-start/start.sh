#!/bin/sh

echo "---> Creating keycloak.json ..."
envsubst < ~/src/keycloak.json.tmpl > ~/src/keycloak.json

cho "---> Creating nginx.conf ..."
envsubst '${CRT_DEPLOY_SUFFIX}' < /tmp/src/nginx.conf.tmpl > /etc/nginx/nginx.conf