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

## Usage

To work on the configuration locally:

1. Start the virtual machine.

    ```shell
    pipenv shell
    vagrant up
    ```

1. Run [the Ansible playbook](playbook.yml) to configure the machine.

    ```shell
    vagrant provision
    ```

1. When done with development, shut things down.

    ```shell
    vagrant suspend
    exit
    ```
