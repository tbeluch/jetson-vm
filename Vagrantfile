# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
PROJECT_NAME = "jetson"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "hashicorp/precise64"
  config.ssh.forward_x11 = true
  config.vm.host_name = PROJECT_NAME

	# Boot with a GUI so you can see the screen. (Default is headless)
	#config.vm.boot_mode = :gui
  config.vm.provider "virtualbox" do |v|
    v.name = PROJECT_NAME
    v.gui = false
  end


  config.vm.provider "vmware_desktop" do |v, override|
    v.name = PROJECT_NAME
    v.gui = false
    v.vmx["memsize"] = "2048"
    v.vmx["numvcpus"] = "2"
  end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  config.vm.provision :chef_solo do |chef|

    chef.cookbooks_path = "cookbooks"

    chef.add_recipe "java"

    chef.json = {
      "java" => {
        "install_flavor" => "oracle",
        "jdk_version" => "7",
        "oracle" => {
          "accept_oracle_download_terms" => true
        }
      }
    }

  end

  config.vm.provision "shell", inline: "echo Installing Cuda repository and dependencies"
  config.vm.provision "shell", path: "provision.sh"
  config.vm.provision "shell", inline: "echo Installation complete"

  config.vm.synced_folder "./", "/vagrant", owner: 'vagrant', group: 'vagrant'
end
