#!/bin/bash

function install_dnsv() {
    echo "Installing DNSValidator"
    dnsv_path=/tmp/dns_validator
    git clone https://github.com/vortexau/dnsvalidator.git -q $dnsv_path
    pip3 install -r $dnsv_path/requirements.txt
    python3 $dnsv_path/setup.py install
    rm -r /tmp/dns_validator
    echo
}

hash dnsvalidator 2>/dev/null && printf "[!] DNSValidator is already installed.\n" || { printf "[+] Installing DNSValidator!" && install_dnsv; }

file=/tmp/resolve
wget https://public-dns.info/nameservers.txt -P /tmp &>/dev/null && mv /tmp/nameservers.txt $file

for i in $(seq 1 6);
do  
    resolvers=/tmp/resolvers
    touch $resolvers
    for r in $(seq 1 1);
    do
        dnsvalidator -tL $file -threads 100 -o $resolvers --silent
        cat $resolvers > $file
    done
done