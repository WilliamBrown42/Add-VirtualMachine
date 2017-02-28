<# 
# Error handling? 
# export VMs to template from existing VMs
# Pipeline?
# Figure out help?
# JSON tiers - figure out rought schema
# Powershell version test?
# Better varible names -- need this for sure.
# Figure out if thing should be function-iffied
# Use exact names and be consistent
# Add in a thing for diff. disks
# Seperate input into another script all together?
# Enable whatif and whatnot
#>

<#
.Synopsis
   A tool for automating virtual machine provisioning in Hyper-V. 
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
        [string]$CSVpath
)

<#
#>
begin{
    # Module test? #
    <#
    if (){
    }
    #>

    # Make admin test a function of some sort? 
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
        # Set VM # 
        <#
        $NewVM | Add-Member -type NoteProperty -name 
        $NewVM | Add-Member -type NoteProperty -name
        $NewVM | Add-Member -type NoteProperty -name
        $NewVM | Add-Member -type NoteProperty -name
        $NewVM | Add-Member -type NoteProperty -name
        $NewVM | Add-Member -type NoteProperty -name 
        $NewVM | Add-Member -type NoteProperty -name
        $NewVM | Add-Member -type NoteProperty -name
        $NewVM | Add-Member -type NoteProperty -name
        $NewVM | Add-Member -type NoteProperty -name
        #>
        $VMInformation += $NewVM
    }
} 

process{

    # Find where to export the CSV
    #$VMInformation | Export-Csv -Path "C:\test\test.csv" -Delimiter ","
    foreach ($NewVM in $VMInformation){        
        New-VM -Name "$($NewVM.Name)" `
               -MemoryStartupBytes "$($NewVM.MemoryStartupBytes)" `
               -Generation "$($NewVM.Generation)" `
               -NoVHD `
               -SwitchName "$($NewVM.SwitchName)" `
               -Path "$($NewVM.VMPath)" `
               -WhatIf `
               #-NewVHDPath "$($NewVM.VHDPath)" `
               #-NewVHDSizeBytes "$($NewVM.VHDSize)" `
               #-ErrorAction SilentlyContinue
        [int]$PercentComplete = ((($increment++)/$VMInformation.length)*100)
        Write-Progress -Activity "Creating your VM's..." `
                       -PercentComplete  $PercentComplete `
                       -CurrentOperation "$PercentComplete% Complete" `
                       -Status "Please Wait..."
    }

    # Confirm that each VM actually exists before setting, settings. 
    foreach ($NewVM in $VMInformation) {
        Get-VM $NewVM.name 
    }
    
    # Figure out a better way to handle this. 
    if ($SetVM -eq "True"){
        foreach ($NewVM in $VMInformation){
            <#
            Set-VM -Name "$($NewVM.Name)" `
                    [-GuestControlledCacheTypes <bool>] `
                    [-LowMemoryMappedIoSpace <uint32>] `
                    [-HighMemoryMappedIoSpace <uint64>] `
                    [-ProcessorCount <long>] `
                    [-StaticMemory] `
                    [-DynamicMemory] `
                    [-MemoryMinimumBytes <long>] `
                    [-MemoryMaximumBytes <long>] `
                    [-MemoryStartupBytes <long>] `
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
            #>
            [int]$PercentComplete = ((($increment++)/$VMInformation.length)*100)
            Write-Progress -Activity "Configuring VM Settings..." `
                           -PercentComplete  $PercentComplete `
                           -CurrentOperation "$PercentComplete% Complete" `
                           -Status "Please Wait..."
        }
    }
}

end{
    <#
    if (){
        Write-Output "success" 
    } else {
        Write-Output "Not success" 
    }
    #>
}