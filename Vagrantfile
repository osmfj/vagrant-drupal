# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.box           = "precise64"
  config.vm.box_url      = "http://files.vagrantup.com/precise64.box"
  config.vm.network :private_network, ip:"192.168.123.10"
  config.vm.hostname      = "vagrant.example.com"
  
  config.vm.provider :kvm do |kvm,override|
      kvm.gui = true
      override.vm.box_url  = "https://dl.dropboxusercontent.com/u/90779460/precise64-kvm.box"
  end

  config.vm.provider :vmware do |vmware,override|
    override.vm.box_url    = "http://files.vagrantup.com/precise64_vmware.box"
  end

  config.vm.provider :lxc do |lxc,override|
    override.vm.box_url    = "http://dl.dropbox.com/u/13510779/lxc-precise-amd64-2013-07-12.box"
  end

  config.vm.provider :aws do |aws,override|
      aws.tags              = ["test", "dev", "web"]
      aws.region            = "ap-northeast-1"
      aws.ami               = "ami-7d1d977c" #Ubuntu
      aws.instance_type     = "t1.micro"
      aws.ssh_username      = "ubuntu"
      aws.security_groups   = ["web"]
      aws.access_key_id     = ENV['AWS_ACCESS_KEY_ID']
      aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
      aws.keypair_name      = ENV['AWS_KEYPAIR_NAME']
      override.vm.box       = "dummy"
      override.vm.box_url   = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
      override.ssh.username = "ubuntu"
      override.ssh.private_key_path = "YOUR_AWS_KEY_PATH"
  end

  config.vm.provision :puppet do |puppet|
      puppet.facter = { "fqdn" => "drupal.osmfj", "hostname" => "drupal" }
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "init.pp"
      puppet.module_path    = "modules"
  end

end
