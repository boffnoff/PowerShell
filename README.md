# PowerShell
PowerShell deployment scripts







<details>
  <summary>Create shortcut with custom icon</summary><br>
  
  $WshShell = New-Object -comObject WScript.Shell ; $Shortcut = $WshShell.CreateShortcut("C:\\Users\\public\\Desktop\\test.url") ; $Shortcut.TargetPath = "https://test.ox.ac.uk/home"
<br>
$Shortcut.Save() ; Add-Content -Path "C:\\Users\\public\\Desktop\\test.url" -Value "IconFile=C:\Windows\System32\shell32.dll" ; Add-Content -Path "C:\\Users\\public\\Desktop\\test.url" -Value "IconIndex=43" ; $Shortcut.Save()

</details>




<details>
  <summary>Upload files to Sharepoint</summary><br>
  
  net use r: https://gdsto365.sharepoint.com/sites/XXX/General%20Share/  user:uk\boffnoff 
  <br>
  copy "C:\Users\Boffnoff\Downloads\test.txt" r:\somefile.txt
</details>


<details>
  <summary>Check running service on entire OU</summary><br>
  
  Get-ADComputer -Filter * -SearchBase "OU=RHS-IT1,OU=RHS-Senior,OU=RHS-Computers,OU=RHSB,OU=Schools,DC=uk,DC=gdst" | 
    Select-Object -ExpandProperty Name | 
    ForEach-Object {
        $computerName = $_
        Invoke-Command -ComputerName $computerName -ScriptBlock {
           Get-Service -Name 'wuauserv' | Select-Object -Property PSComputerName, Status
        }
    } | sort-object PSComputerName
</details>



<details>
  <summary>Get AD Description for specific PC</summary><br>

Get-ADComputer -Identity "XX-XX-0005" -Properties * | select-object CN,Description  


</details>




<details>
  <summary>List updates on selected PCs</summary><br>
  
  $results = invoke-command -computername rhs-wv-0030, rhs-wv-0005 -scriptblock {Get-WmiObject -Namespace "root\ccm\clientsdk" -Class CCM_SoftwareUpdate | Select-Object ArticleID, Name} -credential uk\rhsadmin10
  <br>
  $results | select-object PSComputerName, ArticleID, Name | sort-object PSComputerName
</details>



<details>
  <summary>Sort all PCs in OU alphabetically</summary><br>

  Get-ADComputer -Filter * -SearchBase "OU=RHS-IT1,OU=RHS-Senior,OU=RHS-Computers,OU=RHSB,OU=Schools,DC=uk,DC=gdst" | select-object Name | sort-object Name

- Or use the following to filter by name within the OU

  Get-ADComputer -Filter 'Name -like "*WT*" -SearchBase "etc..."

</details>

















































<details>
  <summary>Bitlocker Domain USB un-lock</summary><br>
  
- Setup Bitlocker to auto-unlock for specific domain group/user: (where X is USB drive)
  
Add-BitLockerKeyProtector -MountPoint "X:" ` -ADAccountOrGroup "uk\rhsadmin10" -ADAccountOrGroupProtector

- Find out who is currently assigned to that USB:

manage-bde -protectors -get "X:" -Type Identity

</details>



<details>
  <summary>SCCM Software Centre Updates</summary><br>
  
- list update article and name
  
Get-WmiObject -Namespace "root\ccm\clientsdk" -Class CCM_SoftwareUpdate | Select-Object     ArticleID, Name

- triggers installation

([wmiclass]'ROOT\ccm\ClientSDK:CCM_SoftwareUpdatesManager').InstallUpdates([System.Management.ManagementObject[]] (get-wmiobject -query 'SELECT * FROM CCM_SoftwareUpdate' -namespace 'ROOT\ccm\ClientSDK'))

</details>

<details>
  <summary>Create URL shortcut with custom icon</summary><br>
  
$WshShell = New-Object -comObject WScript.Shell ; $Shortcut = $WshShell.CreateShortcut("C:\\Users\\public\\Desktop\\Oxford-Admissions.url") ; $Shortcut.TargetPath = "https://admissionstesting.ox.ac.uk/candidates"
$Shortcut.Save() ; Add-Content -Path "C:\\Users\\public\\Desktop\\Online-test.url" -Value "IconFile=C:\Windows\System32\shell32.dll" ; Add-Content -Path "C:\\Users\\public\\Desktop\\Online-test.url" -Value "IconIndex=43" ; $Shortcut.Save()
</details>

<details>
  <summary>Enable/Disable Bitlocker</summary><br>
  
- Disable
  
@echo off
reg add "HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FVE" /V RDVDenyWriteAccess /T REG_DWORD /F /D 0

- Enable

@echo off
reg add "HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FVE" /V RDVDenyWriteAccess /T REG_DWORD /F /D 1

</details>

<details>
  <summary>Check PCs services + start</summary><br>
  
sc \\computername query winrm

OR set to auto startup

sc \\computer config winrm start=auto
</details>

<details>
  <summary>Uninstall apps</summary><br>
  
$readerdc= Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*Reader*"} ; $readerdc.Uninstall()
</details>

<details>
  <summary>Check installed apps on remote PC</summary><br>
  
$installedapps = Invoke-Command -ComputerName computer01 -Credential uk\USERNAME -ScriptBlock {Get-WmiObject -Class Win32_Product | select Name,Version} ; $installedapps | Out-GridView -Title "Installed Apps"
</details>

<details>
  <summary>Install WinGET</summary><br>
  
invoke-command -computername computer01, computer02 -scriptblock {Add-AppXPackage -Path https://github.com/microsoft/winget-cli/releases/download/v1.5.2201/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle} -credential uk\USERNAME
</details>

<details>
  <summary>Robocopy remote file</summary><br>
  
$Session = New-PSSession -ComputerName "computer01" -Credential "uk\USERNAME"
Copy-Item "Y:\test\folder\file.pdf" -Destination "C:\Users\USER\Desktop" -ToSession $Session

</details>


<details>
  <summary>Set SCCM Business hours</summary><br>
  
Invoke-WmiMethod -Class CCM_ClientUXSettings -Namespace "root\ccm\clientsdk" -Name SetBusinessHours -ArgumentList 16,8,62
</details>

<details>
  <summary>Enable auto install SCCM outside of hours</summary><br>
  
Invoke-WmiMethod -Namespace “Root\ccm\ClientSDK” -Class CCM_ClientUXSettings -Name SetAutoInstallRequiredSoftwaretoNonBusinessHours -ArgumentList @($TRUE)
</details>


<details>
  <summary>Fancy shutdown message</summary><br>
  
shutdown /s  /c "Dr.EVIL has initiated a remote restart on your computer"
</details>


<details>
  <summary>SANAKO student installer</summary><br>
  
sanako student installer

Start-Process -wait -FilePath "\\uk-rhs-vapps1\Applications\Sanako\v9.32\InstallPrerequisites.exe"
Start-Process msiexec.exe -Wait -ArgumentList '/I "\\uk-rhs-vapps1\Applications\Sanako\v9.32\KeyboardBlocker.msi" /norestart /quiet'
write-host student keyboard-blocker installed, sleeping 3
#wait 5
Start-Sleep -Seconds 3
Start-Process msiexec.exe -Wait -ArgumentList '/I "\\uk-rhs-vapps1\Applications\Sanako\v9.32\Student.msi" /norestart /quiet'
write-host student msi installed, sleeping 3
#wait 5
Start-Sleep -Seconds 3
Start-Process -FilePath "cmd.exe" -ArgumentList "/c reg.exe import `"\\uk-rhs-vapps1\Applications\Sanako\v9.32\Sanako Student.reg""" -Wait -passthru
write-host student registry keys imported, sleeping 3
#wait 5
Start-Sleep -Seconds 3
write-host student install complete! 
Start-Sleep -Seconds 2
Start-Process -wait -FilePath "C:\Program Files (x86)\Sanako\Study\Student\student.exe"

</details>


<details>
  <summary>Logoff users</summary><br>
  
quser
logoff 1 (where 1 is the user ID) 
You can get fancy and use PowerShell sessions
Invoke-Command -Session $IT1 -ScriptBlock {logoff 1}
</details>

<details>
  <summary>Access NAS / fileserver (PS Drive)</summary><br>
  
create new-psdrive
new-PSDrive -Name "vapps1" -PSProvider "FileSystem" -Root "\\servername\share\folder\"
</details>


<details>
  <summary>PowerShell Session (group PCs with credentials)</summary><br>
  
$regstatus = @{
  ComputerName = 'computer01', 'computer02', 'computer03'
  ConfigurationName = 'MySession.PowerShell'
  ScriptBlock       = { get-service remoteregistry }
}
Invoke-Command @regstatus -credential domain\user | out-gridview
</details>


# macOS
macOS scripts

<details>
  <summary>Check macOS version</summary><br>
  sw_vers
</details>

<details>
  <summary>Logoff users</summary><br>
 sudo pkill loginwindow
</details>

<details>
  <summary>Chcek for softwareupdate (and reboot to install)</summary><br>
 sudo softwareupdate -i -a -R
</details>

<details>
  <summary>Facny popup for users</summary><br>
 osascript -e 'display alert "Update macOS" message "Please update macOS software NOW - Dr.EVIL"'
</details>
