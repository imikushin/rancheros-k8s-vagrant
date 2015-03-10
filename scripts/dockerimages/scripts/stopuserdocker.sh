#!/bin/sh
set -x

/usr/bin/system-docker stop userdocker
/usr/bin/system-docker rm userdocker

## do not fail if there is no userdocker container anymore
exit 0
