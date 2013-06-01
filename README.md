# VEMT SERVERS

## Usefull Vagrant commands

    - vagrant up app
        - starts the VM, installs all software and makes all configurations needed (provisioning)
        - If the provisioning has already been made, it won't be done again,
            unless you delete the file "/root/vagrant_provisioning.lock"

    - vagrant suspend app
        - saves the state of the VM and shuts it down

    - vagrant resume app
        - resume the state of a suspended VM

    - vagrant halt app
        - stops a VM

    - vagrant reload app
        - Applies changes made in the vagrant file

    - vagrant destroy app
        - destroys the VM and deletes all VM files

    - vagrant ssh app
        - ssh to the VM

## APP

    - SO: CentOS 6.4 i386 (2013 04 27)

    - This box was made with VirtualBox 4.2.12, and has guest additions 4.2.12 installed in it.
        You should use the same versions to run it.

### Deployment

    - Open the file "vagrantfile" and edit 'environment = "dev"' to whatever environment you want to VM to be used for

    - Run the following command lines:
        - vagrant up app
        - vagrant ssh app
        - sudo /vagrant/provisioning/app.extras.sh <gituser> <environment>

    - If you want all packages to be updated:
        - vagrant ssh app
        - sudo yum update -y

### Commands usefull in deployment and management

    - /vagrant/provisioning/app.extras.sh <gituser> <environment>
        - must be run manualy, by ssh to the VM and runing /vagrant/provisioning/app.extras.sh <gituser> <environment>

### Issues
