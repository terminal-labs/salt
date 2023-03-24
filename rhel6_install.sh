#!/usr/bin/env bash

echo "Installing dependencies of Salt and Salt 3005 itself."

DOWNLOADS=~/downloads

mkdir -p $DOWNLOADS

(
    cd $DOWNLOADS

    sudo yum -y install gcc openssl-devel bzip2-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel zlib-devel gcc-c++ readline-devel

    wget https://www.python.org/ftp/python/3.6.9/Python-3.6.9.tgz

    tar xzf Python-3.6.9.tgz
    (
        cd Python-3.6.9
        ./configure --enable-optimizations
        sudo make altinstall
    )

    sudo ln -sfn /usr/local/bin/python3.6 /usr/bin/python3.6
    sudo ln -sfn /usr/local/bin/python3.6 /usr/bin/python3
    sudo ln -sfn /usr/local/bin/pip3.6 /usr/bin/pip3
)

SALT=/opt/salt
ETC=/etc/salt
VENV=$SALT/saltenv/bin
NON_ROOT=$USER

sudo -s <<EOF
mkdir -p $SALT

(
    cd $SALT
    python3.6 -m venv saltenv
)

$VENV/pip install -r $SALT/rhel6_reqs.txt
$VENV/pip install -e $SALT

chown -R $NON_ROOT:$NON_ROOT $SALT

# create base structure
mkdir -p $ETC/
cp $SALT/conf/master $ETC/
cp $SALT/conf/minion $ETC/

mkdir -p $ETC/master.d
mkdir -p $ETC/minion.d
mkdir -p $ETC/pki/{master,minion}

find $ETC/ -type d -exec chmod 0755 {} +
find $ETC/ -type f -exec chmod 0644 {} +

# Create service scripts
# cp $SALT/pkg/rpm/salt-master $ETC/
# cp $SALT/pkg/rpm/salt-minion $ETC/
# cp $SALT/pkg/rpm/salt-syndic $ETC/
# cp $SALT/pkg/rpm/salt-api $ETC/

echo "export PATH=$VENV:${PATH}" >> /root/.bashrc
EOF
