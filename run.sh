#!/bin/bash

# do some magic here to pull in opers.conf from an EBS volume or something
if [ -z "$NUMERIC" ]; then
  echo "Missing \$NUMERIC"
  exit 1
fi
if [ -z "$HOSTNAME" ]; then
  echo "Missing \$HOSTNAME"
  exit 1
fi
if [ -z "$LINK1_NAME" ]; then
  echo "Missing \$LINK1_HOST"
  exit 1
fi
if [ -z "$LINK1_HOST" ]; then
  echo "Missing \$LINK1_HOST"
  exit 1
fi
if [ -z "$SERVICES_HOST" ]; then
  echo "Missing \$SERVICES_HOST"
  exit 1
fi
if [ -z "$LINK1_PASSWORD_RECEIVE" ]; then
  echo "Missing \$LINK1_PASSWORD_RECEIVE"
  exit 1
fi
if [ -z "$LINK1_PASSWORD_CONNECT" ]; then
  echo "Missing \$LINK1_PASSWORD_CONNECT"
  exit 1
fi
if [ -z "$SERVICES_PASSWORD_RECEIVE" ]; then
  echo "Missing \$SERVICES_PASSWORD_RECEIVE"
  exit 1
fi
if [ -z "$SERVICES_PASSWORD_CONNECT" ]; then
  echo "Missing \$SERVICES_PASSWORD_CONNECT"
  exit 1
fi

sed -i "s/_NUMERIC_/$NUMERIC/" /opt/unrealircd/unrealircd.conf
sed -i "s/_HOSTNAME_/$HOSTNAME/" /opt/unrealircd/unrealircd.conf
sed -i "s/_LINK1_NAME_/$LINK1_NAME/" /opt/unrealircd/unrealircd.conf
sed -i "s/_LINK1_HOST_/$LINK1_HOST/" /opt/unrealircd/unrealircd.conf
sed -i "s/_LINK1_PASSWORD_CONNECT_/$LINK1_PASSWORD_CONNECT/" /opt/unrealircd/unrealircd.conf
sed -i "s/_LINK1_PASSWORD_RECEIVE_/$LINK1_PASSWORD_RECEIVE/" /opt/unrealircd/unrealircd.conf
sed -i "s/_SERVICES_HOST_/$SERVICES_HOST/" /opt/unrealircd/unrealircd.conf
sed -i "s/_SERVICES_PASSWORD_CONNECT_/$SERVICES_PASSWORD_CONNECT/" /opt/unrealircd/unrealircd.conf
sed -i "s/_SERVICES_PASSWORD_RECEIVE_/$SERVICES_PASSWORD_RECEIVE/" /opt/unrealircd/unrealircd.conf

/opt/unrealircd/src/ircd
tail -f /var/log/ircd.log
