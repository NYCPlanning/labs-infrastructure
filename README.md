# NYC Planning Labs Infrastructure [![CircleCI](https://circleci.com/gh/NYCPlanning/labs-infrastructure.svg?style=svg&circle-token=b893927d9ce5a4f3b386408a83cc52ba5aa02ef4)](https://circleci.com/gh/NYCPlanning/labs-infrastructure)

This repository contains code and documentation for configuring infrastructure managed by the [NYC Planning Labs](https://planninglabs.nyc/) team. For starters, there are [Ansible playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html) to configure the [DigitalOcean Droplets](https://www.digitalocean.com/products/droplets/).

## Links

* [DigitalOcean dashboard](https://cloud.digitalocean.com/dashboard?i=266877) (restricted)
* [Security/devops planning board](https://trello.com/b/35BrYfqh/planning-labs)

## Setup

1. Install dependencies.
    * Python 3
    * [Pipenv](https://docs.pipenv.org)
    * [Vagrant](https://www.vagrantup.com/)
    * [Virtualbox](https://www.virtualbox.org/)
1. Install Ansible and its dependencies.

    ```shell
    pipenv install
    pipenv run ansible-galaxy install -p roles -r requirements.yml
    ```

## Development

To work on the configuration against a local virtual machine (that mimics a [Dokku Droplet](https://www.digitalocean.com/products/one-click-apps/dokku/)):

1. Do the one-time setup.
    1. Do the "Setup SSH Config" step from the [Dokku setup docs](http://dokku.viewdocs.io/dokku/getting-started/install/vagrant/).
1. Start the virtual machine - this will take 5+ minutes the first time. This Vagrant machine is meant to mimic the [DigitalOcean Dokku image](https://www.digitalocean.com/products/one-click-apps/dokku/).

    ```shell
    pipenv shell
    vagrant up
    ```

1. Run [the Ansible playbook](playbooks/base.yml) to configure the machine.

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

1. Do the one-time credential setup.
    1. [Create a DigitalOcean token](https://www.digitalocean.com/docs/api/create-personal-access-token/) with read access.
    1. Save your token to a `digital_ocean.ini` configuration file.

        ```ini
        [digital_ocean]
        api_token=TOKEN
        ```

1. Enable the virtualenv.

    ```shell
    pipenv shell
    ```

1. Run one of [the playbooks](playbooks). You will use `root` as the `USER` on the first run and your GitHub username on subsequent runs, as `root` access is deprecated. Examples:
    * Test connectivity by running [the test Ansible playbook](playbooks/test.yml) against the Droplets [tagged](https://www.digitalocean.com/docs/droplets/how-to/tag/) with `labs`.

        ```shell
        ansible-playbook -i digital_ocean.py -l labs -u USER playbooks/test.yml
        ```

    * Configure a Droplet with [the real Ansible playbook](playbooks/base.yml).

        ```shell
        ansible-playbook -i digital_ocean.py -u USER -l DROPLET_NAME playbooks/base.yml
        ```

    * Configure all `labs` Droplets with [the real Ansible playbook](playbooks/base.yml).

        ```shell
        ansible-playbook -i digital_ocean.py -l labs -u USER playbooks/base.yml
        ```

    * Configure the [Dokku Droplet](http://dokku.viewdocs.io/dokku/getting-started/install/digitalocean/) with [the Dokku playbook](playbooks/dokku.yml).

        ```shell
        ansible-playbook -i digital_ocean.py -l labs-01 -u USER playbooks/dokku.yml
        ```

1. When done with changes, stop the virtualenv.

    ```shell
    exit
    ```

## Adding users

1. Have them [add their SSH key to their GitHub account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/).
1. Add GitHub username to the `users` variable in [the playbook](playbooks/base.yml).
1. [Run the playbook.](#production)

## Removing users

1. Move username from the `users` to `former_users` variable in [the playbook](playbooks/base.yml).
1. [Run the playbook.](#production)
