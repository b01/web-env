#How to setup an application with the WebEnv tool

You'll need two files:

In your application make a new directory `web-env` and inside create a 
UTF-8.

Example structure:
```
web-env
|- my-nginx.conf
|- env-vars.txt 
```
**NOTICE:**
  * These files must use UTF-8 encoding and Linux line endings since they may
    be run on Linux/Mac/Windows.

## Adding an NGinX configuration

Take care in naming your NGinX configuration file as it has a small impact.
The first part of the NGinX configuration filename can serve two purposes.
In the example above `my-nginx.conf` "my" would be considered the "first-part."
It will also be used as the name for the domain of the SSL self-signed
certificate that WebEnv will generate each time it spins up the development
environment. The second purpose it to match it with the domain name that you
set in the host computers `hosts` file. This is done to keep things consistent
and help debug things when something goes wrong.

Take this example NGinX configuration named "my-nginx.conf"
```nginx

```