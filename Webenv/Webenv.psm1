function Use-Webenv
{
    process {
        $webEnvDir = "${APPS_DIR}\web-env"
        $short = $args[0]
        $cmdParams = ''

        if ($args.Length -gt 1) {
            $cmdParams = $args[1..($args.Length - 1)]
        }

        switch ($short)
        {
            'ca' {
                $command = 'config-app'
                Write-Verbose "mapping ca to config-app.`n"
                break
            }
            'cp' {
                $command = 'copies'
                Write-Verbose "mapping cp to copies.`n"
                break
            }
            'dn' {
                $command = 'stop'
                Write-Verbose "mapping dn to stop.`n"
                break
            }
            'up' {
                $command = 'start'
                Write-Verbose "mapping up to start.`n"
                break
            }
        }

        if ($command) {
            $script = "${webEnvDir}\${command}.ps1"
            Write-Verbose "Executing ${script}"
            Invoke-Expression "& `"${script}`" ${cmdParams}"
        } else {

        }
    }
}

function Get-IpString
{
    process {
        (Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"}).IPv4Address.IPAddress
    }
}

Set-Alias webenv Use-Webenv
Set-Alias getipstr Get-IpString

Export-ModuleMember -Function * -Alias 'webenv', 'getipstr'