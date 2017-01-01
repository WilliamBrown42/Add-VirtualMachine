<#
Make admin test a function of some sort? 
# Validate input? - look up how to do this. 
# Error handling? 
# I should make this where it can easily be re-written to avoid using read-host maybe be by csv? 
# export VMs to template from existing VMs
# Pipeline and CSV?
# Figure out help?
# JSON tiers - figure out rought schema
# Powershell version test
# Maybe make it where there's a novhd version?
# Better varible names
# Figure out if thing should be function-iffied
# Use exact names
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
        [Switch]$csv,
        [string]$CSVpath
)

<#
#>
begin{


    # Version Test #
    # need to look further into what is really required for this. # 
    <#
    if (($PSVersionTable -eq $null) -or (($PSVersionTable.PSVersion | Select-Object Major).Major -lt 4)){
        if (-not (Test-Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full')){
            Write-Output ""
            Write-Warning "Please upgrade to .NET Framework v4.5"
            Write-Output "","http://www.microsoft.com/en-us/download/details.aspx?id=30653",""
        }
        Write-Output ""
        Write-Warning "Please upgrade to Powershell v4.0"
        Write-Output "","http://www.microsoft.com/en-us/download/details.aspx?id=40855",""
    }
    #>

    # Better way to do this? #
    if ($trigger -eq $true){
        [void][System.Console]::ReadKey($true)
        Break
    }
       
    $VMInformation = @()
    # CSV use #
    if ([switch]$CSV){
        $ImportedCSV = Import-Csv "$CSVPath" -Delimiter "," 
        foreach ($VM in $ImportedCSV){
            $NewVM = New-Object -TypeName PSCustomObject 
            $NewVM | Add-Member -type NoteProperty -name Name -value "$($VM.Name)"
            $NewVM | Add-Member -type NoteProperty -name MemoryStartupBytes -value "$($VM.MemoryStartupBytes)"
            $NewVM | Add-Member -type NoteProperty -name Generation -value "$($VM.Generation)"
            $NewVM | Add-Member -type NoteProperty -name VHDPath -value "$($VM.NewVHDPath)"
            $NewVM | Add-Member -type NoteProperty -name VHDSize -value "$($VM.NewVHDSizeBytes)"
            $NewVM | Add-Member -type NoteProperty -name BootDevice -value "$($VM.BootDevice)"
            $NewVM | Add-Member -type NoteProperty -name SwitchName -value "$($VM.SwitchName)"
            $NewVM | Add-Member -type NoteProperty -name VMPath -value "$($VM.Path)"
            $VMInformation += $NewVM
        }
    } else {
 
        <# 
        Gather amount? Need input validation? also param?
        Maybe look into setting up params to indicate how many at each tier and how many total or something
        There abouts?
        #>
        $VMAmount = Read-Host -Prompt "How many machines are you creating?"

        # fix statement #
        for ($increment = 1; $increment -le $VMAmount; $increment++){  
            # fix this conditional #
            if ($tiers){
                # Fix tiers + figure out how to add to array #
                # Write this so that it could be used with .ini, .psd, .xml, and all kinds of others.  
                # $Tiers = Get-Content "$script_path\Tiers.json" | Out-String | ConvertFrom-Json
                $VMInformation += $NewVM
            } else {
                # Input loop to confirm plus counter#
                # Need to figure out some kind of way to deal with spaces in input? #
                # Figure out how to convert Read-Host of memory/size values to ints. Type casting. #

                Write-Output "Please input the options for VM #$increment`n"

                # Make this entire thing a function ? #
                $NewVM = New-Object -TypeName PSCustomObject
                $NewVM | Add-Member -type NoteProperty -name Name -value (Read-Host -prompt "Name")
                $NewVM | Add-Member -type NoteProperty -name MemoryStartupBytes -value (Read-Host -prompt "Memory")
                $NewVM | Add-Member -type NoteProperty -name Generation -value (Read-Host -prompt "Generation")
                $NewVM | Add-Member -type NoteProperty -name VHDPath -value (Read-Host -prompt "VHDPath")
                $NewVM | Add-Member -type NoteProperty -name VHDSize -value (Read-Host -prompt "VHDSize")
                $NewVM | Add-Member -type NoteProperty -name BootDevice -value (Read-Host -prompt "BootDevice")
                $NewVM | Add-Member -type NoteProperty -name SwitchName -value (Read-Host -prompt "SwitchName")
                $NewVM | Add-Member -type NoteProperty -name VMPath -value (Read-Host -prompt "VMPath")
                $VMInformation += $NewVM
            }
        }
    }
}

<#
Once input has been validated and all is well start creating the vms.
#>
process{
    
    foreach ($NewVM in $VMInformation){        
        # Take out VHD maybe and put it in set VM? #
        #$Total = $VMInformation.length
        #$increment++
        [int]$PercentComplete = ((($increment++)/$VMInformation.length)*100)
        Write-Progress -Activity "Creating your VMs" `
                       -PercentComplete  $PercentComplete `
                       -CurrentOperation "$PercentComplete% percent complete" `
                       -Status "Please Wait"

        New-VM -Name "$($NewVM.Name)" `
               -MemoryStartupBytes "$($NewVM.MemoryStartupBytes)" `
               -Generation "$($NewVM.Generation)" `
               -NewVHDPath "$($NewVM.VHDPath)" `
               -NewVHDSizeBytes "$($NewVM.VHDSize)" `
               -BootDevice "$($NewVM.BootDevice)" `
               -SwitchName "$($NewVM.SwitchName)" `
               -Path "$($NewVM.VMPath)" `
               #-WhatIf `
               #-ErrorAction SilentlyContinue
        # Use the below if it doesn't add it naturally #
        #Write-Progress 
    }

    # Options for setting the VMs settings? #
    <#
    foreach ($NewVM in $VMInformation){
        Set-VM [-VM] <VirtualMachine[]> 
               [-GuestControlledCacheTypes <bool>] 
               [-LowMemoryMappedIoSpace <uint32>] [-HighMemoryMappedIoSpace <uint64>] 
               [-ProcessorCount <long>] [-DynamicMemory] [-StaticMemory] 
               [-MemoryMinimumBytes <long>] [-MemoryMaximumBytes <long>] 
               [-MemoryStartupBytes <long>] [-AutomaticStartAction <StartAction> {Nothing | StartIfRunning | Start}] 
               [-AutomaticStopAction <StopAction> {TurnOff | Save | ShutDown}] [-AutomaticStartDelay <int>] 
               [-AutomaticCriticalErrorAction <CriticalErrorAction> {None | Pause}] 
               [-AutomaticCriticalErrorActionTimeout <int>] [-LockOnDisconnect <OnOffState> {On | Off}] 
               [-Notes <string>] [-NewVMName <string>] 
               [-SnapshotFileLocation <string>] [-SmartPagingFilePath <string>] 
               [-CheckpointType <CheckpointType> {Disabled | Production | ProductionOnly | Standard}] 
               [-Passthru] 
               [-AllowUnverifiedPaths] 
               [-WhatIf] 
               [-Confirm]  
               [<CommonParameters>]
    }
    #>
}

<#
#>
end{
    <#
    foreach ($NewVM in $VMInformation){
    Get-VM $NewVM.Name
    }
    <#
    if (){
        Write-Output "success" 
    } else {
        Write-Output "Not success" 
    }
    #>
}



# Spare code #
<#
New-VM -Name "$($VM.Name)" -MemoryStartupBytes "$($VM.Memory)" -Generation "$($VM.Generation)" -NewVHDPath "$($VM.VHDPath)" -NewVHDSizeBytes "$($VM.VHDSize)" -BootDevice "$($VM.BoodDevice)" -SwitchName "$($VM.SwitchName)" -Path "$($VM.VMPath)" -WhatIf

Set-VM [-VM] <VirtualMachine[]> 
            [-GuestControlledCacheTypes <bool>] 
            [-LowMemoryMappedIoSpace <uint32>] [-HighMemoryMappedIoSpace <uint64>] 
            [-ProcessorCount <long>] [-DynamicMemory] [-StaticMemory] 
            [-MemoryMinimumBytes <long>] [-MemoryMaximumBytes <long>] 
            [-MemoryStartupBytes <long>] [-AutomaticStartAction <StartAction> {Nothing | StartIfRunning | Start}] 
            [-AutomaticStopAction <StopAction> {TurnOff | Save | ShutDown}] [-AutomaticStartDelay <int>] 
            [-AutomaticCriticalErrorAction <CriticalErrorAction> {None | Pause}] 
            [-AutomaticCriticalErrorActionTimeout <int>] [-LockOnDisconnect <OnOffState> {On | Off}] 
            [-Notes <string>] [-NewVMName <string>] 
            [-SnapshotFileLocation <string>] [-SmartPagingFilePath <string>] 
            [-CheckpointType <CheckpointType> {Disabled | Production | ProductionOnly | Standard}] 
            [-Passthru] 
            [-AllowUnverifiedPaths] 
            [-WhatIf] 
            [-Confirm]  
            [<CommonParameters>]

# Old Method, less compact but might be easier to see what it is doing and add in additions also easier to validate input? #
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
