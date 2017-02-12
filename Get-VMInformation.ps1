else {
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