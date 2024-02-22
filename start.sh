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


# ldapsearch -v -x -Z -H ldaps://ldap.example.org:636 -b dc=springframework,dc=org -D "cn=admin,dc=springframework,dc=org" -w admin

# ldapsearch -v -x -H ldap://ldap.example.org:389 -b dc=springframework,dc=org -D "cn=admin,dc=springframework,dc=org" -w admin

# apt update; apt install -y ldap-utils vi ca-certificates dnsutils iproute2

# nslookup host.docker.internal


# keytool -importcert -trustcacerts -noprompt -cacerts -file app/certs/ca.crt -alias ldap

# SPRING_PROFILES_ACTIVE=ldaps java -jar app/client/build/libs/client-0.0.1-SNAPSHOT.jar

# SPRING_PROFILES_ACTIVE=mutualtls java -jar app/client/build/libs/client-0.0.1-SNAPSHOT.jar

# SPRING_PROFILES_ACTIVE=tls java -jar app/client/build/libs/client-0.0.1-SNAPSHOT.jar

# docker run -it --rm \
#     --add-host ldap.example.org:192.168.65.254 \
#     -v $PWD/client:/root/app/client \
#     -v $PWD/ldap/certs/new:/root/app/certs \
#     -p 8181:8181 \
#     eclipse-temurin:21-jre-jammy bash