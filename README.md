fixityberry
===========
*Environmentally Sustainable Digital Preservation for Very Low Resourced Cultural Heritage Institutions*
![Image of FixityBerry](https://raw.githubusercontent.com/acocciolo/fixityberry/master/fixity_berry_pic.jpg)

Overview
--------

FixityBerry is software that runs on a Raspberry Pi computer that runs fixity scans on all hard drives connected via USB.  The Pi is able to read a wide variety of drive formats because packages are available for Linux for doing this.  It sends an email once scanning is complete, and shuts down the device.  The Raspberry Pi—with connected hard drives—can be connected to a power timer that automatically runs the apparatus weekly.

Setting up Fixity Berry
-----------------------

1) First, purchase a Raspberry Pi from one of their retailers: http://www.raspberrypi.org/  

2) You should purchase a SD memory card (e.g., 8 GB) with Raspbian OS pre-installed on it.  Alternatively, you can use a new or pre-existing SD card and install Raspbian on it.  Instructions on doing this can be found from the Raspberry Pi homepage. 

3) Have a standard definition or high-definition television available for setting up the PI.  You will only need this setup temporarily.  

4) Connect a USB Keyboard to the PI.  Keep the device connected to an Ethernet cable (needed to send the email over the Internet).  Power-up the device.

5) Set the administrative password for the Rasbperry Pi and don’t forget it.  The default username should be pi.

6) Login to the Linux command line, and issue the following commands.  Be sure to replace all the request values.  Your GMail email address and Gmail password is required so that the Pi can connect to an outgoing mail server to send the email message.  Your passwords should not contain any spaces.

    wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/Install.sh
    
    chmod u+x Install.sh

    sudo ./Install.sh YOUR_EMAIL_ADDRESS@HOST.COM MYSQL_ROOT_PASSWORD GMAIL_EMAIL_ADDRESS@gmail.com GMAIL_PASSWORD
    
    
7) With your hard drives connected with USB (you may want to use a USB splitter if you have several hard drives), restart the PI.  When the PI starts up, it will do the fixity scans, email you, and power down.  To restart, issue the following command:

    sudo shutdown -r now
    
You can now remove the keyboard and television, since you will not need to interact with it this way.  However, you should leave the Ethernet cable connected since it will need this to send you email reports.

8) Optional: Connect Raspberry Pi and hard drives to a power strip, and connect to it a power timer so that the fixity checking can occur weekly.  For example, the Stanley Power Timer is an inexpensive option available at Amazon: 

http://www.amazon.com/Stanley-31200-TimerMax-Grounded-1-Outlet/dp/B0020ML744

Make sure that you set the timer such that it gives FixityBerry enough time to run.  For example, if it takes FixityBerry 12 hours to scan your USB drives, then you should provide at least that much time for the device to be powered-up.


Advanced Uses
-------------

Note that FixityBerry will shutdown the Pi two minutes after completing scans of the drives.  To cancel this process, issue the followign command via the Linux prompt before the 2-minutes are up:

    sudo shutdown -c 
    
About
-----
FixityBerry is created by Anthony Cocciolo 
Contact: acocciol@pratt.edu 
Website: http://www.thinkingprojects.org
