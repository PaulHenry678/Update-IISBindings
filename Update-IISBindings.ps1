

Function Update-IISBindings($ComputerName,$oldIP,$newIP)
{
    #IF(Get-WindowsFeature -ComputerName $computername -Name web-server | where {$_.installstate -like 'Installed'}){
    Invoke-Command -computername $computername -ScriptBlock {
    
    param($oldIP,$newIP)
    
    Import-Module WebAdministration
    $sites = (ls IIS:Sites)
    foreach ($site in $sites) 
    {
        $updateBinding = $false

        $siteName = "IIS:\Sites\" + $site.Name

        $bindings = (Get-ItemProperty -Path $siteName -Name Bindings)

        for ($i =0; $i -lt ($bindings.Collection).length; $i++) 

            {

            if ($bindings.Collection[$i].bindingInformation -match ($oldip + ":")) 
                {

                $updateBinding = $true

                $newBinding = $bindings.Collection[$i].bindingInformation -replace ($oldIP + ":"),($newIP + ":")

                $bindings.Collection[$i].bindingInformation = $newBinding

                }
            }
     if ($updateBinding) 
        {

        Set-ItemProperty -Path $siteName -Name Bindings -Value $bindings

        }
    }
    } -ArgumentList $oldIP,$newIP
    #}
    #ELSE
    #{
    #Write-Host "IIS is not installed on the target server"
    #}
    
}