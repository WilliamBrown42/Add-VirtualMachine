<#
# Make admin test a function of some sort? 
# Validate input? - look up how to do this. 
# Error handling? 
# export VMs to template from existing VMs
# Pipeline?
# Figure out help?
# JSON tiers - figure out rought schema
# Powershell version test?
# Maybe make it where there's a novhd version? 
# Better varible names -- need this for sure.
# Figure out if thing should be function-iffied
# Use exact names and be consistent
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
        [Switch]$CSV,
        [string]$CSVpath,
        [switch]$Tiers
)

<#
#>
begin{
    # Module test? #

    # Admin Test #
    If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] “Administrator”)){
        Write-Warning “You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!`nPress any key to continue..."
        $trigger = $true
    }
    
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
    if ($CSV){
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
            # Extended schema start here? #
            <#
            $NewVM | Add-Member -type NoteProperty -name 
            $NewVM | Add-Member -type NoteProperty -name
            $NewVM | Add-Member -type NoteProperty -name
            $NewVM | Add-Member -type NoteProperty -name
            $NewVM | Add-Member -type NoteProperty -name
            #>
            $VMInformation += $NewVM
        }
    } else {
        # Maybe look into setting up params to indicate how many at each tier and how many total or something there abouts?
        do {
            [int]$VMAmount = Read-Host -Prompt "How many machines are you creating?"
        } while (!($VMAmount -is [int]))
            
        if ($tiers){
            # Fix tiers + figure out how to add to array #
            # Write this so that it could be used with .ini, .psd, .xml, and all kinds of others. 
            # Rewrite not to use get content? 
            # $Tiers = Get-Content "$script_path\Tiers.json" | Out-String | ConvertFrom-Json
            $VMInformation += $NewVM
        } else {
            # fix this conditional #
            for ($increment = 1; $increment -le $VMAmount; $increment++){
                # I need to figure out how I want to format the output for some of these. 
                do { 
                    $Name = Read-Host -prompt "Name" 
                } while ($Name -ne $stuffs)
                # Should only allow an integer that is equiv to the max allowable #
                    do { [int]$Memory = Read-Host -prompt "Memory" 
                } while (!($Memory -is [int]))
                    do { [int]$Generation = Read-Host -prompt "Generation" 
                } while ($Generation -ne "1" -or "2")
                # Should check path form maybe, need to come back to this one. #
                do { 
                    $VHDPath = Read-Host -prompt "VHDPath" 
                } while()
                # Basic Int - something about max disk size on where you are wanting to create it?
                do { 
                    [int]$VHDSize = Read-Host -prompt "VHDSize" 
                } while ()
                # Find what the rest of the boot option are because they seemed to have disappeared? 
                do { 
                    $BootDevice = Read-Host -prompt "BootDevice" 
                } while ($BootDevice -ne "VHD" -or "" -or "" -or "")
                # This might end up being more complicated than I had thought. #
                do { 
                    $SwitchName = Read-Host -prompt "SwitchName $foreach ($Switch in $(Get-VMSwitch)){ $Test2 += "$($Switch.name)"})" 
                } while ($SwitchName -ne $Stuff)
                do { 
                    $VMPath = Read-Host -prompt "VMPath" 
                } while ()

                $VM = New-Object -TypeName PSCustomObject
                $VM | Add-Member -type NoteProperty -name Name -value $Name
                $VM | Add-Member -type NoteProperty -name Memory -value $Memory
                $VM | Add-Member -type NoteProperty -name Generation -value $Generation
                $VM | Add-Member -type NoteProperty -name VHDPath -value $VHDPath
                $VM | Add-Member -type NoteProperty -name VHDSize -value $VHDSize
                $VM | Add-Member -type NoteProperty -name BootDevice -value $BootDevice
                $VM | Add-Member -type NoteProperty -name SwitchName -value $SwitchName
                $VM | Add-Member -type NoteProperty -name VMPath -value $VMPath
                $VMInformation += $NewVM
            }
        }
    }
}

<#
Once input has been validated and all is well start creating the vms.
#>
process{
    # Find where to export the CSV
    #$VMInformation | Export-Csv -Path "C:\test\test.csv" -Delimiter ","
    foreach ($NewVM in $VMInformation){        
        # Take out VHD maybe and put it in set VM? #
        New-VM -Name "$($NewVM.Name)" `
               -MemoryStartupBytes "$($NewVM.MemoryStartupBytes)" `
               -Generation "$($NewVM.Generation)" `
               -NewVHDPath "$($NewVM.VHDPath)" `
               -NewVHDSizeBytes "$($NewVM.VHDSize)" `
               -BootDevice "$($NewVM.BootDevice)" `
               -SwitchName "$($NewVM.SwitchName)" `
               -Path "$($NewVM.VMPath)" `
               -WhatIf `
               #-ErrorAction SilentlyContinue
        [int]$PercentComplete = ((($increment++)/$VMInformation.length)*100)
        Write-Progress -Activity "Creating your VM's" `
                       -PercentComplete  $PercentComplete `
                       -CurrentOperation "$PercentComplete% Complete" `
                       -Status "Please Wait..."
    }

    # Options for setting the VMs settings, provide an extended Schema? #
    # If statement for setting the information here? #
    <#
    foreach ($NewVM in $VMInformation){
        if (){
            Set-VM -Name "$($NewVM.Name)" `
                    [-GuestControlledCacheTypes <bool>] `
                    [-LowMemoryMappedIoSpace <uint32>] `
                    [-HighMemoryMappedIoSpace <uint64>] `
                    [-ProcessorCount <long>] `
                    [-StaticMemory] `
                    [-DynamicMemory] `
                    [-MemoryMinimumBytes <long>] `
                    [-MemoryMaximumBytes <long>] `
                    #[-MemoryStartupBytes <long>] `
                    [-AutomaticStartAction <StartAction> {Nothing | StartIfRunning | Start}] `
                    [-AutomaticStopAction <StopAction> {TurnOff | Save | ShutDown}] `
                    [-AutomaticStartDelay <int>] `
                    [-AutomaticCriticalErrorAction <CriticalErrorAction> {None | Pause}] `
                    [-AutomaticCriticalErrorActionTimeout <int>] `
                    [-LockOnDisconnect <OnOffState> {On | Off}] `
                    [-Notes <string>] `
                    [-NewVMName <string>] `
                    [-SnapshotFileLocation <string>] `
                    [-SmartPagingFilePath <string>] `
                    [-CheckpointType <CheckpointType> {Disabled | Production | ProductionOnly | Standard}] `
                    [-Passthru] `
                    [-AllowUnverifiedPaths] `
                    [-WhatIf] `
                    [-Confirm]  `
                    [<CommonParameters>] `
        } else {
        }
    }
    #>
}

<#
#>
end{
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
#>