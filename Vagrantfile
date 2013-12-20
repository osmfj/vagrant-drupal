# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.box     = "precise64"
  
  config.vm.provider :kvm do |kvm,override|
      # nothing to configure
      # kvm.ui = true  #enable vnc console
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
      override.ssh.private_key_path = "~/Management/Aws/cert/miurahr_tokyo.pem"
  end

  config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "init.pp"
      puppet.module_path    = "modules"
  end

end
