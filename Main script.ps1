# Load the Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms

# Create a new form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Made with love - Robin Stanley"
$form.Size = New-Object System.Drawing.Size(650, 730)
$Form.FormBorderStyle = 'FixedDialog'
#stops window being fullscreened when clicking title bar
$form.MaximumSize = $form.Size
$form.MinimumSize = $form.Size
$form.StartPosition = "CenterScreen"

#sets background colour and disables minimise, maximise, close
$form.BackColor = '#f4f4f4'
$Form.ControlBox  = $false


#Create box to enter -computername variable
$computername = New-Object System.Windows.Forms.Label
$computername.Location = New-Object System.Drawing.Point(50, 50)
$computername.Size = New-Object System.Drawing.Size(100, 20)
$computername.Text = "Target PC:"
$form.Controls.Add($computername)



$computernameDropdown = New-Object System.Windows.Forms.ComboBox
$computernameDropdown.Location = New-Object System.Drawing.Point(150, 50)
$computernameDropdown.Size = New-Object System.Drawing.Size(200, 20)
$computernameDropdown.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$computernameDropdown.Items.Add("Enter a single computer name")
$computernameDropdown.Items.Add("Select a text file")
$form.Controls.Add($computernameDropdown)

$computernameTextbox = New-Object System.Windows.Forms.TextBox
$computernameTextbox.Location = New-Object System.Drawing.Point(150, 80)
$computernameTextbox.Size = New-Object System.Drawing.Size(200, 20)
$computernameTextbox.Enabled = $false
$form.Controls.Add($computernameTextbox)

# Add event handler for when an item is selected in the dropdown
$computernameDropdown.Add_SelectedIndexChanged({
    if ($computernameDropdown.SelectedIndex -eq 0) {
        $computernameTextbox.Enabled = $true
        $computernameTextbox.Text = ""
    } elseif ($computernameDropdown.SelectedIndex -eq 1) {
        $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $fileDialog.Title = "Select a text file containing computer names"
        $fileDialog.Filter = "Text files (*.csv)|*.csv"
        $fileDialog.Multiselect = $false
        $fileSelected = $fileDialog.ShowDialog()
        if ($fileSelected -eq [System.Windows.Forms.DialogResult]::OK) {
            $computernameTextbox.Text = Get-Content $fileDialog.FileName
            $computernameTextbox.Enabled = $false
        } else {
            $computernameDropdown.SelectedIndex = -1
        }
    }
})




# Create the login section
$usernameLabel = New-Object System.Windows.Forms.Label
$usernameLabel.Location = New-Object System.Drawing.Point(50, 20)
$usernameLabel.Size = New-Object System.Drawing.Size(100, 20)
$usernameLabel.Text = "Username:"
$form.Controls.Add($usernameLabel)

$usernameTextbox = New-Object System.Windows.Forms.TextBox
$usernameTextbox.Location = New-Object System.Drawing.Point(150, 20)
$usernameTextbox.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($usernameTextbox)

$passwordLabel = New-Object System.Windows.Forms.Label
$passwordLabel.Location = New-Object System.Drawing.Point(300, 20)
$passwordLabel.Size = New-Object System.Drawing.Size(100, 20)
$passwordLabel.Text = "Password:"
$form.Controls.Add($passwordLabel)

$passwordTextbox = New-Object System.Windows.Forms.TextBox
$passwordTextbox.Location = New-Object System.Drawing.Point(400, 20)
$passwordTextbox.Size = New-Object System.Drawing.Size(100, 20)
$passwordTextbox.PasswordChar = "*"
$form.Controls.Add($passwordTextbox)



# Create the login button and set its properties
$loginButton = New-Object System.Windows.Forms.Button
$loginButton.Location = New-Object System.Drawing.Point(550, 20)
$loginButton.Size = New-Object System.Drawing.Size(75, 20)
$loginButton.Text = "Login"
$loginButton.Add_Click({
    # Store the entered credentials in variables
    $global:computername = $computernameTextbox.Text
    $global:username = $usernameTextbox.Text
    $global:password = ConvertTo-SecureString -String $passwordTextbox.Text -AsPlainText -Force
    $global:credentials = New-Object System.Management.Automation.PSCredential ($username, $password)

    # Disable the login section and enable the buttons
    $usernameTextbox.Enabled = $false
    $passwordTextbox.Enabled = $false
    $loginButton.Enabled = $false
    $button1.Enabled = $true
    $button2.Enabled = $true
    $button3.Enabled = $true
    $button4.Enabled = $true
    $button5.Enabled = $true
    $button6.Enabled = $true
    $button7.Enabled = $true
    $button8.Enabled = $true
    $button9.Enabled = $true
    $button10.Enabled = $true
    $button11.Enabled = $true
    $button12.Enabled = $true
    $button13.Enabled = $true
    $button14.Enabled = $true
    $button15.Enabled = $true
    $button16.Enabled = $true
})

# Add the login button to the form
$form.Controls.Add($loginButton)





#create VAPPS PS-Drive
$credential = Get-Credential
$psdrive = @{
    Name = "PSDrive"
    PSProvider = "FileSystem"
     Root = "\\UK-rhs-vapps1\Applications"
    Credential = $credential
}



# Create the button and set its properties
$button1 = New-Object System.Windows.Forms.Button
$button1.Location = New-Object System.Drawing.Point(50, 100)
$button1.Size = New-Object System.Drawing.Size(100, 35)
$Button1.BackColor = '#CCCC99'
$button1.Text = "PC Language"
$button1.Enabled = $false
$button1.Add_Click({
    # Run the Invoke-Command cmdlet with the stored credentials
    $culture = Invoke-Command -ComputerName $global:computername -Credential $global:credentials -ScriptBlock {Get-Culture}

    # Display the output of the command in a popup
    [System.Windows.Forms.MessageBox]::Show($culture.ToString(), "Locale Information")
})

# Add the button to the form
$form.Controls.Add($button1)



# Create the other buttons

$button2 = New-Object System.Windows.Forms.Button
$button2.Location = New-Object System.Drawing.Point(200, 100)
$button2.Size = New-Object System.Drawing.Size(100, 35)
$button2.Text = "Get / Set BIOS boot order"
$button2.Enabled = $false
$button2.Add_Click({
    # Run the first command to get the BIOS settings list
    $SettingList = Get-WmiObject -Namespace root\wmi -Class Lenovo_BiosSetting -ComputerName $global:computername -Credential $global:credentials
    # Run the second command to select the CurrentSetting property of the BIOS settings list
    $CurrentSettings = $SettingList | Select-Object CurrentSetting
    # Run the third command to select the CurrentSetting property where it matches "bootorder*"
    $BootOrderSetting = $SettingList | Where-Object CurrentSetting -Like "bootorder*" | Select-Object -ExpandProperty CurrentSetting
    # Combine the output of the three commands into a single string
    $OutputString = "$CurrentSettings`n`n$BootOrderSetting"
    # Display the output of the commands in a popup
    [System.Windows.Forms.MessageBox]::Show($OutputString, "Lenovo BIOS Settings")
})
$form.Controls.Add($button2)

$button3 = New-Object System.Windows.Forms.Button
$button3.Location = New-Object System.Drawing.Point(350, 100)
$button3.Size = New-Object System.Drawing.Size(100, 35)
$button3.Text = "Motherboard"
$button3.Enabled = $false
$button3.Add_Click({
    # Run the Invoke-Command cmdlet with the stored credentials
    $motherboard = Invoke-Command -ComputerName $global:computername -Credential $global:credentials -ScriptBlock {get-WmiObject win32_baseboard | Select-Object Status}

    # Display the output of the command in a popup
    [System.Windows.Forms.MessageBox]::Show($motherboard.ToString(), "Motherboard Information")
})
# Add the button to the form
$form.Controls.Add($button3)


$button4 = New-Object System.Windows.Forms.Button
$button4.Location = New-Object System.Drawing.Point(500, 100)
$button4.Size = New-Object System.Drawing.Size(100, 35)
$button4.Text = "Restart Services"
$button4.Enabled = $false
$button4.Add_Click({
    # Run the Invoke-Command cmdlet with the stored credentials
    $services = Invoke-Command -ComputerName $global:computername -Credential $global:credentials -ScriptBlock {Get-Service | Select-Object Status, Name}
    $services | Out-GridView -Title "Select services to restart" -passthru | restart-service -verbose
})
$form.Controls.Add($button4)



$button5 = New-Object System.Windows.Forms.Button
$button5.Location = New-Object System.Drawing.Point(50, 150)
$button5.Size = New-Object System.Drawing.Size(100, 35)
$button5.Text = "Disk Info"
$button5.Enabled = $false
$button5.Add_Click({
    # Run the Invoke-Command cmdlet with the stored credentials
    $diskinfo = Invoke-Command -ComputerName $global:computername -Credential $global:credentials -ScriptBlock {Get-disk}

    # Display the output of the command in a popup
    [System.Windows.Forms.MessageBox]::Show($diskinfo.ToString(), "Disk Information")
})
$form.Controls.Add($button5)

$button6 = New-Object System.Windows.Forms.Button
$button6.Location = New-Object System.Drawing.Point(200, 150)
$button6.Size = New-Object System.Drawing.Size(100, 35)
$button6.Text = "Lenovo Update"
$button6.Enabled = $false
$button6.Add_Click({
   # Run the Invoke-Command cmdlet with the stored credentials
    $lenovoupdate = Invoke-Command -ComputerName $global:computername -Credential $global:credentials -ScriptBlock {Get-LSupdate}

    # Display the output of the command in a popup
    [System.Windows.Forms.MessageBox]::Show($lenovoupdate.ToString(), "System Update")
})
$form.Controls.Add($button6)


$button7 = New-Object System.Windows.Forms.Button
$button7.Location = New-Object System.Drawing.Point(350, 150)
$button7.Size = New-Object System.Drawing.Size(100, 35)
$button7.Text = "Update BIOS !WARNING!"
$button7.Enabled = $false
$button7.Add_Click({
   # Run the Invoke-Command cmdlet with the stored credentials
    $adobeinstall = Invoke-Command -ComputerName $global:computername -Credential $global:credentials -ScriptBlock {New-PSDrive @using:psdrive
    "\\uk-rhs-vapps1\applications\BIOS - Custom startup image\MT 11N0\updatebios.ps1"  }
})
$form.Controls.Add($button7)

$button8 = New-Object System.Windows.Forms.Button
$button8.Location = New-Object System.Drawing.Point(500, 150)
$button8.Size = New-Object System.Drawing.Size(100, 35)
$button8.Text = "Lock PC"
$button8.Enabled = $false
$button8.Add_Click({
   # Run the Invoke-Command cmdlet with the stored credentials
    $lockpc = Invoke-Command -ComputerName $global:computername -Credential $global:credentials -ScriptBlock {$xCmdString = {rundll32.exe user32.dll,LockWorkStation} | Invoke-Command $xCmdString}
})
$form.Controls.Add($button8)

$button9 = New-Object System.Windows.Forms.Button
$button9.Location = New-Object System.Drawing.Point(50, 200)
$button9.Size = New-Object System.Drawing.Size(100, 35)
$button9.Text = "Restart PC"
$button9.Enabled = $false
$Button9.BackColor = '#B30000'
$button9.Add_Click({
   # Run the Invoke-Command cmdlet with the stored credentials
    $restart = Invoke-Command -ComputerName $global:computername -Credential $global:credentials -ScriptBlock {Restart-Computer -Force}
})
$form.Controls.Add($button9)

$button10 = New-Object System.Windows.Forms.Button
$button10.Location = New-Object System.Drawing.Point(200, 200)
$button10.Size = New-Object System.Drawing.Size(100, 35)
$button10.Text = "Shutdown PC"
$button10.Enabled = $false
$button10.BackColor = '#B30000'
$button10.Add_Click({
   # Run the Invoke-Command cmdlet with the stored credentials
    $shutdown = Invoke-Command -ComputerName $global:computername -Credential $global:credentials -ScriptBlock {Stop-Computer -Force}

})
$form.Controls.Add($button10)

$button11 = New-Object System.Windows.Forms.Button
$button11.Location = New-Object System.Drawing.Point(350, 200)
$button11.Size = New-Object System.Drawing.Size(100, 35)
$button11.Text = "Logoff Users"
$button11.Enabled = $false
$button11.BackColor = '#B30000'
$button11.Add_Click({
   # Run the Invoke-Command cmdlet with the stored credentials
    $logoff = Invoke-Command -ComputerName $global:computername -Credential $global:credentials -ScriptBlock {logoff 1}

})
$form.Controls.Add($button11)



# Create the button and set its properties
$button12 = New-Object System.Windows.Forms.Button
$button12.Location = New-Object System.Drawing.Point(500, 200)
$button12.Size = New-Object System.Drawing.Size(100, 35)
$Button12.BackColor = '#CCCC99'
$button12.Text = "Installed Apps"
$button12.Enabled = $false
$button12.Add_Click({
    # Run the Invoke-Command cmdlet with the stored credentials
    $installedapps = Invoke-Command -ComputerName $global:computername -Credential $global:credentials -ScriptBlock {Get-WmiObject -Class Win32_Product | select Name,Version}
    $installedapps | Out-GridView -Title "Installed Apps"
})

# Add the button to the form
$form.Controls.Add($button12)




$button13 = New-Object System.Windows.Forms.Button
$button13.Location = New-Object System.Drawing.Point(50, 250)
$button13.Size = New-Object System.Drawing.Size(100, 35)
$Button13.BackColor = '#8f4509'
$button13.Text = "Upgrade Choco Apps"
$button13.Enabled = $false
$button13.Add_Click({
    # Run the Invoke-Command cmdlet with the stored credentials
    $chocoupgradeapps = Invoke-Command -ComputerName $global:computername -Credential $global:credentials -ScriptBlock {choco upgrade all}
})

# Add the button to the form
$form.Controls.Add($button13)


$button14 = New-Object System.Windows.Forms.Button
$button14.Location = New-Object System.Drawing.Point(200, 250)
$button14.Size = New-Object System.Drawing.Size(100, 35)
$Button14.BackColor = '#8f4509'
$button14.Text = "Upgrade Choco"
$button14.Enabled = $false
$button14.Add_Click({
    # Run the Invoke-Command cmdlet with the stored credentials
    $chocoupgrade = Invoke-Command -ComputerName $global:computername -Credential $global:credentials -ScriptBlock {choco upgrade chocolatey}
})

# Add the button to the form
$form.Controls.Add($button14)



$button15 = New-Object System.Windows.Forms.Button
$button15.Location = New-Object System.Drawing.Point(300, 250)
$button15.Size = New-Object System.Drawing.Size(100, 35)
$Button15.BackColor = '#8f4509'
$button15.Text = "Suppress Choco confirmation"
$button15.Enabled = $false
$button15.Add_Click({
    # Run the Invoke-Command cmdlet with the stored credentials

$chococonfirmation = Invoke-Command -ComputerName $global:computername -Credential $global:credentials -ScriptBlock {choco feature enable -n allowGlobalConfirmation}
})

# Add the button to the form
$form.Controls.Add($button15)

$button16 = New-Object System.Windows.Forms.Button
$button16.Location = New-Object System.Drawing.Point(400, 250)
$button16.Size = New-Object System.Drawing.Size(100, 35)
$Button16.BackColor = '#8f4509'
$button16.Text = "Install Choco Apps"
$button16.Enabled = $true
$button16.Add_Click({
    # Create the pop-up window within the form
    $popup = New-Object System.Windows.Forms.Form
    $popup.Text = "List apps here"
    $popup.Size = New-Object System.Drawing.Size(300,150)
    $popup.StartPosition = "CenterParent"

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(20,20)
    $label.Size = New-Object System.Drawing.Size(160,20)
    $label.Text = "Enter apps seperated by space"
    $popup.Controls.Add($label)

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(20,40)
    $textBox.Size = New-Object System.Drawing.Size(160,20)
    $popup.Controls.Add($textBox)

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(60,70)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = "OK"
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $popup.Controls.Add($OKButton)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(140,70)
    $cancelButton.Size = New-Object System.Drawing.Size(75,23)
    $cancelButton.Text = "Cancel"
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $popup.Controls.Add($cancelButton)

    # Show the pop-up window and get the result
    $result = $popup.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        # Output the entered text to the console
        Write-Host "Entered text: $($textBox.Text)"
        #Invoke-Command -ScriptBlock {choco install $($textBox.Text)}
    }
})


# Add the button to the form
$form.Controls.Add($button16)



#Suppress confirmation dialog:
#choco feature enable -n allowGlobalConfirmation

#To install multiple apps simultaneously:
#choco install inkscape sonicpi vlc adobereader adobeair 7zip notepadplusplus paint.net

#Upgrade all installed apps:
#choco upgrade all

#Upgrade Chocolatey:
#choco upgrade chocolatey

#To automate updates:
#https://community.chocolatey.org/packages/choco-upgrade-all-at







#Creates dropdown box at bottom to switch users
$showuser = New-Object System.Windows.Forms.Button
$showuser.Text = "Show User"
$showuser.Dock = "Bottom"
$showuser.add_Click({
    $menu = New-Object System.Windows.Forms.ContextMenuStrip
    $menu.Items.Add("Current User: $global:username")
    $menu.Show($showuser, 0, $showuser.Height)
})

$form.Controls.Add($showuser)







#logout button that closes window
$logout = New-Object System.Windows.Forms.Button
$logout.Location = New-Object System.Drawing.Point(550, 650)
$logout.Size = New-Object System.Drawing.Size(75, 20)
$logout.Text = "Close Script"
$logout.Add_Click({
    # Close the form, which will exit the script
    $form.Close()
})

# Add the button to the form
$form.Controls.Add($logout)










# Show the form
$form.ShowDialog()
