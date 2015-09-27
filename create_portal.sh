#!/bin/sh

# Creates the portal that we will connect to to manage our machines. The portal
# is basically a publically visible VM that will be utilized as a tunnel of
# sorts to manage our fleet of most likely CentOS or CoreOS VMs.
# The `gateway-nic` has been created in advance and has a public IP connected
# to it which should allow us to ssh into the machine.
# Some of the other machines in our fleet (some workers) may not be publically
# visible intentionally, but we will still need access to them.
if test "$1" == "up"; then
  set -x
  azure vm create mesos-sandbox gateway westeurope linux \
    --ssh-publickey-pem-file ssh/yoda.pem \
    --admin-username yoda \
    --vm-size "Standard_A0" \
    --vnet-name "sandbox-vnet" \
    --vnet-subnet-name "initial-sandbox-subnet" \
    --nic-name "gateway-nic" \
    --image-urn "Canonical:UbuntuServer:15.10-DAILY:15.10.201509250"
  set +x
elif test "$1" == "down"; then
  azure vm delete mesos-sandbox gateway
else
  echo "Usage: $0 (up|down)"
fi
