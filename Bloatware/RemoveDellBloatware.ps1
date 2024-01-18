# Remove Microsoft & Dell bloatware
# Original file https://gist.github.com/mark05e/a79221b4245962a477a49eb281d97388#file-remove-hpbloatware-ps1 
# modified by Robin Stanley (https://github.com/boffnoff)

# Create a tag file just so Intune knows this was installed
if (-not (Test-Path "$($env:ProgramData)\Dell\RemoveDellBloatware"))
{
    Mkdir "$($env:ProgramData)\Dell\RemoveDellBloatware"
}
Set-Content -Path "$($env:ProgramData)\Dell\RemoveDellBloatware\RemoveDellBloatware.ps1.tag" -Value "Installed"

# Start logging
Start-Transcript "$($env:ProgramData)\Dell\RemoveDellBloatware\RemoveDellBloatware.log"
# List of built-in apps to remove
$UninstallPackages = @(
    "Clipchamp.Clipchamp"
    "Microsoft.3DBuilder"
    "Microsoft.BingNews"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.SkypeApp"
    "Microsoft.WindowsFeedbackHub"
    "MicrosoftCorporationII.MicrosoftFamily"
    "MicrosoftTeams"
    "Microsoft.GamingApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.YourPhone"
    "DellInc.DellOptimizer"
    "DellInc.DellDigitalDelivery"
    "DellInc.DellSupportAssistforPCs"
    "DellInc.DellPowerManager"
    "DellInc.PartnerPromo"
)

# List of programs to uninstall
$UninstallPrograms = @(
    "Dell ControlVault Host Components Installer 64 bit"
    "Dell Optimizer Service"
    "Dell Power Manager Service"
    "Dell SupportAssist"
    "Dell SupportAssist Remediation"
    "Dell SupportAssist OS Recovery Plugin for Dell Update"
)


$InstalledPackages = Get-AppxPackage -AllUsers | Where {($UninstallPackages -contains $_.Name)}

$ProvisionedPackages = Get-AppxProvisionedPackage -Online | Where {($UninstallPackages -contains $_.DisplayName)}

$InstalledPrograms = Get-Package | Where {$UninstallPrograms -contains $_.Name}

# Remove provisioned packages first
ForEach ($ProvPackage in $ProvisionedPackages) {

    Write-Host -Object "Attempting to remove provisioned package: [$($ProvPackage.DisplayName)]..."

    Try {
        $Null = Remove-AppxProvisionedPackage -PackageName $ProvPackage.PackageName -Online -ErrorAction Stop
        Write-Host -Object "Successfully removed provisioned package: [$($ProvPackage.DisplayName)]"
    }
    Catch {Write-Warning -Message "Failed to remove provisioned package: [$($ProvPackage.DisplayName)]"}
}

# Remove appx packages
ForEach ($AppxPackage in $InstalledPackages) {
                                            
    Write-Host -Object "Attempting to remove Appx package: [$($AppxPackage.Name)]..."

    Try {
        $Null = Remove-AppxPackage -Package $AppxPackage.PackageFullName -AllUsers -ErrorAction Stop
        Write-Host -Object "Successfully removed Appx package: [$($AppxPackage.Name)]"
    }
    Catch {Write-Warning -Message "Failed to remove Appx package: [$($AppxPackage.Name)]"}
}

# Remove installed programs
$InstalledPrograms | ForEach {

    Write-Host -Object "Attempting to uninstall: [$($_.Name)]..."

    Try {
        $Null = $_ | Uninstall-Package -AllVersions -Force -ErrorAction Stop
        Write-Host -Object "Successfully uninstalled: [$($_.Name)]"
    }
    Catch {Write-Warning -Message "Failed to uninstall: [$($_.Name)]"}
}

Stop-Transcript