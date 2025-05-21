#!/bin/bash

LOGFILE="/var/log/cloud-init-output_json.log"

# Kasm DB variables
DB_IP="${DB_PRIVATE_IP}"
REDIS_PASS="${KASM_REDIS_PASS}"
DB_PASS="${KASM_DB_PASS}"
ZONE_NAME="${KASM_ZONE_NAME}"

# Swap size in GB, adjust appropriately depending on the size of your Agent VMs
SWAP_SIZE_GB='8'
KASM_BUILD_URL="${KASM_DOWNLOAD_URL}"
ADDITIONAL_INSTALL_ARGS="${ADDITIONAL_WEBAPP_INSTALL_ARGS}"

# Install monitoring
INSTALL_GRAFANA="${INSTALL_GRAFANA}"
DEPLOYMENT_DOMAIN="${DEPLOYMENT_DOMAIN}"
GRAFANA_USER="${GRAFANA_USER}"
GRAFANA_PASSWORD="${GRAFANA_PASSWORD}"

## Kasm custom AMI SSH Banner variables
ROLE="app"
DEPLOYMENT_DATE="$(date +"Date: %Y-%m-%d / Time: %T")"
IMAGE="${IMAGE_TYPE}"
DEPLOYMENT_TYPE="${DEPLOYMENT_TYPE}"
CUSTOMER="${PROJECT_NAME}"
KASM_VERSION="${KASM_VERSION}"

## Teleport join info
TELEPORT_JOIN_TOKEN="${TELEPORT_TOKEN}"
TELEPORT_DOMAIN="${TELEPORT_DOMAIN_NAME}"
TELEPORT_CA_PIN="${TELEPORT_CA}"
TELEPORT_NODE_NAME="${NODE_NAME}-$(hostname | cut -d'-' -f1-5)"
TELEPORT_VERSION="${TELEPORT_VERSION}"
PRIVATE_IP=$(hostname -I | cut -d' ' -f1)

## Wazuh join info
WAZUH_JOIN_TOKEN="${WAZUH_TOKEN}"
WAZUH_SERVICE_URL="${WAZUH_URL}"
WAZUH_JOIN_GROUP="${WAZUH_GROUP}"
WAZUH_CONFIG_FILE="/var/ossec/etc/ossec.conf"
WAZUH_PASSWORD_FILE="/var/ossec/etc/authd.pass"

## Firstboot script vars
FIRSTBOOT_PATH="/usr/local/bin/firstboot"
END_OF_FILE=""
ALLOY_INSERT_LINE=""

## Provision Teleport so firstboot script finializes setup
if [ -n "$${TELEPORT_JOIN_TOKEN}" ]
then
  echo "Beginning Teleport install..."
  wget https://kasm-static-content.s3.amazonaws.com/teleport/teleport_install.sh
  bash teleport_install.sh "$${CUSTOMER}" "$${TELEPORT_JOIN_TOKEN}" "$${TELEPORT_VERSION}" "$${TELEPORT_CA_PIN}" "$${PRIVATE_IP}"
  rm -rf teleport_install.sh
  echo " ... Teleport install finished successfully"
fi

if [ -n "$${WAZUH_JOIN_TOKEN}" ]
then
  echo "Beginning Wazuh install..."
  ## Set Wazuh agent password
  echo "$${WAZUH_JOIN_TOKEN}" > "$${WAZUH_PASSWORD_FILE}"
  chmod 640 "$${WAZUH_PASSWORD_FILE}"
  chown root:wazuh "$${WAZUH_PASSWORD_FILE}"

  ## Configure Wazuh join info
  sed -i "s/{{WAZUH_URL}}/$${WAZUH_SERVICE_URL}/" "$${WAZUH_CONFIG_FILE}"
  sed -i "s/{{NODE_NAME}}/$${TELEPORT_NODE_NAME}/" "$${WAZUH_CONFIG_FILE}"
  sed -i "s/{{WAZUH_GROUP}}/$${WAZUH_JOIN_GROUP}/" "$${WAZUH_CONFIG_FILE}"
  echo " ... Wazuh install finished successfully"
fi

function update_ubuntu () {
  echo "Updating Ubuntu..."
  sleep 30

  while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 ; do
    echo "Waiting for other apt-get instances to exit"
    sleep 2
  done

  apt-get -o DPkg::Lock::Timeout=-1 update
  export DEBIAN_FRONTEND=noninteractive ; apt-get upgrade -y -o DPkg::Lock::Timeout=-1 -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
}

function install_ubuntu () {
  apt-get -o DPkg::Lock::Timeout=-1 install \
      iputils-ping \
      dnsutils \
      netcat \
      htop -y
}

function update_rhel () {
  dnf update -y
}

function install_rhel () {
  dnf install -y --skip-broken \
      iputils-ping \
      dnsutils \
      netcat \
      htop
}

case "$${IMAGE}" in
  kasm_ubuntu)
    DOWNLOAD_FOLDER="/home/ubuntu"
    echo "$${ROLE}" >/opt/kasm/.kasm_deployment/kasm_role
    echo "$${CUSTOMER}" >/opt/kasm/.kasm_deployment/customer
    echo "$${DEPLOYMENT_DATE}" >/opt/kasm/.kasm_deployment/deployment_date
    echo "$${DEPLOYMENT_TYPE}" >/opt/kasm/.kasm_deployment/deployment_type
    echo "$${KASM_VERSION}" >/opt/kasm/.kasm_deployment/kasm_version
    update_ubuntu
    aa-enforce /etc/apparmor.d/*
    growpart /dev/sda 8
    resize2fs /dev/sda8
    ## Resolve a bug in the v. 1.0.0 and v1.0.1 images with the firstboot script
    if [ -f /opt/kasm/.kasm_deployment/image_version ]
    then
      IMAGE_VERSION=$(cat /opt/kasm/.kasm_deployment/image_version)
      if [[ "$${IMAGE_VERSION}" =~ 1.2.[0-2] ]]
      then
        END_OF_FILE="$(cat $${FIRSTBOOT_PATH} | wc -l)"
        let ALLOY_INSERT_LINE="$${END_OF_FILE}-$(grep -n 'sleep 10' $${FIRSTBOOT_PATH} | cut -d':' -f1)"
        sed -i "$${ALLOY_INSERT_LINE}i /opt/kasm/bin/start\ndocker compose -f /opt/kasm/alloy/run/docker-compose.yaml up -d" "$${FIRSTBOOT_PATH}"
      elif [[ "$${IMAGE_VERSION}" =~ 1.2.4 ]]
      then
          sed -i "s/\/opt\/kasm\/alloy\/docker\/docker-compose.yaml/\/opt\/kasm\/alloy\/run\/docker-compose.yaml/g" "$${FIRSTBOOT_PATH}"
      fi
    fi
    ;;
  kasm_oracle)
    DOWNLOAD_FOLDER="/home/opc"
    echo "$${ROLE}" >/opt/kasm/.kasm_deployment/kasm_role
    echo "$${CUSTOMER}" >/opt/kasm/.kasm_deployment/customer
    echo "$${DEPLOYMENT_DATE}" >/opt/kasm/.kasm_deployment/deployment_date
    echo "$${DEPLOYMENT_TYPE}" >/opt/kasm/.kasm_deployment/deployment_type
    echo "$${DEPLOYMENT_DOMAIN}" >/opt/kasm/.kasm_deployment/deployment_domain
    /usr/libexec/oci-growfs -y
    update_rhel
    ;;
  ubuntu)
    DOWNLOAD_FOLDER="/tmp"
    growpart /dev/sda 1
    resize2fs /dev/sda1
    update_ubuntu
    install_ubuntu
    ;;
  oracle)
    DOWNLOAD_FOLDER="/tmp"
    /usr/libexec/oci-growfs -y
    update_rhel
    install_rhel
    ;;
  *)
    DOWNLOAD_FOLDER="/tmp"
    ;;
esac

## Download Kasm
cd "$${DOWNLOAD_FOLDER}"
wget "$${KASM_BUILD_URL}"
tar xvf kasm_*.tar.gz

## Create Swap partition
mkdir -p /var/lib/docker/swap
fallocate -l "$${SWAP_SIZE_GB}"g /var/lib/docker/swap/kasm.swap
chmod 600 /var/lib/docker/swap/kasm.swap
mkswap /var/lib/docker/swap/kasm.swap
swapon /var/lib/docker/swap/kasm.swap
echo '/var/lib/docker/swap/kasm.swap swap swap defaults 0 0' | tee -a /etc/fstab

## Test Database connectivity before installing
while ! nc -w 1 -z "$${DB_IP}" 5432
do
  echo "Waiting for DB connection..."
  sleep 5
done

## Install Kasm
## Kasm install arguments used:
##  -S = Kasm role - webapp in this case
##  -H = Don't check for swap (since we created it already)
##  -e = accept EULA
##  -q = Database Server IP
##  -Q = Database password
##  -R = Redis password
##  -o = Redis Private IP
##  -z = The Zone name to use for the webapp
## Useful additional arguments:
##  -O = use Rolling images (ensures the most up-to-date containers are used)
echo "beginning Kasm install..."
bash "$${DOWNLOAD_FOLDER}"/kasm_release/install.sh -S "$${ROLE}" -e -H -z "$${ZONE_NAME}" -q "$${DB_IP}" -Q "$${DB_PASS}" -R "$${REDIS_PASS}" "$${ADDITIONAL_INSTALL_ARGS}"

if [[ $${INSTALL_GRAFANA} == "1" ]]
then
  echo "beginning Grafana Alloy install..."
  wget https://kasm-static-content.s3.amazonaws.com/grafana-logging/alloy_install.sh
  bash alloy_install.sh -e "$${DEPLOYMENT_DOMAIN}" -L "$${GRAFANA_USER}" -P "$${GRAFANA_PASSWORD}" -j
fi

systemctl restart firstboot