Energetic Pixels' Nginx / NodeJS / MongoDB (single instance)
====================================================

* Simple vagrant box with nginx as a reverse proxy server (load balancing, ssl) for two node instances.
* API box forwards guest ports 3000 and 3001 to 9001 and 9002 (host side) for nodejs in development mode.
  * This box has two folders on host synced to two folders on guest for api project 'home'. Automatically created by vagrant.
  * This box has two sample nodejs api scripts for initial setup testing purposes. To use, comment out API box's synced_folder lines and uncomment node_from_scratch file's section about installing 2 sample apis (4 shell script lines).

```
1. Install VirtualBox 4.0 (minimum version).
2. Install Vagrant (min version 2)
3. Clone this repo to local folder on your hard-drive
4. Using a terminal window, change directory to your new local folder (step 3)
5. Using the same terminal window, type "vagrant up --provision"
```

This project was built with the idea of using Vagrant Host Manager, and Timezone plugins.
