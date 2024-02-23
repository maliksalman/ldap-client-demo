#!/bin/bash

docker run \
  --rm --name ldap \
  --hostname ldap.example.org \
  -p 389:389 -p 636:636 \
  -e LDAP_TLS_VERIFY_CLIENT=try \
  -e LDAP_DOMAIN=springframework.org \
  -v ./certs/ldap:/container/service/slapd/assets/certs \
  -v ./users.ldif:/container/service/slapd/assets/config/bootstrap/ldif/50-bootstrap.ldif \
  osixia/openldap:1.5.0 --copy-service
