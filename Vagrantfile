# -*- mode: ruby -*-
# vi: set ft=ruby :
#
require_relative "credential"
include Credential

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# apt-fast 
$aptprepare = <<APTPREPARE
apt-get update
apt-get install -qq python-software-properties
apt-get install -qq git aria2
cd /tmp
git clone https://github.com/ilikenwf/apt-fast.git
cp apt-fast/apt-fast /usr/bin/
chmod +x /usr/bin/apt-fast
chown root.root /usr/bin/apt-fast
cp apt-fast/apt-fast.conf /etc/
cp apt-fast/completions/bash/apt-fast /etc/bash_completion.d/
chown root.root /etc/bash_completion.d/apt-fast
apt-fast install -y puppet
APTPREPARE

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box     = "ubuntu/trusty64"
  config.vm.network :private_network, ip:"192.168.123.10"
  config.vm.synced_folder "./", "/vagrant", id: "vagrant-root"

  config.vm.provider :kvm do |kvm,override|
      kvm.gui = true
      override.vm.box_url  = "https://vagrant-kvm-boxes-si.s3.amazonaws.com/trusty64-kvm-20140418.box"
      override.vm.synced_folder "./", "/vagrant", id: "vagrant-root", type: "nfs"
  end

  config.vm.provider :vmware do |vmware,override|
    override.vm.box    = "puphpet/ubuntu1404-x64"
  end

  config.vm.provider :aws do |aws,override|
    # private credentials
    aws.access_key_id = Access_key_id
    aws.secret_access_key = Secret_access_key
    aws.keypair_name = SSH_Key_pair_name
    override.ssh.private_key_path = SSH_Private_key_path

    aws.region            = "us-west-2"
    aws.ami               = "ami-39501209" #Ubuntu
    aws.instance_type     = "t2.micro"
    override.vm.box       = "dummy"
    aws.tags = {'Name' => 'osmfj-website-testing'}

    aws.security_groups = "sg-f387e796"
    aws.subnet_id = "subnet-7005c407"
    aws.associate_public_ip = true

    override.ssh.username = "ubuntu"
  end

  config.vm.provision "shell", inline: $aptprepare, privileged: true
  config.vm.provision "shell", path: "prepare.sh", privileged: true
  config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "init.pp"
      puppet.module_path    = "modules"
  end
end
