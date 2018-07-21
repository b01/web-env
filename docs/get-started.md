# Get Started

1. Clone this repository and change into the directory.

2. Run the `initial-setup.sh` (for Windows `initial-setup.ps1`) command and
   answer the questions. You can press enter to use the default values it 
   suggest.

   NOTE: On Windows, its a good idea to logout and then back in before 
         proceeding, or just restart your PC. Though it should not be 
         necessary, it is recommended.

3. Open a new terminal; on windows make sure its Powershell.

   NOTE: This will not work in a cmd.exe terminal most of the time.

4. Run the command `webenv up -c alpine-apps -n alpine-apps`, then wait and watch.

   NOTE: Your waiting for the docker images to download and start running.
         Again, if this command fails for you, you may need to logout and then log
         back into you account in order for the environment variables that the
         initial-setup command added to your user profile to take effect.

5. Verify that the environment is working on your PC by going to 
   "https://127.0.0.1/" in a web browser. If that loads the default NGinX page
   then you are ready to move on to the next step.

Next, you should review the [Command Reference](command-reference.md) manual.