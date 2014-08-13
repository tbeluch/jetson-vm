#!/usr/bin/env bash

echo "Installing System Tools..."
sudo apt-get update -y >/dev/null 2>&1
sudo apt-get install -y curl >/dev/null 2>&1
sudo apt-get install -y unzip >/dev/null 2>&1
sudo apt-get install -y libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 >/dev/null 2>&1
sudo apt-get update >/dev/null 2>&1
sudo apt-get install apt-file && apt-file update
sudo apt-get install -y python-software-properties >/dev/null 2>&1
sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
sudo apt-get install -y xauth >/dev/null 2>&1

#  http://askubuntu.com/questions/147400/problems-with-eclipse-and-android-sdk
sudo apt-get install -y ia32-libs >/dev/null 2>&1

echo "Installing GCC for ARM cross-compilation"
sudo apt-get install -y g++-4.6-arm-linux-gnueabihf
sudo sh -c 'echo "foreign-architecture armhf" >> /etc/dpkg/dpkg.cfg.d/multiarch'
sudo apt-get update

echo "Installing Cuda v6.0 repository..."
cd /tmp
sudo curl -s -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1204/x86_64/cuda-repo-ubuntu1204_6.0-37_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1204_6.0-37_amd64.deb
sudo rm -rf /tmp/cuda-repo-ubuntu1204_6.0-37_amd64.deb
sudo apt-get update

echo "Installing Cuda 6.0"
sudo apt-get install cuda

echo "Updating Environment"
cd ~/
cat << End >> .profile
 export PATH=/usr/local/cuda-6.0/bin:$PATH
 export LD_LIBRARY_PATH=/usr/local/cuda-6.0/lib64:$LD_LIBRARY_PATH
End

echo "Installing Cuda Samples. Comment these lines if you don't want them"
cd ~/
sudo apt-get install -y cuda-samples-6-0
/usr/local/cuda-6.0/bin/cuda-install-samples-6.0.sh cuda-samples

# echo "Adding USB device driver information..."
# echo "For more detail see http://developer.android.com/tools/device.html"
#
# sudo chmod a+r /etc/udev/rules.d/51-android.rules
#
# sudo service udev restart
#
# sudo android update adb
# sudo adb kill-server
# sudo adb start-server
#
# echo " "
# echo " "
# echo " "
# echo "[ Next Steps ]================================================================"
# echo " "
# echo "1. Manually setup a USB connection for your Android device to the new VM"
# echo " "
# echo "	If using VMware Fusion (for example, will be similar for VirtualBox):"
# echo "  	1. Plug your android device hardware into the computers USB port"
# echo "  	2. Open the 'Virtual Machine Library'"
# echo "  	3. Select the VM, e.g. 'android-vm: default', right-click and choose"
# echo " 		   'Settings...'"
# echo "  	4. Select 'USB & Bluetooth', check the box next to your device and set"
# echo " 		   the 'Plug In Action' to 'Connect to Linux'"
# echo "  	5. Plug the device into the USB port and verify that it appears when "
# echo "         you run 'lsusb' from the command line"
# echo " "
# echo "2. Your device should appear when running 'lsusb' enabling you to use adb, e.g."
# echo " "
# echo "		$ adb devices"
# echo "			ex. output,"
# echo " 		       List of devices attached"
# echo " 		       007jbmi6          device"
# echo " "
# echo "		$ adb shell"
# echo " 		    i.e. to log into the device (be sure to enable USB debugging on the device)"
# echo " "
echo "See the included README.md for more detail on how to run and work with this VM."
echo " "
echo "[ Start your Ubuntu VM ]======================================================"
echo " "
echo "To start the VM, "
echo " 	To use with VirtualBox (free),"
echo " "
echo "			$ vagrant up"
echo " "
echo " 	To use with VMware Fusion (OS X) (requires paid plug-in),"
echo " "
echo "			$ vagrant up --provider=vmware_fusion"
echo " "
echo " 	To use VMware Workstation (Windows, Linux) (requires paid plug-in),"
echo " "
echo "			$ vagrant up --provider=vmware_workstation"
echo " "
echo " "
echo "See the included README.md for more detail on how to run and work with this VM."
