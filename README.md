fixityberry
===========


Overview
=======

FixityBerry is software that runs on a Raspberry Pi computer that runs fixity scans on all hard drives connected via USB.  The Pi is able to read a wide variety of drive formats because packages are available for Linux for doing this.  It sends an email once scanning is complete.  The Raspberry Pi—-with connected hard drives—can be connected to a power timer that it it gets run weekly.

Setting up Fixity Berry
=======================

1) First, purchase a Raspberry Pi from one of their retailers: http://www.raspberrypi.org/  

2) You should purchase a SD memory card (e.g., 8 GB) with Raspbian OS pre-installed on it.  Alternatively, you can use a new or pre-existing SD card and install Raspbian on it.  Instructions on doing this can be found from the Raspberry Pi homepage. 

3) Have a standard definition or high-definition television available for setting up the PI.  You will only need this setup temporarily.  

4) Connect a USB Keyboard and mouse to the PI.  Power-up the device.

5) Set the administrative password for the Rasbperry Pi and don’t forget it.  The default username should be pi.

6) Login to the Linux command line.  Install the following packages needed by FixityBerry by issuing the following command.

wget https://raw.githubusercontent.com/acocciolo/fixityberry/master/Install.sh

./Install.sh YOUR_EMAIL_ADDRESS@gmail.com





Optional: Connect Raspberry Pi and hard drives to a power strip, and connect to it a power timer so that the fixity checking can occur weekly.  For example, the Stanley Power Timer is available at Amazon: 

http://www.amazon.com/Stanley-31200-TimerMax-Grounded-1-Outlet/dp/B0020ML744
