## Summary
A tool to automate setting up a standard web development environment; written 
in shell scripts and based on visualization technology. 

## Description
This tool currently uses Docker to spin up containers to compose a web
development environment. The advantage of this tool is to quickly setup a new
computer with an application (that is 
[configured with WebEnv](./docs/how-to-setup-an-app.md)) and begin developing
in less than 10 minutes (or 1 hour if you need to install Docker).

This requires that the images the containers are based on, have all the
necessary software pre-installed and will allow the application to run
smoothly. You should only need to install Docker, Git, and set some environment 
variables in order to use this tool on your computer.

### Requirements
* Docker v18+
* Git v2+
* Mac OS X (v10.12.6) with Terminal (v2.7.3) / Windows 10 with PowerShell 5+

### How to use WebEnv
To get started see [How to Use WebEnv](./docs/index.md)