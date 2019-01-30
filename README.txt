This was tested and designed using Laravel 5.7.

1. Clone or download a new Laravel project from https://www.github.com/laravel/laravel

2. Take every one of the files in this repository EXCEPT for this README, .vagrant and .git and copy them into your Laravel project's folder. 

3. Create a folder called dev_assets. Put all the files you copied into the folder with the exception of the Vagrantfile into the dev_assets folder.

4. Run vagrant up in your command line and it should provision without any problems.

5. vagrant ssh into Vagrant and then use the ifconfig command to get the host to put in your browser.

6. Migrate the database if you wish and you're all set!

