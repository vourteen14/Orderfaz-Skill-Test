
## Langkah-langkah installasi Pritunl

### Tambakhan repository mongodb

````
sudo tee /etc/yum.repos.d/mongodb-org.repo << EOF
[mongodb-org]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/8/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc
EOF
````

### Tambakhan repository pritunl
````
sudo tee /etc/yum.repos.d/pritunl.repo << EOF
[pritunl]
name=Pritunl Repository
baseurl=https://repo.pritunl.com/stable/yum/almalinux/8/
gpgcheck=1
enabled=1
gpgkey=https://raw.githubusercontent.com/pritunl/pgp/master/pritunl_repo_pub.asc
EOF
````

### Update & upgrade package

````sudo dnf -y update````

### Disable build in firewall

````sudo dnf -y remove iptables-services````
````sudo systemctl stop firewalld.service````
````sudo systemctl disable firewalld.service````

### Install pritunl dan mongodb-org

````sudo dnf -y install pritunl pritunl-openvpn wireguard-tools mongodb-org````

### Start service pritunl dan mongodb

````sudo systemctl enable mongod pritunl````
````sudo systemctl start mongod pritunl````

## Akses Pritunl

Buka browser dan kunjungi: https://<SERVER-IP>