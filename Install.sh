sudo apt-get install php5
sudo apt-get install exfat-fuse
sudo apt-get install usbmount
sudo apt-get install fuse ntfs-3g
sudo apt-get install mysql-server
sudo apt-get install php5-mysql

sudo apt-get install ssmtp mailutils mpack

cd /home/pi

wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/fixity_berry_orig.php

(echo "<?php $email_report_to = "$1"; ?>" ; cat fixity_berry_orig.php) > fixity_berry.php

cd /etc/usbmount
sudo wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/usbmount.conf


cd mount.d
sudo wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/00_create_model_symlink


cd /usr/share/usbmount
