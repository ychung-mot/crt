#!/bin/sh

echo "---> Creating keycloak.json ..."
envsubst < ~/keycloak.json.tmpl > ~/keycloak.json