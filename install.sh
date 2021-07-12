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
echo
read -p "Please input User(Default User:s1)：" user
[ -z "${user}" ] && user=1
echo
echo "-----------------------------------------------------"
echo "user = ${user}"
echo "-----------------------------------------------------"
echo
read -p "Please input passwd(Default Userpasswd:jxyt668)：" passwd
[ -z "${passwd}" ] && passwd=1
echo
echo "-----------------------------------------------------"
echo "passwd = ${passwd}"
echo "-----------------------------------------------------"
echo
read -p "Please input Port(Default Port:1190)：" port
[ -z "${port}" ] && port=1190
echo
echo "-----------------------------------------------------"
echo "port = ${port}"
echo "-----------------------------------------------------"
echo
confFile=/etc/opt/ss5/ss5.conf
echo -e ${user} ${passwd} >> /etc/opt/ss5/ss5.passwd
sed -i '87c auth    0.0.0.0/0               -               u' $confFile
sed -i '203c permit u	0.0.0.0/0	-	0.0.0.0/0	-	-	-	-	-' $confFile

#Port setting
confport=/etc/init.d/ss5
sed -i '6c export SS5_SOCKS_PORT=1180' $confport
sed -i '7c export SS5_SOCKS_USER=root' $confport
sed -i "s|1180|${dport}|" $confport

#auto_restart
echo 'mkdir /var/run/ss5/' >> /etc/rc.d/rc.local ;
chmod +x /etc/rc.d/rc.local ;
/sbin/chkconfig ss5 on 
service ss5 start && service ss5 status

#stop firewalld and selinux
systemctl stop firewalld
systemctl disable firewalld
sed -i ‘s/^SELINUX=enforcing/SELINUX=disabled/g’ /etc/sysconfig/selinux
cd && rm -rf *
#show_info
echo
echo "用户名: "${user}
echo "密码: "${passwd}
echo "端口: "${port}
echo
echo "Socks5 installed finshed！"
