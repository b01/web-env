# Commands

## config-app

    This command will perform the following task in order:
    
    1. Check to see if the repository exists in the APPS_DIR, if not then attempt to download it over git protocol.
    2. Check for an NGinX config file in the repositories web-env directory and attempt to load it.
    3. Check for a bin/build.sh script and run if found, in the repositories folder.

* 1st argument is the git URL for the repository that should be configured.
* 2nd argument is the name of the Docker container where the build script should be run.
* 3rd argument is the name of the Docker container that contains the NGinX server to restart.

## copies

    This is more of a Quality-of-Life (QoL) script which will copy sensitive files over to containers, like:
    
    1. SSH keys - so that you can push/pull, and avoid switching to another terminal in order to run the same command
       on the host machine.
    2. Git configuration - allowing you to use the same Git configuration as on your host machine.

## initial-setup

    This command sets environment variables at the USER Level. On Linux and Mac it stores them in your `.bash_profile` 
    of the home directory. On Windows they are stored in `C:\Users\<username>\Documents\WindowsPowerShell\profile.ps1`.
    On Mac and Linux bash will load this file before the terminal is presented, and the same for Powershell on Windows.
    Now variables we need in order to run other commands will be set, and we only needed to do it once. Since this is a
    one time thing, the variables are stored until you remove them manually from these files.

## start

    Starts up the web environment in the following steps:
    
    1. builds an apps.env file. The variables are taken from list within each repository with a `web-env/env-vars.txt`
       file. This file conatians only the name of an environment variable, each on a seperate line.
       These file are read and each variable is added to the `apps.env` file according to Docker .env file syntax.
    2. Spins up the containers running docker-compose (on the provided docker-compose.yml file) in a seperate terminal
       window/tab.

## stop

    Brings the WebEnv down and performs cleanup, such as removing the docker containers.