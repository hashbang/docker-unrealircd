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

sed -i "s/_NUMERIC_/$TOKEN/" /opt/unrealircd/unrealircd.conf
sed -i "s/_HOSTNAME_/$HOSTNAME/" /opt/unrealircd/unrealircd.conf

/opt/unrealircd/src/ircd
tail -f /var/log/ircd.log
