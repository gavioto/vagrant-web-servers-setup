# SERVERS

    Boxes:
        - CentOS 6.4 i386 (2013 04 27)
        - This box was made with VirtualBox 4.2.12, and has guest additions 4.2.12 installed in it.
            You should use the same versions to run it.

    This Vagrant setup currently provides 3 servers:

        - app
            An apache/php webserver. If in dev environment it will also install development utilities
            You can access it through http://192.168.1.11

        - db
            A MySQL server with phpMyAdmin
            You can access MySQL through http://192.168.1.21/phpmyadmin
            Default user/pass: root/xpto (you should use vendor scripts to change this)

        - reports
            A reports server, with SOLR and JasperReports Server.

            - SOLR
                You can access SOLR through http://192.168.1.31:8080/instance1
                Default user/pass: root/xpto (you should use vendor scripts to change this)
                Jasperserver user/pass: reportsserver/xpto (you should use vendor scripts to change this)
                You can add new instances and cores in /opt/solr/instances, duplicating the 'instance1' example.
                Config files to edit in each new deployment:
                    /opt/solr/instances/<instance_name>.xml
                    /opt/solr/instances/<instance_name>/solr.xml
                    /opt/solr/instances/<instance_name>/<core_name>/schema.xml
                    /opt/solr/instances/<instance_name>/<core_name>/dataimport.xml
                To make tomcat aware of a new instance, run:
                    ln -s /opt/solr/instances/<instance_name>.xml /usr/share/tomcat6/conf/Catalina/localhost/<instance_name>.xml

            - Jasper Reports Server
                You can access Jasper server through http://192.168.1.31/jasperserver
                Default user/pass: jasperadmin/jasperadmin, joeuser/joeuser

        - mailings (planed OpenEmm installation)

## Box Deployment

    - Install git and vagrant
    - do: git clone git@github.com:hgraca/vagrant-web-servers-setup.git ~/path/to/your/projects/folder
    - Open the file "vagrantfile" and edit the variables to your needs,
        or create a vendor folder as per the default example and edit vagrantfile.rb

    - Run the following command lines:
        - cd ~/path/to/your/projects/folder
        - vagrant up <box_name>

    - If you want all packages to be updated:
        - vagrant ssh <box_name>
        - sudo yum update -y

## Usefull Vagrant commands

    - vagrant up <box_name>
        - starts the VM, installs all software and makes all configurations needed (provisioning)
        - If the provisioning has already been made, it won't be done again,
            unless you delete the file "/root/vagrant_provisioning.lock"

    - vagrant suspend <box_name>
        - saves the state of the VM and shuts it down

    - vagrant resume <box_name>
        - resume the state of a suspended VM

    - vagrant halt <box_name>
        - stops a VM

    - vagrant reload <box_name>
        - Applies changes made in the vagrant file

    - vagrant destroy <box_name>
        - destroys the VM and deletes all VM files

    - vagrant ssh <box_name>
        - ssh to the VM

