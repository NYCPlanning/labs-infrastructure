# NYC Planning Labs Infrastructure [![CircleCI](https://circleci.com/gh/NYCPlanning/labs-infrastructure.svg?style=svg&circle-token=b893927d9ce5a4f3b386408a83cc52ba5aa02ef4)](https://circleci.com/gh/NYCPlanning/labs-infrastructure)

This repository contains code and documentation for configuring infrastructure managed by the [NYC Planning Labs](https://planninglabs.nyc/) team. The parts that get modified most frequently:

* [`playbooks/`](playbooks): [Ansible playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html) to configure [DigitalOcean Droplets](https://www.digitalocean.com/products/droplets/). Explanations of the playbooks [below](#usage).
* [`roles/internal/`](roles/internal): Custom [Ansible roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) for code shared across playbooks
* [`requirements.yml`](requirements.yml): [List of third-party Ansible roles](https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html#installing-multiple-roles-from-a-file), which get installed to `roles/external/`
* [`.circleci/config.yml`](.circleci/config.yml): Configuration for continuous integration/deployment with [CircleCI](https://circleci.com/)

## Links

* [DigitalOcean dashboard](https://cloud.digitalocean.com/dashboard?i=266877) (restricted)
* [Security/devops planning board](https://trello.com/b/35BrYfqh/planning-labs)

## Setup

1. Install dependencies.
    * Python 3
        * NOTE: You may need to install certificates to avoid an SSL error:

            ```shell
            sudo /Applications/Python\ 3.6/Install\ Certificates.command
            ```

    * [Pipenv](https://docs.pipenv.org)
1. Install Ansible and its dependencies.

    ```shell
    pipenv install
    pipenv run ansible-galaxy install -p roles/external -r requirements.yml
    ```

## Usage

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

1. Set the Digital Ocean environment variable. _This is required because Digital Ocean modules can't read from the `digital_ocean.ini` file._

    ```shell
    export $(./digital_ocean.py --env)
    ```

1. Run one of [the playbooks](playbooks). You will use `root` as the `USER` on the first run and your GitHub username on subsequent runs, as `root` access gets removed.

Any of these can be done as a "dry run" by adding `--check` to the end of the command.

Examples of running playbooks for different scenarios:

 * Test connectivity to the Droplets [tagged](https://www.digitalocean.com/docs/droplets/how-to/tag/) with `labs`.

     ```shell
     ansible labs -i digital_ocean.py -u USER -m command --args uptime
     ```

 * Configure a Droplet with [the real Ansible playbook](playbooks/base.yml).

     ```shell
     ansible-playbook -i digital_ocean.py -u USER -l DROPLET_NAME playbooks/base.yml
     ```

 * Configure all `labs` Droplets with [the real Ansible playbook](playbooks/base.yml).

     ```shell
     ansible-playbook -i digital_ocean.py -u USER -l labs playbooks/base.yml
     ```

## Adding users

1. Have them [add their SSH key to their GitHub account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/).
1. Add GitHub username to the `users` variable in [the variables file](roles/internal/common/defaults/main.yml).
1. Run the base playbook. See examples above.

## Removing users

1. Move username from the `users` to `former_users` variable in [the variables file](roles/internal/common/defaults/main.yml).
1. Run the base playbook. See examples above.

## Server checklist

Every server/Droplet should:

1. [ ] **Use an [Ubuntu LTS](https://wiki.ubuntu.com/LTS)** as the operating system, unless there's a good reason to use something else
    * <details><summary>Why</summary> Consistency</details>
1. [ ] Be **[tagged](https://www.digitalocean.com/docs/droplets/how-to/tag/) with [`labs`](https://cloud.digitalocean.com/tags/labs?i=266877)**
1. [ ] Use a **[floating IP](https://www.digitalocean.com/docs/networking/floating-ips/)**
    * <details><summary>Why</summary> So that the server can be replaced without modifying DNS, if need be</details>
    * ...especially if a `*.planning.nyc.gov` domain is going to be pointed at it
1. [ ] Have a [Cloud **Firewall**](https://www.digitalocean.com/docs/networking/firewalls/) enabled
    * <details><summary>Why</summary> To avoid unwanted traffic</details>
    * Use as restrictive of [rules](https://www.digitalocean.com/docs/networking/firewalls/how-to/configure-rules/) as possible
    * Use [private networking](https://www.digitalocean.com/docs/networking/private-networking/) where possible
1. [ ] Have an Ansible **playbook with the [`common`](roles/internal/common) role**
1. [ ] Have the services/containers/etc. **start properly after machine reboot**
    * <details><summary>Why</summary> Services/machines need to be rebooted occassionally for things like upgrades, and this will make the recovery afterwards as smooth as possible</details>
    * This needs to be tested manually

Be careful not to check secrets into this repository.
