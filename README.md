#Symfony 2 Vagrant Development for Runator

## Requirements

You need:
 
* [Vagrant](http://vagrantup.com)
* [Virtualbox](http://virtualbox.org)
* If you are on Windows OS install NFS support plugin [more information and detailed installation instructions](https://github.com/GM-Alex/vagrant-winnfsd):      
    ```vagrant plugin install vagrant-winnfsd```

## Installation

1. Create your folder for the Vagrant project:
    
    `mkdir runator`

2. Clone this repository into de folder:         
    
    `cd runator`    
    `git clone https://<user>@bitbucket.org/runatorteam/runator-vagrant-nginx.git .`              

3. Install git submodules          
    
    `git submodule update --init`
    
4. Clone your symfony2 repository into the 'www' folder:      

    `git clone https://<user>@bitbucket.org/runatorteam/runator.git www`     
              
    
5. Go to the folder created on step 2 and execute `vagrant up`, wait, takes long.    

6. Check vagrant status to see if the VM is running    
    
    `vagrant status`
         
    
7. (Optional) Give a hostname to the VM in your box. Edit `etc/hosts` file and add this:     
         
    `192.168.33.125   runator.dev www.runator.dev webmail.runator.dev`

 
## The 'web' VM

If you `vagrant ssh` you get there.
Its IP is 192.168.33.125

# Installed components

* Nginx
* PHP-FPM
* [Composer](http://getcomposer.org) installed globally (use ```composer self-update``` to get the newest version)
* [Git](http://git-scm.com/)
* [PEAR](http://pear.php.net/)
* [cURL](http://curl.haxx.se/)
* [Node.js](http://nodejs.org/)
* [npm](https://npmjs.org/)
* [OpenJDK](http://openjdk.java.net/)
* [PHPUnit](https://phpunit.de/)
* [Imagic](http://www.imagemagick.org/script/index.php)
* [memcached](http://memcached.org/)
* [http://webmail.runator.dev](http://webmail.runator.dev) -> Webmail powered by [Maildev](https://github.com/djfarrelly/MailDev)

## Based on

* [https://github.com/irmantas/symfony2-vagrant](https://github.com/irmantas/symfony2-vagrant)

## TODO

* Fix warnings when vagrant up
* Add auto git fecth for runator repo