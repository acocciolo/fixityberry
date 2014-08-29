apt-get update
apt-get -y install php5 exfat-fuse usbmount fuse ntfs-3g mysql-server php5-mysql ssmtp mailutils mpack


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
