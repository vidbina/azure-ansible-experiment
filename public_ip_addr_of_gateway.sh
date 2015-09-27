#!/bin/sh
azure vm show mesos-sandbox gateway | grep "Public" | \
  awk \
  'match($0, /[0-9]{1,3}(\.[0-9]{1,3}){3}/) {
    print substr( $0, RSTART, RLENGTH )
  }'
