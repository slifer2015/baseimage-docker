#!/usr/bin/env bash
set -euo pipefail
source /bd_build/buildconfig


cd /tmp
curl https://godeb.s3.amazonaws.com/godeb-amd64.tar.gz | gunzip | tar xvf -
/tmp/godeb install 1.10.3
add-apt-repository ppa:webupd8team/java

curl -sL https://deb.nodesource.com/setup_9.x | bash -
curl https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" >/etc/apt/sources.list.d/elastic-5.x.list
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true  debconf-set-selections

$minimal_apt_get_install wget curl sudo git zsh nano libsqlite3-dev autoconf bison build-essential libssl-dev \
                libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev htop redis-server mariadb-server mariadb-client mercurial \
                ruby-dev rabbitmq-server realpath pkg-config unzip dnsutils re2c python-pip htop nodejs \
                python-dev libpq-dev tmux bzr libsodium-dev cmake oracle-java8-set-default python-setuptools zip \
        	postgresql elasticsearch libevent1-dev libconfig-dev liblua5.1-0-dev lua5.1 libjansson-dev iputils-ping iproute2

GOBIN=/usr/local/bin GOPATH=/tmp go get -v -u github.com/mailhog/MailHog


# Create vagrant user
bash -c "echo root:dara123 | chpasswd"
groupadd develop
useradd -g develop -m -s /usr/bin/zsh develop
bash -c "echo %develop ALL=NOPASSWD:ALL > /etc/sudoers.d/vagrant"
chmod 0440 /etc/sudoers.d/vagrant
bash -c "echo develop:dara123 | chpasswd"
sudo -Hu develop -- wget -O /home/develop/.zshrc http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
sudo -Hu develop -- wget -O /home/develop/.zshrc.local  http://git.grml.org/f/grml-etc-core/etc/skel/.zshrc

# Go related stuff
bash -c "echo export GOPATH=/home/develop >> /etc/environment"
sudo -Hu develop -- bash -c "echo export GOPATH=/home/develop >> /home/develop/.zshrc.local"
sudo -Hu develop -- bash -c "echo export PATH=$PATH:/usr/local/go/bin:/home/develop/bin >> /home/develop/.zshrc.local"
