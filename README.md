# ldap-client-demo

This is a spring-boot 3.2.2 app that uses `spring-ldap` abstractions to interact with an LDAP server as client. It demonstrates how to use/configure `LdapTemplate` to retrieve information from LDAP.

## Pre-requisites

You need to have the following installed on your system:

- Docker (installed and running)
- `openssl`
- `curl`

## Getting Started

There are scripts to start an LDAP server configured with TLS security. The LDAP server is configured with some example data which comes from the [`users.ldif`](./users.ldif) file. The LDAP server listens to both a TLS port (port `636`) and a non-TLS port (port `389`). It supports the *StartTLS* protocol on the non-TLS port - meaning the connection is established un-encrypted and then is upgraded to a TLS connection.

### Start the LDAP server

SSL Certificates need to be generated first that will be used by the LDAP server and the client application. Generate them by running:

```
certs/make-certs.sh
```

Start the LDAP server in docker by running:

```
./start-ldap-server.sh
```

### Covert the application into a docker image

The reason why we want to convert the app into a docker image is to:

- showcase the [benefits/ease](https://spring.io/guides/topicals/spring-boot-docker) of using [Cloud Native BuildPacks](https://buildpacks.io/) (CNB)
- be able to make changes inside the app container (CA certs might need to be installed) so we don't mess up our host computer

To compile our app and convert it into an OCI (aka Docker) image, run:

```
./build-app-image.sh
```

### Run the app image

We can run the app images with multiple spring profiles. Whichever profile we run the application with, after the application is started up, we can invoke it through the following script (it tries to look up a user with `uid=bob` from the LDAP server through our spring-boot application):

```
./query-app.sh
```

The above should produce an output like the following:

```
[{"uid":"bob","name":"Bob Hamilton","password":"[B@668eec6c"}]
```

The spring profiles that our app can be started with and their purpose is described below:

#### ... with `default` profile

```
./run-app-image.sh default
```
 
In this profile, the client communication happens un-encrypted on port `389`. Notice the log output shown in the LDAP server's docker container output.

#### ... with `ldaps` profile

```
./run-app-image.sh ldaps
```

In this profile, the client communication happens encrypted on port `636`. The CA cert used by the LDAP server is also added to the app container's JDK truststore. Normally, that would happen through the `keytool` command that comes bundled with JDK but in our case we rely on the [runtime 'service-bindings' mechanism](https://paketo.io/docs/howto/configuration/#bindings) provided to us by Cloud Native Buildpacks. Notice how the container is started in the [`run-app-image.sh`](./run-app-image.sh) script. Also, notice the log output shown in the LDAP server's docker container output.

#### ... with `tls` profile

```
./run-app-image.sh tls
```

In this profile, the client communication is initiated un-encrypted on port `389` but is upgraded to TLS through the *StartTLS* mechanism. The CA cert used by the LDAP server is loaded in the app container using spring-boot's SSL bundle mechanism. There is no need to add our CA to the JDK's truststore in this case. Notice the log output shown in the LDAP server's docker container output.

#### ... with `mutualtls` profile

```
./run-app-image.sh mutualtls
```

In this profile, the client communication is initiated un-encrypted on port `389` but is upgraded to mutual TLS through the *StartTLS* mechanism. The CA cert used by the LDAP server and a client key/cert are loaded in the app container using spring-boot's SSL bundle mechanism. There is no need to add our CA to the JDK's truststore in this case. Notice the log output shown in the LDAP server's docker container output.
