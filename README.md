# NYC Planning Labs Infrastructure

## Usage

1. Install dependencies.
    * Python 3
    * [Pipenv](https://docs.pipenv.org)
    * [Vagrant](https://www.vagrantup.com/)
    * [Virtualbox](https://www.virtualbox.org/)
1. Run the setup:

    ```shell
    pipenv install
    pipenv shell
    ansible-galaxy install -p roles -r requirements.yml

    vagrant up
    vagrant provision
    ```
