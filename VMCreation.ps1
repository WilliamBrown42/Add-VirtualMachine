<#
# Validate input? - look up how to do this. 
# Error handling? 
# I should make this where it can easily be re-written to avoid using read-host maybe be by csv? 
# export VMs to template?
# Pipeline and CSV?
# Figure out help?
# JSON tiers
# Powershell version test
# Maybe make it where there's a novhd version?
#>


<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>

[CmdletBinding()]param(
)

<#
#>
begin{
 
    # Admin Test, edit this further? #
    If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] “Administrator”)){
        Write-Warning “You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator! `nPress any key to continue..."

        [void][System.Console]::ReadKey($true)
        Break
    }

    # Some way to segment this off for when a CSV or something is used? # 
    # Gather amount? Need input validation? also param? #
    $VMAmount = Read-Host -Prompt "How many Machines are you creating?"

    # Array of VM informatin to be obtained in loop below. #
    $VMInformation = @()

    for ($increment = 1; $increment -eq $VMAmount; $increment++){  
        # fix this conditional #
        if ($tiers){
            # Fix tiers + figure out how to add to array #
            # Write this so that it could be used with .ini, .psd, .xml, and all kinds of others.  
            #$apps = Get-Content "$script_path\apps.json" | Out-String | ConvertFrom-Json
            $VMInformation += $VM
        } else {
            # Input #
            # Need to figure out some kind of way to deal with spaces in input? #
            # Figure out how to convert Read-Host of memory/size values to ints. #
            $VM = New-Object -TypeName PSCustomObject
            $VM | Add-Member -type NoteProperty -name Name -value (Read-Host -prompt "Name")
            $VM | Add-Member -type NoteProperty -name Memory -value (Read-Host -prompt "Memory")
            $VM | Add-Member -type NoteProperty -name Generation -value (Read-Host -prompt "Generation")
            $VM | Add-Member -type NoteProperty -name VHDPath -value (Read-Host -prompt "VHDPath")
            $VM | Add-Member -type NoteProperty -name VHDSize -value (Read-Host -prompt "VHDSize")
            $VM | Add-Member -type NoteProperty -name BootDevice -value (Read-Host -prompt "BootDevice")
            $VM | Add-Member -type NoteProperty -name SwitchName -value (Read-Host -prompt "SwitchName")
            $VM | Add-Member -type NoteProperty -name VMPath -value (Read-Host -prompt "VMPath")

            # Old Method, less compact but might be easier to see what it is doing and add in additions #
            <# 

            $Name = Read-Host -prompt "Name"
            $Memory = Read-Host -prompt "Memory"
            $Generation = Read-Host -prompt "Generation"
            $VHDPath = Read-Host -prompt "VHDPath"
            $VHDSize = Read-Host -prompt "VHDSize"
            $BootDevice = Read-Host -prompt "BootDevice"
            $SwitchName = Read-Host -prompt "SwitchName"
            $VMPath = Read-Host -prompt "VMPath"
        
            # Better way of dealing with custom objects? #
            # Creating Custom Object #
            $VM = New-Object -TypeName PSCustomObject
            $VM | Add-Member -type NoteProperty -name Name -value $Name
            $VM | Add-Member -type NoteProperty -name Memory -value $Memory
            $VM | Add-Member -type NoteProperty -name Generation -value $Generation
            $VM | Add-Member -type NoteProperty -name VHDPath -value $VHDPath
            $VM | Add-Member -type NoteProperty -name VHDSize -value $VHDSize
            $VM | Add-Member -type NoteProperty -name BootDevice -value $BootDevice
            $VM | Add-Member -type NoteProperty -name SwitchName -value $SwitchName
            $VM | Add-Member -type NoteProperty -name VMPath -value $VMPath

            #>

            # Adding to array #
            $VMInformation += $VM
        }
    }

}

<#
#>
process{

    # Once input has been validated and all is well start creating the vms.
    foreach ($VM in $VMInformation){
        # Spaces in input break this. Should only need the thingy for paths but putting it on other for safety #
        New-VM -Name "$($VM.Name)" -MemoryStartupBytes "$($VM.Memory)" -Generation "$($VM.Generation)" -NewVHDPath "$($VM.VHDPath)" -NewVHDSizeBytes "$($VM.VHDSize)" -BootDevice "$($VM.BoodDevice)" -SwitchName "$($VM.SwitchName)" -Path "$($VM.VMPath)" -WhatIf
        
        # New Method? #
        <#

        New-VM -Name "$($VM.Name)" `
               -MemoryStartupBytes "$($VM.Memory)" `
               -Generation "$($VM.Generation)" `
               -NewVHDPath "$($VM.VHDPath)" `
               -NewVHDSizeBytes "$($VM.VHDSize)" `
               -BootDevice "$($VM.BoodDevice)" `
               -SwitchName "$($VM.SwitchName)" `
               -Path "$($VM.VMPath)" `
               -WhatIf

        #>
    }

}

<#
#>
end{
    <#
    Get-VM 
    
    if (){
        Write-Output "success" 
    } else {
        Write-Output "Not success" 
    }
    #>
}


# Spare code #
<#
#-Version <version>] [-AsJob] [-CimSession <CimSession[]>] [-ComputerName <string[]>] -Credential <pscredential[]>] -WhatIf -Confirm  [<CommonParameters>]
#New-VM -Name <string> -MemoryStartupBytes <long> -Generation] {1 | 2} -NewVHDPath <string> -NewVHDSizeBytes <uint64> -BootDevice <BootDevice> {Floppy | CD | IDE 
#    | LegacyNetworkAdapter | NetworkAdapter | VHD}] -SwitchName <string> -Path <string> -Version <version>] [-AsJob] [-CimSession <CimSession[]>] [-ComputerName <string[]>] -Credential <pscredential[]>] -WhatIf -Confirm  [<CommonParameters>]

do {

} while ($trigger -ne $true)


"Foo $($bar.Property)" should fix input spaces breaking


if (($PSVersionTable -eq $null) -or (($PSVersionTable.PSVersion | Select-Object Major).Major -lt 4))
{
    if (-not (Test-Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'))
    {
        Write-Output ""
        Write-Warning "Please upgrade to .NET Framework v4.5"
        Write-Output "","http://www.microsoft.com/en-us/download/details.aspx?id=30653",""
    }
    Write-Output ""
    Write-Warning "Please upgrade to Powershell v4.0"
    Write-Output "","http://www.microsoft.com/en-us/download/details.aspx?id=40855",""
    exit
}

 # Param1 help description
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateCount(0,5)]
        [ValidateSet("sun", "moon", "earth")]
        [Alias("p1")] 
        $Param1,



#>

