## Summary
A tool to automate setting up a standard web development environment; written 
in shell scripts and based on visualization technology. 

## Description
This tool currently uses Docker to spin up containers to compose a web
development environment. The advantage of this tool is to quickly setup a new
computer with an application (that is 
[configured with WebEnv](./docs/how-to-setup-an-app.md)) and begin developing
in less that hour.

This requires that the images the containers are based on, have all the
necessary software pre-installed and will allow the application to run
smoothly. It should not be necessary to install anything on your host computer,
with the exception of Docker, to get an application setup locally so that 
you may begin developing quickly.  

### Requirements

* Docker 17+
* Mac OS X (v10.12.6) with Terminal (v2.7.3) / Windows 10 with PowerShell 

To get started see [How to Use Web Env](./docs/index.md)