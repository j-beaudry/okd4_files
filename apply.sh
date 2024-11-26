#!/bin/bash
source .env

echo "Setting cluster domain name to: ${DOMAIN_APP}.${DOMAIN_SUBDOMAIN}"

mkdir -p $FOLDER_BACKUP

cp -R $FOLDER_CONFIG/* $FOLDER_BACKUP

echo "Replacing dns references in named config"
sed -i -e "s/okd.home.lab/${DOMAIN_APP}.${DOMAIN_SUBDOMAIN}/g" $FOLDER_CONFIG/*
sed -i -e "s/home.lab/$DOMAIN_SUBDOMAIN/g" $FOLDER_CONFIG/*
mv "${FOLDER_CONFIG}/db.home.lab" "${FOLDER_CONFIG}/db.${DOMAIN_SUBDOMAIN}"

echo "Replacing references in install-config.yaml"
FIELD="$DOMAIN_APP" ./yq -i '.metadata.name |= env(FIELD)' config/install-config.yaml
FIELD="$SSH_KEY" ./yq -i '.sshKey |= env(FIELD)' config/install-config.yaml

echo "Replacing subdomains"
sed -i -e "s/$SUBDOMAIN_OLD_BOOTSTRAP/$SUBDOMAIN_NEW_BOOTSTRAP/g" $FOLDER_CONFIG/*
sed -i -e "s/$SUBDOMAIN_OLD_SERVICES/$SUBDOMAIN_NEW_SERVICES/g" $FOLDER_CONFIG/*
sed -i -e "s/$SUBDOMAIN_OLD_CONTROLPLANE_1/$SUBDOMAIN_NEW_CONTROLPLANE_1/g" $FOLDER_CONFIG/*
sed -i -e "s/$SUBDOMAIN_OLD_CONTROLPLANE_2/$SUBDOMAIN_NEW_CONTROLPLANE_2/g" $FOLDER_CONFIG/*
sed -i -e "s/$SUBDOMAIN_OLD_CONTROLPLANE_3/$SUBDOMAIN_NEW_CONTROLPLANE_3/g" $FOLDER_CONFIG/*
sed -i -e "s/$SUBDOMAIN_NEW_COMPUTE_1/$SUBDOMAIN_NEW_COMPUTE_1/g" $FOLDER_CONFIG/*
sed -i -e "s/$SUBDOMAIN_OLD_COMPUTE_2/$SUBDOMAIN_NEW_COMPUTE_2/g" $FOLDER_CONFIG/*

echo "Replacing IP addresses"
sed -i -e "s/$VM_OLD_IP_BOOTSTRAP/$VM_NEW_IP_BOOTSTRAP/g" $FOLDER_CONFIG/*
sed -i -e "s/$VM_OLD_IP_SERVICES/$VM_NEW_IP_SERVICES/g" $FOLDER_CONFIG/*
sed -i -e "s/$VM_OLD_IP_CONTROLPLANE_1/$VM_NEW_IP_CONTROLPLANE_1/g" $FOLDER_CONFIG/*
sed -i -e "s/$VM_OLD_IP_CONTROLPLANE_2/$VM_NEW_IP_CONTROLPLANE_2/g" $FOLDER_CONFIG/*
sed -i -e "s/$VM_OLD_IP_CONTROLPLANE_3/$VM_NEW_IP_CONTROLPLANE_3/g" $FOLDER_CONFIG/*
sed -i -e "s/$VM_OLD_IP_COMPUTE_1/$VM_NEW_IP_COMPUTE_1/g" $FOLDER_CONFIG/*
sed -i -e "s/$VM_OLD_IP_COMPUTE_2/$VM_NEW_IP_COMPUTE_2/g" $FOLDER_CONFIG/*

if [ "$CREATE_REGISTRY_FOLDER" = true ]; then
    echo "Creating registry folder"
    mkdir -p /var/nfsshare/registry
fi
