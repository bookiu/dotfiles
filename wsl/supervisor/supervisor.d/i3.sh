#!/bin/sh

export DISPLAY="`sed -n 's/nameserver //p' /etc/resolv.conf`:0"

echo "sadfasdfasdfasdfa"

exec /usr/bin/i3
