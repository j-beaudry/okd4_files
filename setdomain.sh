echo "Setting cluster domain name to: $1.$2"

# Replace dns references in named config
sudo sed -i 's/okd.home.lab/'$1.$2'/' db.192.168.1
sudo sed -i 's/home.lab/'$2'/' db.192.168.1
sudo sed -i 's/home.lab/'$2'/' db.192.168.1
sudo sed -i 's/okd.home.lab/'$1.$2'/' db.home.lab
sudo sed -i 's/home.lab/'$2'/' db.home.lab
sudo sed -i 's/home.lab/'$2'/' db.192.168.1
sudo mv db.home.lab db.$2
sudo sed -i 's/home.lab/'$2'/' named.conf.local

# Replace dns references in install_config.yaml
sudo sed -i 's/home.lab/'$2'/' install-config.yaml
sudo sed -i 's/name: okd/name: '$1'/' install-config.yaml