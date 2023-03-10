#!/bin/bash

dnsv_path=/tmp/dns_validator

dnsvalidator -h >/dev/null
if [ $(echo $?) -eq 0 ];then
    echo
    echo "DNSValidator Exists"
    echo
else
    echo "Installing DNSValidator"
    git clone https://github.com/vortexau/dnsvalidator.git -q $dnsv_path
    pip3 install -r $dnsv_path/requirements.txt
    python3 $dnsv_path/setup.py install
    echo
fi

run=0
dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 100 -o /tmp/resolver$run.out --silent

while run < 50 ;do
    dnsvalidator -tL /tmp/resolver$run.out -threads 100 -o /tmp/resolvers$run.out --silent
    sleep 2
    run = run + 1
done

# sudo rm -r /tmp/dns_validator
