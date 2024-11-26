#!/bin/bash
source .env

echo "Setting cluster domain name to: ${DOMAIN_APP}.${DOMAIN_SUBDOMAIN}"

mkdir -p ../backup

cp -R ./* ../backup

echo "Replacing dns references in named config"
sed -i 's/okd.home.lab/'$DOMAIN_APP.$DOMAIN_SUBDOMAIN'/' db.192.168.1
sed -i 's/home.lab/'$DOMAIN_SUBDOMAIN'/' db.192.168.1
sed -i 's/home.lab/'$DOMAIN_SUBDOMAIN'/' db.192.168.1
sed -i 's/okd.home.lab/'$DOMAIN_APP.$DOMAIN_SUBDOMAIN'/' db.home.lab
sed -i 's/home.lab/'$DOMAIN_SUBDOMAIN'/' db.home.lab
sed -i 's/home.lab/'$DOMAIN_SUBDOMAIN'/' db.192.168.1
mv db.home.lab db.$DOMAIN_SUBDOMAIN
sed -i 's/home.lab/'$DOMAIN_SUBDOMAIN'/' named.conf.local

echo "Replacing dns references in install_config.yaml"
sed -i 's/home.lab/'$DOMAIN_SUBDOMAIN'/' install-config.yaml
sed -i 's/name: okd/name: '$DOMAIN_APP'/' install-config.yaml

echo "Replacing subdomains"
sed -i -e "s/$SUBDOMAIN_OLD_BOOTSTRAP/$SUBDOMAIN_NEW_BOOTSTRAP/" ./*
sed -i -e "s/$SUBDOMAIN_OLD_SERVICES/$SUBDOMAIN_NEW_SERVICES/" ./*
sed -i -e "s/$SUBDOMAIN_OLD_CONTROLPLANE_1/$SUBDOMAIN_NEW_CONTROLPLANE_1/" ./*
sed -i -e "s/$SUBDOMAIN_OLD_CONTROLPLANE_2/$SUBDOMAIN_NEW_CONTROLPLANE_2/" ./*
sed -i -e "s/$SUBDOMAIN_OLD_CONTROLPLANE_3/$SUBDOMAIN_NEW_CONTROLPLANE_3/" ./*
sed -i -e "s/$SUBDOMAIN_NEW_COMPUTE_1/$VM_NEW_IP_COMPUTE_1/" ./*
sed -i -e "s/$VM_OLD_IP_COMPUTE_2/$SUBDOMAIN_NEW_COMPUTE_2/" ./*

echo "Replacing IP addresses"
sed -i -e "s/$VM_OLD_IP_BOOTSTRAP/$VM_NEW_IP_BOOTSTRAP/" ./*
sed -i -e "s/$VM_OLD_IP_SERVICES/$VM_NEW_IP_SERVICES/" ./*
sed -i -e "s/$VM_OLD_IP_CONTROLPLANE_1/$VM_NEW_IP_CONTROLPLANE_1/" ./*
sed -i -e "s/$VM_OLD_IP_CONTROLPLANE_2/$VM_NEW_IP_CONTROLPLANE_2/" ./*
sed -i -e "s/$VM_OLD_IP_CONTROLPLANE_3/$VM_NEW_IP_CONTROLPLANE_3/" ./*
sed -i -e "s/$VM_OLD_IP_COMPUTE_1/$VM_NEW_IP_COMPUTE_1/" ./*
sed -i -e "s/$VM_OLD_IP_COMPUTE_2/$VM_NEW_IP_COMPUTE_2/" ./*
