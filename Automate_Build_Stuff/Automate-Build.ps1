#requires -Version 3.0
#Requires -RunAsAdministrator
#Requires -Modules Microsoft.PowerShell.LocalAccounts, Microsoft.PowerShell.Utility, PackageManagement

<#
    .SYNOPSIS
    This script is to help out finalizing the build of our Windows systems.
    It should be able to do the following by the time it is completed.

    .DESCRIPTION
    1. Rename the Administrator account
    2. Create a folder for the Server Ops Team
    3. Set CD Letter to X:
    Uninstall unneeded software
    4. Build a standard folder structure that will be used for the care and feeding
    5. Make registry changes as required by the function of the device *Later versions

    .EXAMPLE
    Complete-StandaloneComputer.ps1

#>

Begin{
  $NewUsers = @{
    CRAdmin    = @{
      FullName            = 'TV Administrator'
      Description         = 'TV Admin Account'
      AccountGroup        = 'Administrators'
      AccountNeverExpires = $true
      Password            = '1qaz@WSX3edc$RFV'
    
    }

    sysmaint = @{
      FullName            = '911'
      Description         = 'Emergancy Access PW in "SCIT"'
      AccountGroup        = 'Administrators'
      AccountNeverExpires = $true
      Password            = '1qaz@WSX3edc$RFV'
    }
  }
  $NewFolderInfo = [ordered]@{
    HscServerOps = @{
      Path       = 'C:\Coding'
      ACLGroup   = 'Administrators'
      ACLControl = 'Full Control'
      ReadMeText = 'This is the working folder for the Server Ops team.'
      ReadMeFile = 'README.TXT'
    }
  }
  
  $NewNicConfigSplat = @{
    InterfaceAlias = 'Ethernet' 
    IpAddress = '192.168.86.92' 
    PrefixLength = 24 
    DefaultGateway = '192.168.86.1'
  }
   $SetNicConfigSplat = @{
    InterfaceAlias = 'Ethernet' 
    IpAddress = '192.168.86.92' 
    PrefixLength = 24 
    }
  
  
  #>
  # Variables
  $ConfigFilesFolder = '\\Fileshare\ConfigFiles'

  #$NewFolderInfo = Import-PowerShellDataFile  -Path ('{0}\NewFolderInfo.psd1' -f $ConfigFilesFolder)
  #$NewUsers = Import-PowerShellDataFile  -Path ('{0}\NewUsers.psd1' -f $ConfigFilesFolder)
  $NewGroups = Import-PowerShellDataFile  -Path ('{0}\NewGroups.psd1' -f $ConfigFilesFolder)
  
  #$NewGroups = @('RFV_Users', 'RFV_Admins', 'TestGroup', 'Guests')
  #$Password911 = Read-Host "Enter a 911 Password" -AsSecureString
  #$PasswordUser = Read-Host -Prompt 'Enter a User Password' -AsSecureString
  #$CurrentUsers = Get-LocalUser
  #$CurrentGroups = Get-LocalGroup
  
  # House keeping
  function New-Folder {
    <#
        .SYNOPSIS
        Short Description
    #>
    param
    (
      [Parameter(Mandatory, Position = 0)]
      [Object]$NewFolderInfo
    )
    foreach($ItemKey in $NewFolderInfo.keys)
    {
      $NewFolderPath = '{0}\{1}' -f $NewFolderInfo.$ItemKey.Path,$ItemKey
      $NewFile = $NewFolderInfo.$ItemKey.ReadMeFile
      $FileText = $NewFolderInfo.$ItemKey.ReadMeText
      If(-not (Test-Path -Path $NewFolderPath))
      {
        New-Item -Path $NewFolderPath -ItemType Directory -Force #-WhatIf
        $FileText | Out-File -FilePath ('{0}\{1}' -f $NewFolderPath, $NewFile) #-WhatIf
      }
    }
  }

  function Add-LocalRFVGroups    {
    <#
        .SYNOPSIS
        Short Description
    #>
    param
    (
      [Parameter(Mandatory, Position = 0)]
      [Object]$GroupList
    )
    foreach($NewGroup in $GroupList.Keys)
    {
      $LocalUserGroups = (Get-LocalGroup).name

      if($($GroupList[$NewGroup].Name) -notin $LocalUserGroups)
      {
        Write-Verbose -Message ('Creating {0} Account' -f $NewGroup)
        New-LocalGroup -Name $($GroupList[$NewGroup].Name) -Description $($GroupList[$NewGroup].Description) -WhatIf
      }
    }  
  }

  function Update-LocalUser {
    <#
        .SYNOPSIS
        Updates a user based on the hash settings

      $AdminUser = @{
          sysmaint = @{
          FullName            = '911'
          Description         = 'Emergancy Access PW in "SCIT"'
          AccountGroup        = 'Administrators'
          AccountNeverExpires = $true
          Password            = '1qaz@WSX3edc$RFV'
    }

    #>
    param
    (
      [Parameter(Mandatory, Position = 0)]
      [Object]$UserToUpdate,
      [Parameter(Mandatory, Position = 1)]
      [Object]$UpdatedHash
    )
    $LocalUserNames = (Get-LocalUser).name
    $UserName = [String]$UserInfo.Keys
    $SecurePassword = ConvertTo-SecureString -String ($UserInfo.Password) -AsPlainText -Force
    $UserDescription = ($UserInfo.Description)
    $UserFullName = ($UserInfo.FullName)
    If (($UserName -notin $LocalUserNames) -and ($UserToUpdate -in $LocalUserNames))
    {
      Write-Verbose -Message ('Renaming {0} Account' -f $UserFullName)
      Set-LocalUser -Name $UserName -Description $UserDescription -FullName $UserFullName  -Password $SecurePassword -WhatIf -ErrorAction SilentlyContinue
    }
  }

  function Add-RFVUsersToGroups  {
    <#
        .SYNOPSIS
        Short Description
    #>
    param
    (
      [Parameter(Mandatory, Position = 0)]
      [Object]$UserName,
      [Parameter(Mandatory, Position = 1)]
      [Object]$UserInfo
    )
    $UserPrimaryGroup = ($UserInfo.AccountGroup) 
    $GroupMembership = (Get-LocalGroupMember -Group $UserPrimaryGroup | Where-Object -Property ObjectClass -EQ -Value User).Name
    if($GroupMembership -match $UserName)
    {
      Write-Verbose -Message ('Adding "{0}" Account to {1} group' -f $($UserInfo.FullName), $UserPrimaryGroup) -Verbose
      Add-LocalGroupMember -Group $UserPrimaryGroup -Member $UserName -ErrorAction Stop
    }
  }
  function Uninstall-Software    {
    <#
        .SYNOPSIS
        Uninstalls software based on Parameter, File or Pick list.

        .LINK
        https://github.com/KnarrStudio/Tools-StandAloneSystems/blob/master/Scripts/Uninstall-Software.ps1
    #>


    [CmdletBinding(SupportsShouldProcess,DefaultParameterSetName = 'Default')]
    param
    (
      [Parameter(Mandatory,HelpMessage = 'Add help message for user', Position = 0,ParameterSetName = 'String')]
      [String[]]$SoftwareList,
      [Parameter(Mandatory,HelpMessage = 'Add help message for user', Position = 0,ParameterSetName = 'File')]
      [ValidateScript({
            If($_ -match '.txt')
            {
              $true
            }
            Else
            {
              Throw 'Input file needs to be plan text'
            }
      })][String]$File,
      [Parameter(Mandatory,HelpMessage = 'Add help message for user', Position = 0,ParameterSetName = 'PickMenu')]
      [Switch]$PickMenu,
      [Parameter(Position = 1,ParameterSetName = 'File')]
      [ValidateSet('New','Updates')]
      [String]$Add = $null
    )
  
    if($PSBoundParameters.Values.Count -eq 0) 
    {
      Get-Help -Name Uninstall-Software
      return
    }
  
    $VerboseMessage = 'Verbose Message'
    Write-Verbose -Message ('{0}' -f $VerboseMessage)
  
    $InstalledSoftware = Get-Package
          
    switch($PSBoundParameters.Keys)
    {
      'File'
      {
        Write-Verbose -Message ('switch: {0}' -f $($PSBoundParameters.Keys))
        if(-not $Add)
        {
          $SoftwareList = Get-Content -Path $File
        }
        elseif($Add -eq 'New')
        {
          $SoftwareList = ($InstalledSoftware |
            Select-Object -Property Name |
          Out-GridView -PassThru -Title 'Software Pick List').name 
          $SoftwareList | Out-File -FilePath $File -Force
        }
        elseif($Add -eq 'Updates')
        {
          $SoftwareList = ($InstalledSoftware |
            Select-Object -Property Name |
          Out-GridView -PassThru -Title 'Software Pick List').name 
          $SoftwareList | Out-File -FilePath $File -Append
        }
      }
      'PickMenu'
      { 
        Write-Verbose -Message ('switch: {0}' -f $($PSBoundParameters.Keys))
        $SoftwareList = ($InstalledSoftware |
          Select-Object -Property Name |
        Out-GridView -PassThru -Title 'Software Pick List').name
      }
      'Default'
      {
        Write-Verbose -Message ('switch: {0}' -f $($PSBoundParameters.Keys))
      }
    }

    if(-not $Add)
    {
      Write-Verbose -Message ('foreach Software - Uninstall-Package')
      foreach($EachSoftware in $SoftwareList)
      {
        $EachSoftware = $EachSoftware.Trim()
        Write-Verbose -Message ('foreach Software: {0}' -f $EachSoftware)
        try
        {
          Get-Package -Name $EachSoftware |  Uninstall-Package -WhatIf -ErrorAction Stop
        }
        catch
        {
          Write-Warning -Message ('foreach Software: {0}' -f $EachSoftware)
        }
      }
    }
  }
  function Set-WallPaper    {
    <#
        .SYNOPSIS
        Change Desktop picture/background
    #>
    param
    (
      [Parameter(Position = 0)]
      #[string]$BackgroundSource = "$env:HOMEDRIVE\Windows\Web\Wallpaper\Windows\img0.jpg",
      #[string]$BackupgroundDest = "$env:PUBLIC\Pictures\BG.jpg"
      [string]$BackgroundSource = "$env:HOMEDRIVE\Windows\Web\Wallpaper\Windows\img0.jpg",
      [string]$BackupgroundDest = "$env:HOMEDRIVE\Windows\Web\Wallpaper\Windows\img0.jpg"
    )
    If ((Test-Path -Path $BackgroundSource) -eq $false)
    {
      Copy-Item -Path $BackgroundSource -Destination $BackupgroundDest -Force -WhatIf
    }
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name Wallpaper -Value $BackupgroundDest 
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name TileWallpaper -Value '0'
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name WallpaperStyle -Value '10' -Force
  }
  function Set-CdLetterToX    {
    <#
        .SYNOPSIS
        Test for a CD and change the drive Letter to X:
    #>
    param
    (
      [Parameter(Position = 0)]
      [Object]$CdDrive = (Get-WmiObject -Class Win32_volume -Filter 'DriveType=5'|   Select-Object -First 1)
    )
    if($CdDrive)
    {
      if(-not (Test-Path -Path X:\))
      {
        Write-Verbose -Message ('Changing{0} drive letter to X:' -f ([string]$CdDrive.DriveLetter))
        $CdDrive | Set-WmiInstance -Arguments @{
          DriveLetter = 'X:'
        }
      }
    }
  }
  function Set-NicConfiguration {
    <#
        .SYNOPSIS
        Test for a CD and change the drive Letter to X:
    #>
    param
    (
      [Parameter(Position = 0)]
      [hashtable]$NewNetConfigSplat,
      [Parameter(Position = 1)]
      [hashtable]$SetNetConfigSplat
    )
    
    
    $NIC = Get-NetIPInterface -AddressFamily IPv4 | sort -Property InterfaceMetric | select -f 1 
    if($NIC.Dhcp -eq 'Enabled'){
      Set-NetIPInterface  -InterfaceAlias $NIC.InterfaceAlias -AddressFamily IPv4 -Dhcp Disabled
    }
    Rename-NetAdapter -Name $NIC.InterfaceAlias -NewName 'Ethernet'
    
    
    #New-NetIPAddress @NewNetConfigSplat #-WhatIf
    Set-NetIPAddress  #@SetNetConfigSplat #-WhatIf
    
  }
}
Process{
  
  # Creates new folder structure 
  New-Folder -NewFolderInfo $NewFolderInfo
  
  # Changes the CD/DVD drive letter to "X" for standardization.
  Set-CdLetterToX
  
  # Sets the Wallpaper to a specific flavor for all users.
  Set-WallPaper
  
  # Adds new groups 
  Add-LocalRFVGroups -GroupList $NewGroups 
   
  # Adds new users based on the "NewUsers.psd1" file
  ForEach ($UserName in $NewUsers.Keys) 
  {
    $UserInfo = $NewUsers[$UserName]
    Add-RFVLocalUsers -UserName $UserName -userinfo $UserInfo
    Add-RFVUsersToGroups -UserName $UserName -UserInfo $UserInfo
  }
  
  Get-Help -Online -Name Uninstall-Software
  #Uninstall-Software -File 'C:\Temp\SoftwareList.txt' -Add New

  # Sets the network configuration on the NIC
  #Set-NicConfiguration $NicConfigSplat
}
End{
}

