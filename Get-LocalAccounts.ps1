$LocalAdmins = [ADSI]"WinNT://$env:COMPUTERNAME/Administrators"
$LocalAdminUsers = $LocalAdmins.Invoke('Members') | % {
    $path = ([adsi]$_).path
    $Properties = @{
        Domain = $(Split-Path (Split-Path $path) -Leaf)
        User = $(Split-Path $path -Leaf)
    }
    New-Object psobject -Property $Properties
}

$LocalUsers = Get-LocalUser
$LocalUsersObj = @()

foreach($LocalUser in $LocalUsers)
{
    $Properties = @{
        Name = $LocalUser.name
        Enabled = $LocalUser.Enabled
        Description = $LocalUser.Description
    }
    $LocalUsersObj += New-Object psobject -Property $Properties
}

$ResultObj = @{}
$ResultObj.Add("LocalUsers",$LocalUsersObj)
$ResultObj.Add("LocalAdmins",$LocalAdminUsers)
$ResultObj | ConvertTo-Json -Compress
