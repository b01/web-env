# Usage

This documentation assumes that you are familiar enough with a Git that you know how to use a bash/Powershell terminal
to clone a repository.

## Get Started
1. Clone this repository and change into the directory.

2. Run the initial-setup command and answer the questions. You can press enter to use the default values it suggest.

3. Now change to the `APPS_DIR` like so: `cd $APPS_DIR`

   NOTE: if this command fails for you, you may need to logout and then log back into you account in order for the 
   environment variable that the initial-setup command added to your user.

5. Run the `start.sh` or `start.ps1` command.

6. Verify that the environment is working on your PC by going to 
   "https://127.0.0.1/" in a web browser. If that loads the default NGinX page then you are done.

Next, you should review the [Command Reference](command-reference.md) manual.