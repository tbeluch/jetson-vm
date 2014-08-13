jetson-vm
==========

Automated provisioning and configuration of an Ubuntu VM containing the Cuda cross-development environment, including Eclipse &amp; using the Vagrant DevOps tool with Chef and shell-scripts.

This automated VM installation and configuration uses the excellent DevOps tool, [Vagrant](http://downloads.vagrantup.com/) which works with both VirtualBox (free) and VMware Fusion &amp; Workstation (paid plug-in) in addition to several [Community Chef Cookbooks](http://community.opscode.com/cookbooks).

Please feel free to contribute improvements and enhancements to the provisioning code & reporting issues or questions.  The goal is to improve this Cuda VM project with community support.

Currently, it will provision a Jetson VM for Cuda cross-development with the following specifications,

- Ubuntu Precise64 VM
	- VirtualBox
		- Memory size: 1024 MB
		- 1 vCPU
	- VMWare
		- Memory size: 2048 MB
		- 2 vCPU
- No default desktop but a X11_forwarding option ready to use (see the provision.sh)
- NVidia Cuda repository and cuda cross development tools in latest available version


## Clone the Jetson VM Code Repository

1. Create a working directory to use for the Jetson VM project in, e.g. /opt/dev/jetson-vm or C:/csci65/jetson-vm

	In OS X &amp; Linux, e.g.

		$ mkdir -p /opt/dev/jetson-vm
		$ cd /opt/dev/jetson-vm

	In Windows, e.g.

		$ mkdir c:\dev\jetson-vm
		$ cd c:\dev\jetson-vm

2. Download or clone the project repository into the newly created directory on your local machine from one of the following sources,

	Visit the Android-VM repository on GitHub,
	[https://github.com/tbeluch/jetson-vm](https://github.com/tbeluch/jetson-vm)
	or the original Android-VM repository form rickfarmer:
	[https://github.com/rickfarmer/android-vm](https://github.com/rickfarmer/android-vm)

	Clone the Android-VM repository directly from GitHub,

	[https://github.com/tbeluch/jetson-vm.git](https://github.com/tbeluch/jetson-vm.git)

	Download the Android-VM repository as a zip file,

	[https://github.com/tbeluch/jetson-vm/archive/master.zip](https://github.com/tbeluch/jetson-vm/archive/master.zip)


## Install Vagrant

Note: Vagrant has a prerequisite of an installed and functioning version of one of the following virtualization products,

* [VMware Fusion (mac)](http://www.vmware.com/go/tryfusion) (Trial)
* [VMware Workstation (windows, linux)](http://www.vmware.com/products/workstation/workstation-evaluation) (Trial)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (Free)

1. Download and install the latest version of Vagrant for your OS from  [https://www.vagrantup.com/downloads.html](vagrantup.com/)

2. If using VMware, install the purchased VMware Provider Plug-in as mentioned in the documentation


## Install the Android VM

_Note: All the software needed is automatically downloaded as it is needed.  Several of the downloads are somewhat large.  Patience is a virtue while the automated installation is running._

1. From the newly created working directory, e.g.

		$ cd /opt/dev/jetson-vm
		$ git submodule init
		$ git submodule update

2. Run the following to start Vagrant and kick-off the process to build an Android VM,

	For VirtualBox,

		$ vagrant up

	For VMware Fusion,

		$ vagrant up --provider=vmware_fusion

	For VMware Workstation,

		$ vagrant up --provider=vmware_workstation

	_Note: As the Android VM build runs you will see various types of screen output from Vagrant, Chef and Shell scripts -- some of the dependency downloads and compilations require a bit of time.  Again, Patience is a virtue._
3. Once the Android VM build provisioning process is complete, run the following to login via SSH,

		$ vagrant ssh

4. The Ubuntu Unity desktop UI is set to automatically launch on `vagrant up`, login using the credentials,
	- Username: vagrant
	- Password: vagrant
5. The Android development environment directories with eclipse, sdk and ndk are located in the directory `/usr/local/jetson/`.
6. The VM has an internal `/vagrant` directory which maps to the directory created previously (i.e. the one from which you are running the Android VM on your local machine), e.g. `/opt/dev/jetson-vm` or `c:\projects\jetson-vm` maps to the internal VM directory `/vagrant`.

	_The net effect is that anything you drop in your local working directory, e.g. e.g. /csci65/jetson-vm or c:\csci65\jetson-vm, can be accessed from within the VM by opening the directory "/vagrant" and vice-versa_


## Manually Configure the Jetson VM in the Virtualization Provider

To connect an Android device you must manually setup a USB connection mapping for your Android device to the new VM

This configuration will vary with your provider (hypervisor), VMware Fusion, Workstation, or VirtualBox.

For example, if using VMware Fusion perform the following steps,

1. Plug your android device hardware into the computers USB port
2. Open the 'Virtual Machine Library'
3. Select the VM, e.g. "android-vm: default", right-click and choose 'Settings...'
4. Select 'USB & Bluetooth', check the box next to your device and set the 'Plug In Action' to 'Connect to Linux'
5. Plug the device into the USB port and verify that it appears when you run `lsusb` from the command line
6. Your device should appear when running `lsusb` enabling you to use Android `adb`, e.g.

		$ adb devices
			...
			List of devices attached
			007jbmi6          device

		$ adb shell
			i.e. to log into the device (be sure to enable USB debugging on the device)

_Note: Additionally you may want to change various settings in the Virtualization Provider to size memory and vCPUs allocated to the Android VM_
_Note: To open the terminal from desktop, use ctrl-alt-T for PC or control-option-T for Mac

### Vagrant Basics &amp; Workflow

Vagrant boxes are just pre-configured virtual machines that Vagrant uses as a template to clone.

To see the available boxes,

		$ vagrant box list
		...
		precise64   (vmware_fusion)
		precise64   (virtualbox)
		centos64    (vmware_fusion)

The box files (aka template VMs) are stored in `~/vagrant.d` but you should not care since you manage the box files through vagrant.

When you issue `vagrant up`, vagrant will download the box from the url unless its already cached locally.  Once available, it will clone the box into the directory you've chosen to work in, e.g. `/csci65/android-vm`

In the base directory (e.g. `/csci65/android-vm`) where the `Vagrantfile` is located, you should see a hidden `.vagrant` directory which holds the actual cloned VM files if you are interested in exploring further.

- To start your vagrant system use,

	For VirtualBox,

		$ vagrant up

	For VMware Fusion,

		$ vagrant up --provider=vmware_fusion

	For VMware Workstation,

		$ vagrant up --provider=vmware_workstation

- To login to your vagrant system use,

		$ vagrant ssh

- The basic workflow is,

		$ vagrant up    # To start the VM using VirtualBox (default)
or

		$ vagrant up --provider=vmware_fusion     # To start the VM using VMware Fusion (vmware_workstation for Windows users)
			*Spins up the Jetson VM and loads the Ubuntu Unity desktop UI*
		$ vagrant ssh
			*At this point you are logged into the VM to do the cli work you want to do, e.g.*
			$ lsusb
			$ adb devices
			$ adb shell
			$ adb install
			$ adb push
			$ adb pull
			... for more detail see [http://developer.android.com/tools/help/adb.html]

		$ android (from the command line) see [http://developer.android.com/tools/projects/projects-cmdline.html]

		$ vagrant status
		$ vagrant halt  # To shutdown the VM
or

		$ vagrant suspend  

- These are the only commands you will likely use on a regular basis.  Vagrant manages everything for you, so there is no need to configure the VM from VMware or Virtual Box except to change the VM memory, CPU allocation, &amp; connect the Android USB device for connection via the Android `adb` command.

If you are interested in the other options Vagrant offers, please see the man help file using,

	$ vagrant --help


### References

1. [Vagrant v2 documentation](http://docs.vagrantup.com/v2/getting-started/)
2. [http://www.vagrantbox.es/](http://www.vagrantbox.es/)
3. [Chef Cookbooks](http://community.opscode.com/cookbooks)
