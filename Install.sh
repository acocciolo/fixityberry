#!/bin/bash
apt-get update
apt-get -y install php5 exfat-fuse usbmount fuse ntfs-3g ssmtp mailutils mpack
debconf-set-selections <<< "mysql-server-5.1 mysql-server/root_password password $2"
debconf-set-selections <<< "mysql-server-5.1 mysql-server/root_password_again password $2"
apt-get -y install mysql-server php5-mysql


cd /home/pi

wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/fixity_berry.sql

mysql --user=root --password=$2  < fixity_berry.sql

wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/fixity_berry_orig.php

(echo -e "<?php \$email_report_to = \"$1\"; \n mysql_connect(\"localhost\", \"root\", \"$2\"); ?>" ; cat fixity_berry_orig.php) > fixity_berry.php

wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/usbmount.conf
mv usbmount.conf /etc/usbmount/

wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/00_create_model_symlink
mv 00_create_model_symlink /etc/usbmount/mount.d/
chmod ugo+rx /etc/usbmount/mount.d/00_create_model_symlink

wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/usbmount
mv usbmount /usr/share/usbmount/
chmod ugo+rx /usr/share/usbmount/usbmount

wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/rc.local
mv rc.local /etc/
chmod ugo+x /etc/rc.local

echo -e "mailhub=smtp.gmail.com:587\nAuthUser=$3\nAuthPass=$4\nuseSTARTTLS=YES\nFromLineOverride=NO" >> /etc/ssmtp/ssmtp.conf
