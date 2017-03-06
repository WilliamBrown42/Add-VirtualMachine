<# 
# Error handling? 
# Pipeline?
# Figure out help?
# Powershell version test?
# Better varible names -- need this for sure.
# Figure out if thing should be function-iffied
# Use exact names and be consistent
# Add in a thing for diff. disks
# Seperate input into another script all together?
# Enable whatif and whatnot
#>

<#
#>

[CmdletBinding()]param(
        [string]$VMConfigurationCSV
)

begin{
    # Module test? Hyper-V #
    <#
    if (!(Get-Module -ListAvailable -Name "Hyper-V")) {
        Write-Output "Module does not exist"
        # try, catch, blah here. 
    } 
    #>

    # Admin Test #
    If (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] “Administrator”)){
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


    # Split into multiple CSV's?
    # VM Config
    # Config specifics (Storage, networking?)
    $VMInformation = @()
    $ImportedCSV = Import-Csv "$VMConfigurationCSV" -Delimiter "," 
    foreach ($VM in $ImportedCSV){
        $NewVM = New-Object -TypeName PSCustomObject 
        $NewVM | Add-Member -type NoteProperty -name Name -value "$($VM.Name)"
        $NewVM | Add-Member -type NoteProperty -name MemoryStartupBytes -value "$($VM.MemoryStartupBytes)"
        $NewVM | Add-Member -type NoteProperty -name Generation -value "$($VM.Generation)"
        $NewVM | Add-Member -type NoteProperty -name BootDevice -value "$($VM.BootDevice)"
        $NewVM | Add-Member -type NoteProperty -name SwitchName -value "$($VM.SwitchName)"
        $NewVM | Add-Member -type NoteProperty -name VMPath -value "$($VM.Path)"
        # Set VM # 
        <#
        #$NewVM | Add-Member -type NoteProperty -name VHDPath -value "$($VM.NewVHDPath)"
        #$NewVM | Add-Member -type NoteProperty -name VHDSize -value "$($VM.NewVHDSizeBytes)"
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
        $VMConfiguration += $NewVM
    }
    # Look up how to add objects to eachother or keep this the same?
    $VMStorageConfiguration = @()
    $ImportedCSV = Import-Csv "$StorageConfigurationCSV" -Delimiter "," 
    foreach ($VM in $ImportedCSV){
        $StorageConfiguration = New-Object -TypeName PSCustomObject 
        $StorageConfiguration | Add-Member -type NoteProperty -name Name -value "$($VM.Name)"
        $StorageConfiguration | Add-Member -type NoteProperty -name Name -value ""
        $StorageConfigurationCSV | Add-Member -type NoteProperty -name Name -value ""
        $VMStorageConfiguration += $StorageConfiguration
    }
} 

process{
    
    # Initial VM creation
    foreach ($NewVM in $VMConfiguration){
        # Specify it without a Switch name?
        # Need to look at how I can pass it in non-byte form. 
        # Boot device for network installs?
        New-VM -Name "$($NewVM.Name)" `
               -MemoryStartupBytes "$($NewVM.MemoryStartupBytes)" `
               -Generation "$($NewVM.Generation)" `
               -BootDevice `
               -NoVHD `
               -SwitchName "$($NewVM.SwitchName)" `
               -Path "$($NewVM.VMPath)" `
               -WhatIf `
               #-ErrorAction SilentlyContinue 
        [int]$PercentComplete = ((($increment++)/$VMConfiguration.length)*100)
        Write-Progress -Activity "Creating your VM's..." `
                       -PercentComplete  $PercentComplete `
                       -CurrentOperation "$PercentComplete% Complete" `
                       -Status "Please Wait..."
    }

    # Confirm that each VM actually exists before setting, settings. 
    foreach ($NewVM in $VMConfiguration) {
        Get-VM $NewVM.name 
    }
    
   
    if ($Configure -eq "1"){
        foreach ($NewVM in $VMConfiguration){

            if ($BootDrive){
                if ($differencing){
                    New-VHD –Path “$NewDrivePath” –ParentPath "$SysprepedDrive” –Differencing
                    Add-VMHardDiskDrive -VMName $VMName `
                                        -Path $NewDrivePath `
                                        -ControllerType $controllertype `
                                        -ControllerNumber $controllernumber 
                    $BootDrive = Get-VMHardDiskDrive -VMName $VMName `
                                                     -ControllerType $controllertype `
                                                     -ControllerNumber $controllernumber
                    Set-VMFirmware -VMName $VMName -FirstBootDevice $BootDrive
                } elseif ($Copy){
                    Copy-Item -Path "$SysprepedDrive" -Destination "$NewDrivePath"
                    Add-VMHardDiskDrive -VMName $VMName `
                                        -Path $NewDrivePath `
                                        -ControllerType $controllertype `
                                        -ControllerNumber $controllernumber 
                    $BootDrive = Get-VMHardDiskDrive -VMName $VMName `
                                                     -ControllerType $controllertype `
                                                     -ControllerNumber $controllernumber
                    Set-VMFirmware -VMName $VMName -FirstBootDevice $BootDrive
                } elseif ($NewDrive){
                    if ($Dynamic){
                        New-VHD -Path `
                                -SizeBytes `
                                -Dynamic
                    } else {
                        New-VHD -Path `
                                -SizeBytes `
                                -Fixed
                    }
                }
            }

            if ($Storage){
                # For additional each Disk in the collection
                Foreach ($Disk in $ExtraDrive){
                    if ($Dynamic){
                        New-VHD -Path `
                                -SizeBytes `
                                -Dynamic
                    } else {
                        New-VHD -Path `
                                -SizeBytes `
                                -Fixed
                    }
                    # Attach the VHD(x) to the Vm
                    Add-VMHardDiskDrive -VMName $VMName `
                                        -Path 
                }
            }
            

            if ($startup){
                Write-Progress -Activity "Configuring automatic start/stop actions..." `
                               -PercentComplete  $PercentComplete `
                               -CurrentOperation "$PercentComplete% Complete" `
                               -Status "Please Wait..."
                Set-VM -Name `
                       -AutomaticStartAction `
                       -AutomaticStartDelay `
                       -AutomaticStopAction 
            }
                  
            if ($Memory -eq 1){
                if ($Dynamic -eq 1){
                    Write-Progress -Activity "Configuring memory..." `
                                   -PercentComplete  $PercentComplete `
                                   -CurrentOperation "$PercentComplete% Complete" `
                                   -Status "Please Wait..."
                    Set-VM -Name  `
                           -DynamicMemory `
                           -MemoryMinimumBytes  `
                           -MemoryStartupBytes  `
                           -MemoryMaximumBytes `
                } else {
                    Write-Progress -Activity "Configuring memory..." `
                                   -PercentComplete  $PercentComplete `
                                   -CurrentOperation "$PercentComplete% Complete" `
                                   -Status "Please Wait..."
                    Set-VM -Name  `
                           -StaticMemory `
                           -MemoryStartupBytes  `
                }
            }
            
            if ($compute){
                Set-VM -Name `
                       -ProcessorCount 
            } 

            if ($Networking){
            }
            
              
            [int]$PercentComplete = ((($increment++)/$VMConfiguration.length)*100)
            Write-Progress -Activity "$VMNAME is fully configured" `
                           -PercentComplete  $PercentComplete `
                           -CurrentOperation "$PercentComplete% Complete" `
                           -Status "Please Wait..."
                           Start-Sleep 1
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