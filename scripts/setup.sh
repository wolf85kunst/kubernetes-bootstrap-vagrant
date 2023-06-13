#!/bin/bash

apt-get update
apt-get install -y vim rsync openssh-server net-tools

# MANAGE SSH PUB KEY
mkdir -p /root/.ssh/
chmod 700 /root/.ssh/
echo '__MY_PUBLIC_KEY__' >> /root/.ssh/authorized_keys 
chmod 600 /root/.ssh/authorized_keys

# Bashrc
cat <<EOF >> /root/.bashrc
IFACE=\$(ip a |grep '^[0-9]:' |sed -ne 2p |awk '{print \$2}' |sed 's/://')
IP=\$(ip addr show dev "\${IFACE}" |tr -d '\n' | sed -r "s/.*inet ([0-9.]*)\/[0-9]*.*/\1/")
export PS1='\[\033[0;92m\]\u@\H\[\033[1;37m\][\$IP]\[\033[0;92m\]:\w$ \[\033[0;37m\]'
export HISTTIMEFORMAT="%Y/%m/%d-%Hh%M :"
EOF
