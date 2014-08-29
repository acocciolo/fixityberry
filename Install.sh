apt-get update
apt-get -y install php5 exfat-fuse usbmount fuse ntfs-3g ssmtp mailutils mpack
debconf-set-selections <<< 'mysql-server-5.1 mysql-server/root_password password $2'
debconf-set-selections <<< 'mysql-server-5.1 mysql-server/root_password_again password $2'
sudo apt-get -y install mysql-server php5-mysql


cd /home/pi

wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/fixity_berry.sql

mysql --user=root --password="$2" -e "CREATE DATABASE fixity_berry; CREATE USER 'fixity_berry'@'localhost' IDENTIFED BY '$3'; GRANT ALL PRIVILEGES ON *.* TO 'fixity_berry'@'localhost';"
mysql --user=fixity_berry --password="$3" < fixity_berry.sql

wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/fixity_berry_orig.php

(echo "<?php \$email_report_to = \"$1\"; \n mysql_connect(\"localhost\", \"fixity_berry\", \"$3\"); ?>" ; cat fixity_berry_orig.php) > fixity_berry.php

wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/usbmount.conf
mv usbmount.conf /etc/usbmount/

wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/00_create_model_symlink
mv 00_create_model_symlink /etc/usbmount/mount.d/

wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/usbmount
mv usbmount /usr/share/usbmount/

wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/rc.local
mv rc.local /etc/
