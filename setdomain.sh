echo "Setting cluster domain name to: $1.$2"

# Replace dns references in named config
sudo sed -i".new" 's/okd.home.lab/'$1.$2'/' db.192.168.1
sudo sed -i".new" 's/home.lab/'$2'/' db.192.168.1
sudo sed -i".new" 's/home.lab/'$2'/' db.192.168.1
sudo sed -i".new" 's/okd.home.lab/'$1.$2'/' db.home.lab
sudo sed -i".new" 's/home.lab/'$2'/' db.home.lab
sudo sed -i".new" 's/home.lab/'$2'/' db.192.168.1
sudo mv db.home.lab.new db.$2
sudo sed -i".new" 's/home.lab/'$2'/' named.conf.local

# Replace dns references in install_config.yaml
sudo sed -i".new" 's/home.lab/'$2'/' install-config.yaml
sudo sed -i".new" 's/name: okd/name: '$1'/' install-config.yaml