#Symfony 2 Vagrant Development

## Requirements

You need:
 
* [Vagrant](http://vagrantup.com)
* [Virtualbox](http://virtualbox.org)
* If you are on Windows OS install NFS support plugin [more information and detailed installation instructions](https://github.com/GM-Alex/vagrant-winnfsd):      
    ```vagrant plugin install vagrant-winnfsd```

## Installation

1. Create your folder for the Vagrant project:
    
    `mkdir symfony`

2. Clone this repository into de folder:         
        
    `git clone https://github.com/cgallardo/simple-vagrant-symfony.git symfony`              

3. Install git submodules          
    
    `git submodule update --init`
    
4. Clone/Create your symfony2 project into the 'www' folder:           
    
5. Go to the folder created on step 2 and execute `vagrant up`    

6. Check vagrant status to see if the VM is running    
    
    `vagrant status`
         
    
7. (Optional) Give a hostname to the VM in your box. Edit `etc/hosts` file and add this:     
         
    `192.168.33.100   symfony.dev www.symfony.dev`

 
## The VM

If you `vagrant ssh` you get there.
Its IP is 192.168.33.100

# Installed components

* Nginx
* PHP-FPM
* [Git](http://git-scm.com/)
* [PEAR](http://pear.php.net/)
* [cURL](http://curl.haxx.se/)
* [Node.js](http://nodejs.org/)
* [npm](https://npmjs.org/)
* [OpenJDK](http://openjdk.java.net/)
* [PHPUnit](https://phpunit.de/)
* [Imagic](http://www.imagemagick.org/script/index.php)
* [memcached](http://memcached.org/)
