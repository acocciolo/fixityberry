apt-get update
apt-get install php5
apt-get install exfat-fuse
apt-get install usbmount
apt-get install fuse ntfs-3g
apt-get install mysql-server
apt-get install php5-mysql
apt-get install ssmtp mailutils mpack

cd /home/pi

wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/fixity_berry.sql

mysql --user=root --password="$2" -e "CREATE DATABASE fixity_berry; CREATE USER 'fixity_berry'@'localhost' IDENTIFED BY '$3'; GRANT ALL PRIVILEGES ON *.* TO 'fixity_berry'@'localhost';"
mysql --user=fixity_berry --password="$3" < fixity_berry.sql


wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/fixity_berry_orig.php

(echo "<?php \$email_report_to = \"$1\"; \n mysql_connect(\"localhost\", \"fixity_berry\", \"$3\"); ?>" ; cat fixity_berry_orig.php) > fixity_berry.php

cd /etc/usbmount
wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/usbmount.conf

cd mount.d
wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/00_create_model_symlink

cd /usr/share/usbmount
wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/usbmount

cd /etc
wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/rc.local
