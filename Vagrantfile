# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  # mimic the DigitalOcean Dokku image
  # https://www.digitalocean.com/products/one-click-apps/dokku/
  config.vm.define "dokku", autostart: false do |dokku|
    # https://github.com/dokku/dokku/blob/8fa869fab25b0d485a189bf73d25fb21ffdbf9c4/Vagrantfile#L40-L42
    dokku.vm.network "forwarded_port", guest: 80, host: 8080
    dokku.vm.hostname = "dokku.me"
    dokku.vm.network :private_network, ip: "10.0.0.2"

    ## install Dokku ##
    # http://dokku.viewdocs.io/dokku/getting-started/install/debian/#unattended-installation
    # http://dokku.viewdocs.io/dokku/getting-started/installation/
    dokku.vm.provision :file, source: "#{Dir.home}/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"

    dokku.vm.provision "ansible" do |ansible|
      ansible.verbose = "v"
      ansible.playbook = "playbooks/docker.yml"
    end

    dokku.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "playbooks/dokku.yml"
  end
  end

  # mimic the DigitalOcean Docker image
  # https://www.digitalocean.com/products/one-click-apps/docker/
  config.vm.define "geosearch", autostart: false do |geosearch|
    geosearch.vm.provision "shell", path: "scripts/install_docker.sh"

    geosearch.vm.provision "ansible" do |ansible|
      ansible.verbose = "v"
      ansible.playbook = "playbooks/geosearch.yml"
    end
  end
end
