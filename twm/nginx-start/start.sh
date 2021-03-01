#!/bin/sh

echo "---> Creating keycloak.json ..."
envsubst < ~/src/keycloak.json.tmpl > ~/src/keycloak.json