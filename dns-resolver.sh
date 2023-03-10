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

run=1
file=/tmp/resolvers1.txt
wget https://public-dns.info/nameservers.txt -P /tmp &>/dev/null && mv /tmp/nameservers.txt $file && chmod 777 $file  

while [ $run -le 5 ];do
    in=$file
    ((run++))
    dnsvalidator -tL $in -threads 20 -o /tmp/resolvers$run.out --silent
    sleep 2
    echo
    echo "Scanning Next Batch"
done < $file
echo
echo "Done"