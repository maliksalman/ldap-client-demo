#!/bin/bash -x

####################################################################################################################
# https://mariadb.com/docs/server/security/data-in-transit-encryption/create-self-signed-certificates-keys-openssl/
####################################################################################################################

export SUBJECT="/C=US/ST=MI/L=Canton/O=WidgetSecurityInc/OU=SecurityDept"
export DOMAIN=example.org
export SERVER=ldap
export CLIENT=client

make_key_and_cert() {

  NAME=$1
  SERIAL=$2

  openssl req -newkey rsa:2048 -nodes -days 365000 \
    -keyout ${NAME}.key \
    -out ${NAME}.req \
    -subj "${SUBJECT}/CN=${NAME}.${DOMAIN}"

  openssl x509 -req -days 365000 -set_serial ${SERIAL} \
    -in ${NAME}.req \
    -out ${NAME}.crt \
    -CA ca.crt \
    -CAkey ca.key

  rm ${NAME}.req
  mkdir $NAME
  mv ${NAME}.* $NAME/
  cp ca.crt $NAME/
}

# cleanup first
rm *.crt
rm *.key
rm -rf ca-certificates $SERVER $CLIENT

# generate CA key
openssl genrsa 2048 > ca.key

# generate CA cert
openssl req -new -x509 -nodes -days 365000 \
   -key ca.key \
   -out ca.crt \
   -subj "${SUBJECT}/CN=${DOMAIN}"

# generate server key/cert
make_key_and_cert ${SERVER} 01

# generate client key/cert
make_key_and_cert ${CLIENT} 02

# generate the ca-certificates bindings structure
mkdir -p ca-certificates
echo "ca-certificates" > ca-certificates/type
cp ca.crt ca-certificates/