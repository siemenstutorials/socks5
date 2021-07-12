#!/bin/sh


#install_basic
yum install git unzip wget -y
yum install -y gcc openldap-devel pam-devel openssl-devel
#download socks5
wget https://github.com/siemenstutorials/socks5/releases/download/v1/ss5-3.8.9-8.tar.gz
tar -vzx -f ss5-3.8.9-8.tar.gz
cd ss5-3.8.9/
./configure
make
make install
chmod a+x /etc/init.d/ss5
clear
#user_conf setting
read -p "请输用户名:" USER_NAME
read -p "请输入节点密码:" USER_KEY
read -p "请输入节点端口:" USER_PORT
confFile=/etc/opt/ss5/ss5.conf
pwdFile=/etc/opt/ss5/ss5.passwd
sed -i '1c $USER_NAME $USER_KEY' $pwdFile
sed -i '87c auth    0.0.0.0/0               -               u' $confFile
sed -i '203c permit u	0.0.0.0/0	-	0.0.0.0/0	-	-	-	-	-' $confFile

#Port setting
confport=/etc/init.d/ss5
sed -i '6c export SS5_SOCKS_PORT=1190' $confport
sed -i '7c export SS5_SOCKS_USER=root' $confport
sed -i "s/1190/${USER_PORT}/g" "/etc/init.d/ss5"

#auto_restart
echo 'mkdir /var/run/ss5/' >> /etc/rc.d/rc.local ;
chmod +x /etc/rc.d/rc.local ;
/sbin/chkconfig ss5 on 
service ss5 start && service ss5 status

#stop firewalld and selinux
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" "/etc/selinux/config"
cd && rm -rf *
#show_info
echo "Socks5 installed finshed！"
echo 
echo -e "\033[42;34m 用户名:${USER_NAME} \033[0m"
echo -e "\033[42;34m 密码:${USER_KEY} \033[0m"
echo -e "\033[42;34m 端口:${USER_PORT} \033[0m"
echo 

