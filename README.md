# NYC Planning Labs Infrastructure

## Setup

1. Install dependencies.
    * Python 3
    * [Pipenv](https://docs.pipenv.org)
    * [Vagrant](https://www.vagrantup.com/)
    * [Virtualbox](https://www.virtualbox.org/)
1. Install Ansible and its dependencies.

    ```shell
    pipenv install
    pipenv shell
    ansible-galaxy install -p roles -r requirements.yml
    exit
    ```

## Development

To work on the configuration locally:

1. Start the virtual machine - this will take 5+ minutes. This Vagrant machine is meant to mimic the [DigitalOcean Dokku image](https://www.digitalocean.com/products/one-click-apps/dokku/).

    ```shell
    pipenv shell
    vagrant up
    ```

1. Follow the [Dokku setup steps](http://dokku.viewdocs.io/dokku/getting-started/install/vagrant/), starting with "Setup SSH Config".
1. Run [the Ansible playbook](playbook.yml) to configure the machine.

    ```shell
    vagrant provision --provision-with ansible
    ```

1. When done with development, shut things down.

    ```shell
    vagrant suspend
    exit
    ```

## Production

To run against a live server:

1. Enable the virtualenv.

    ```shell
    pipenv shell
    ```

1. [Create a `hosts` file](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html) in this repository with the connection information.
    * You may need to change `ansible_user=root` to your personal username after the first run, as the playbook revokes `root`'s access.
1. Run [the Ansible playbook](playbook.yml) to configure the machine.

    ```shell
    ansible-playbook -i hosts playbook.yml
    ```

1. When done with changes, stop the virtualenv.

    ```shell
    exit
    ```

## Adding users

1. Have them [add their SSH key to their GitHub account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/).
1. Add GitHub username to the `users` variable in [the playbook](playbook.yml).
1. [Run the playbook.](#production)

## Removing users

1. Move username from the `users` to `former_users` variable in [the playbook](playbook.yml).
1. [Run the playbook.](#production)
