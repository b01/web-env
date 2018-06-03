$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "$DIR\utilities.ps1"

printf "CWD = ${DIR}`n"

# Copy all applications nginx files into the mapped NginX vhost configuration directory.
printf "Copying NginX configs over to mapped conatiner directory.`n"
cp -v ~\code\*\web-env\*.conf ~\code\nginx-confs\

printf "Restarting NginX service.`n"
docker exec centos-nginx nginx -s reload