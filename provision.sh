#!/usr/bin/env bash

echo "Installing System Tools..."
apt-get update -y >/dev/null 2>&1
apt-get install -y curl >/dev/null 2>&1
apt-get install -y unzip >/dev/null 2>&1
apt-get install -y libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 >/dev/null 2>&1
apt-get update >/dev/null 2>&1
apt-get install -y apt-file >/dev/null 2>&1
apt-file update >/dev/null 2>&1
apt-get install -y python-software-properties >/dev/null 2>&1
apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11 >/dev/null 2>&1
apt-get install -y xauth >/dev/null 2>&1

#  http://askubuntu.com/questions/147400/problems-with-eclipse-and-android-sdk
apt-get install -y ia32-libs >/dev/null 2>&1

echo "Installing developer dependencies"
apt-get install -y build-essential >/dev/null 2>&1
apt-get install -y git >/dev/null 2>&1

echo "Installing GCC for ARM cross-compilation"
apt-get install -y g++-4.6-arm-linux-gnueabihf >/dev/null 2>&1
echo "foreign-architecture armhf" >> /etc/dpkg/dpkg.cfg.d/multiarch
apt-get update >/dev/null 2>&1

echo "Installing Cuda v6.0 repository..."
cd /tmp
curl -s -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1204/x86_64/cuda-repo-ubuntu1204_6.0-37_amd64.deb
dpkg -i cuda-repo-ubuntu1204_6.0-37_amd64.deb >/dev/null
rm -rf /tmp/cuda-repo-ubuntu1204_6.0-37_amd64.deb
apt-get update >/dev/null 2>&1
apt-get upgrade -y >/dev/null 2>&1

echo "Installing Cuda 6.0 cross-development"
apt-get -y install cuda-cross cuda-cross-armhf >/dev/null 2>&1

echo "NVidia NSight default workspace location hack (so you get your workspace in the shared folder)"
sed -i 's/\@user.home\/cuda-workspace/\/vagrant\/cuda-workspace/g' /usr/local/cuda-6.0/libnsight/configuration/config.ini

echo "Updating Environment for user vagrant"
sudo -u vagrant bash <<"EndOfVagrantEnv"
cat << End >> ~vagrant/.profile
 export PATH=/usr/local/cuda-6.0/bin:$PATH
 export LD_LIBRARY_PATH=/usr/local/cuda-6.0/lib64:$LD_LIBRARY_PATH
End
EndOfVagrantEnv

echo "Installing Cuda Samples in user vagrant's homedir. Comment these lines if you don't want them"
apt-get install -y cuda-samples-6-0 >/dev/null 2>&1
sudo -u vagrant bash <<"EndOfVagrantCuda"
/usr/local/cuda-6.0/bin/cuda-install-samples-6.0.sh ~vagrant/cuda-samples
EndOfVagrantCuda

# echo "Adding USB device driver information..."
# echo "For more detail see http://developer.android.com/tools/device.html"
#
# chmod a+r /etc/udev/rules.d/51-android.rules
#
# service udev restart
#
# android update adb
# adb kill-server
# adb start-server
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
echo "			$ vagrant up"
echo " "
echo " 	To use VMware Workstation (Windows, Linux) (requires paid plug-in),"
echo " "
echo "			$ vagrant up"
echo " "
echo " "
echo "See the included README.md for more detail on how to run and work with this VM."
