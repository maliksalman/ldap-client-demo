#!/bin/bash


# this will depend on each system so we will start a container to run `nslookup host.docker.internal` and parse the results
DOCKER_HOST_IP_WITHIN_CONTAINER=$(docker run -it --rm maliksalman/jump:latest nslookup host.docker.internal | grep Name -A 1 | grep Address | cut -d ' ' -f 2)

# figure out which spring-profile to run with
PROFILE="${1:-ldaps}"

# run the container
if [[ $PROFILE == "ldaps" ]]; then

  docker run -it --rm \
    --add-host ldap.example.org:${DOCKER_HOST_IP_WITHIN_CONTAINER} \
    -e SPRING_PROFILES_ACTIVE=${PROFILE} \
    -e SERVICE_BINDING_ROOT=/bindings \
    -v $PWD/certs/ca-certificates:/bindings/ca-certificates \
    -p 8080:8080 \
    example/ldap-client-demo:1.0

elif [[ $PROFILE == "tls" || $PROFILE == "mutualtls" ]]; then

  docker run -it --rm \
    --add-host ldap.example.org:${DOCKER_HOST_IP_WITHIN_CONTAINER} \
    -e SPRING_PROFILES_ACTIVE=${PROFILE} \
    -v $PWD/certs/client:/workspace/certs \
    -p 8080:8080 \
    example/ldap-client-demo:1.0

else

  docker run -it --rm \
    --add-host ldap.example.org:${DOCKER_HOST_IP_WITHIN_CONTAINER} \
    -e SPRING_PROFILES_ACTIVE=${PROFILE} \
    -p 8080:8080 \
    example/ldap-client-demo:1.0

fi