#!/bin/bash

# do some magic here to pull in opers.conf from an EBS volume or something
#if [ -z "$TOKEN" ]; then
#  echo "Missing \$TOKEN"
#  exit 1
#fi

#sed -i "s/TOKEN/$TOKEN/" /opt/unrealircd/.conf

/opt/unrealircd/src/ircd
tail -f /var/log/ircd.log
