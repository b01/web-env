$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "$DIR\utilities.ps1"

printf "CWD = ${DIR}`n"

$sshDir = (Resolve-Path -Path "~\.ssh").Path
echo "SSH dir: ${sshDir}"
# Copy SSH keys over to the containers.
if (Test-Path -Path "${sshDir}") {
    printf "copy ssh keys to apps54`n"
    docker cp "${sshDir}\\." centos-apps54:/root/.ssh

    printf "copy ssh keys to apps`n"
    docker cp "${sshDir}\\." centos-apps:/root/.ssh

    docker exec centos-apps54 chown -R root:root /root/.ssh/
    docker exec centos-apps chown -R root:root /root/.ssh/
    printf "done copying ssh keys to container.`n"
}

# Copy all applications nginx files into the mapped NginX vhost configuration directory.
printf "Copying NginX configs over to mapped conatiner directory.`n"
cp -v ~\code\*\web-env\*.conf ~\code\nginx-confs\

printf "Restarting NginX service.`n"
docker exec centos-nginx nginx -s reload

# Copy ~/gitconfig over to app containers.
$gitConfig = (Resolve-Path -Path "~/.gitconfig").Path

if (Test-Path -Path $gitConfig) {
    printf "copy ${gitConfig} to apps54...`n"
    docker cp "${gitConfig}" centos-apps54:/root/.gitconfig

    printf "copy ${gitConfig} to apps...`n"
    docker cp "${gitConfig}" centos-apps:/root/.gitconfig

    printf "Changing permissions on the files copied over...`n"
    docker exec centos-apps54 chown -R root:root /root/.gitconfig
    docker exec centos-apps chown -R root:root /root/.gitconfig
}