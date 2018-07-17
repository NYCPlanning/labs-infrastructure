# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  # https://github.com/dokku/dokku/blob/8fa869fab25b0d485a189bf73d25fb21ffdbf9c4/Vagrantfile#L40-L42
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.hostname = "dokku.me"
  config.vm.network :private_network, ip: "10.0.0.2"

  ## install Dokku ##
  # http://dokku.viewdocs.io/dokku/getting-started/install/debian/#unattended-installation
  # http://dokku.viewdocs.io/dokku/getting-started/installation/
  config.vm.provision :file, source: "#{Dir.home}/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "playbooks/docker.yml"
  end

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "playbooks/dokku.yml"
  end
end
