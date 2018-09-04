function Use-Webenv
{
    process {
        $short = $args[0]
        $cmdParams = ''
        $thisModuleRoot = $MyInvocation.MyCommand.Module.ModuleBase
        . "${thisModuleRoot}\.env.ps1"
        #$WEB_ENV_DIR = Get-Content -Path "${thisModuleRoot}\.env.ps1"

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
            default {
                echo "Unknown command: ${short}. Please use one of the following:"
                echo ""
                Get-Content "${WEB_ENV_DIR}\help.md" | foreach {Write-Output $_}
            }
        }

        if ($command) {
            $script = "${WEB_ENV_DIR}\${command}.ps1"
            Write-Verbose "Executing ${script}"
            Invoke-Expression "& `"${script}`" ${cmdParams}"
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