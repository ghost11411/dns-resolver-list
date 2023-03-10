#!/bin/bash

dnsv_path=/tmp/dns_validator

#CHECK ROOT
echo -e "Checking Root Permissions"
if [ "$EUID" -ne 0 ];then 
    echo -e "Please run as root (use sudo ./dns-resolver.sh)"
exit
else
    echo -e "**Root Permission Granted**"
fi
echo

dnsvalidator -h >/dev/null
if [ $(echo $?) -eq 0 ];then
    echo "DNSValidator Exists"
    echo
else
    echo "Installing DNSValidator"
    git clone https://github.com/vortexau/dnsvalidator.git -q $dnsv_path
    pip3 install -r $dnsv_path/requirements.txt
    python3 $dnsv_path/setup.py install
    echo
fi

dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 100 -o /tmp/all.out --silent
run=0

while run < 50 ;do
    dnsvalidator -tL /tmp/all.out -threads 100 -o /tmp/resolvers$run.out --silent
    sleep 2
done

# sudo rm -r /tmp/dns_validator
