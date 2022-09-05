#requires -Modules Microsoft.PowerShell.Utility
#!/usr/bin/env powershell
#requires -Version 4.0


function Get-Versions
{
  <#
      .SYNOPSIS
      A way to get the OS version you are running
  #>
  param
  ([Parameter(Mandatory = $false, Position = 0)][Object]$input
  )
  $WinOS = 'Windows'
  [String]$MajMinVer = '{0}.{1}'
  [Float]$PsVersion = ($MajMinVer -f [int]($psversiontable.PSVersion).Major, [int]($psversiontable.PSVersion).Minor)
  if($PsVersion -ge 6)
  {
    if ($IsLinux) 
    {
      $OperatingSys = 'Linux'
    }
    elseif ($IsMacOS) 
    {
      $OperatingSys = 'macOS'
      $OsMac
    }
    elseif ($IsWindows) 
    {
      $OperatingSys = $WinOS
    }
  }
  Else
  {
    Write-Output -InputObject ($MajMinVer -F ($(($psversiontable.PSVersion).Major), $(($psversiontable.PSVersion).Minor)))
    if($env:os)
    {
      $OperatingSys = $WinOS
    }
  }
  $x = @{
    PSversion = $PsVersion
    OSVersion = $OperatingSys
  }
  return $x
}

function Get-CurrentLineNumber
{
  <#
      .SYNOPSIS
      Add-In to aid troubleshooting. A quick way to mark sections in the code.  
      This is a relitive location, so running thirty lines from the middle of your 1000 line code is only going to give you 0-30 as a line number.  Not 501-531 

      .PARAMETER MsgNum
      Selects the message to be displayed.
      1 = 'Set Variable'
      2 = 'Set Switch Variable'
      3 = 'Set Path/FileName'
      4 = 'Start Function'
      5 = 'Start Loop'
      6 = 'End Loop'
      7 = 'Write Data'
      99 = 'Current line number'


      .EXAMPLE
      Write-Verbose  -Message ('{0} {1}' -f $(Get-CurrentLineNumber -MsgNum 7 ),'') 
    
      Output:
      Line 23:  Write Data

      .NOTES
      Get-CurrentLineNumber must be accessed using the full script or it will only give you Line #1.  
  #>


  param
  (
    [Parameter(Mandatory = $true,HelpMessage = 'See "get-help Get-CurrentLineNumber" for different options',Position = 0)]
    [int]$MsgNum
  )
  $VerboseMsg = @{
    1 = 'Set Variable'
    2 = 'Set Switch Variable'
    3 = 'Set Path/FileName'
    4 = 'Start Function'
    5 = 'Start Loop'
    6 = 'End Loop'
    7 = 'Write Data'
    99 = 'Current line number'
  }
  if($MsgNum -gt $VerboseMsg.Count)
  {
    $MsgNum = 99
  }#$VerboseMsg.Count}
  'Line {0}:  {1}' -f $MyInvocation.ScriptLineNumber, $($VerboseMsg.$MsgNum)
} 

Function Set-SafetySwitch
{
  <#
      .SYNOPSIS
      Turns on "WhatIf" for the entire script.
      Like a gun safety, "ON" will prevent the script from running and "OFF" will allow the script to make changes.

      .PARAMETER RunScript
      Manually sets the "Safety" On/Off.

      .PARAMETER Toggle
      Changes the setting from its current state. There is no output with this.  Use the "Bombastic" switch if you need a visual message.
      By default this is set

      .PARAMTER Bombastic
      Another word for verbose and is used to provide a colored (red/green) message of the current state to the console.  
      You can add it to a menu.

      .EXAMPLE
      Set-SafetySwitch 
      Sets the WhatIfPreference to the opposite of its current setting. No output message.

      .EXAMPLE
      Set-SafetySwitch -Bombastic
      Sets the WhatIfPreference to the opposite of its current setting
       
      Output is one of the two based on what is set:
      'Safety is OFF - Script is active and will make changes'
      'Safety is ON - Script is TESTING MODE'

      .NOTES
      Best to just copy this into your script and call it how ever you want. I use a menu.
      Latest update allows you to pull out the working function 'Set-WhatIf'

  #>
  
  [CmdletBinding(SupportsShouldProcess,ConfirmImpact = 'Low',DefaultParameterSetName = 'Default')]
  param
  (
    [Parameter(Position = 0, ParameterSetName = 'Default')] [Switch]$Toggle = $true,
    [Parameter(Position = 1)] [Switch]$Bombastic,
    [Parameter(Mandatory,HelpMessage = 'Hard set on/off',Position = 0,ParameterSetName = 'Switch')]
    [ValidateSet('No','Yes')] [String]$RunScript
  )

  function Set-WhatIf
  {
    <#.SYNOPSIS;Sets Whatif to True or False#>
    param (
      [Alias('NoRun')]
      [Parameter(Mandatory,HelpMessage = 'Hard set on. Test Script',Position = 0,ParameterSetName = 'On')][Switch]$On,
      [Alias('YesRun')]
      [Parameter(Mandatory,HelpMessage = 'Hard set off. Run Script',Position = 0,ParameterSetName = 'Off')][Switch]$Off,
      [Switch]$Script:Bombastic
    )

    $Message = @{
      BombasticOff = 'Safety is OFF - Script is active and will make changes'
      BombasticOn  = 'Safety is ON - Script is TESTING MODE'    }

    if($On) {
      $Script:WhatIfPreference = $true
      if ($Bombastic) { Write-Host -Object $($Message.BombasticOn) -ForegroundColor Green  }
    }
    if($Off) {
      $Script:WhatIfPreference = $false
      if ($Bombastic) { Write-Host -Object $($Message.BombasticOff) -ForegroundColor Red  }
    }
  }

  if($RunScript -eq 'Yes') { 
    Set-WhatIf -YesRun }
  elseif($RunScript -eq 'No') { 
    Set-WhatIf -NoRun }
  elseif($Toggle) { 
    if ($WhatIfPreference -eq $true) { 
      Set-WhatIf -Off }
    else { 
      Set-WhatIf -On }
  }
}

Function Compare-FileHash 
{
  <#
      .Synopsis
      Generates a file hash and compares against a known hash
      .Description
      Generates a file hash and compares against a known hash.
      .Parameter File
      Mandatory. File name to generate hash. Example file.txt
      .Parameter Hash
      Mandatory. Known hash. Example 186F55AC6F4D2B60F8TB6B5485080A345ABA6F82
      .Parameter Algorithm
      Mandatory. Algorithm to use when generating the hash. Example SHA1
      .Notes
      Version: 1.0
      History:
      .Example
      Compare-FileHash -fileName file.txt -Hash  186F5AC26F4E9B12F861485485080A30BABA6F82 -Algorithm SHA1
  #>

  Param(
    [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName,HelpMessage = 'The file that you are testing against.  Normally the file that you just downloaded.')]
    [string] $fileName
    ,
    [Parameter(Mandatory,HelpMessage = 'The original hash that you are expecting it to be the same.  Normally provided by website at download.')]
    [string] $originalhash
    ,
    [Parameter(Mandatory = $false)]
    [ValidateSet('SHA1','SHA256','SHA384','SHA512','MD5')]
    [string] $algorithm = 'SHA256'
  )
 
  $fileHash = (Get-FileHash -Algorithm $algorithm -Path $fileName).Hash
  $fileHash = $fileHash.Trim()
  $originalhash = $originalhash.Trim()
  $output = ('File: {1}{0}Algorithm: {2}{0}Original hash: {3}{0}Current file:  {4}' -f [environment]::NewLine, $fileName, $algorithm, $originalhash, $fileHash)

  If ($fileHash -eq $originalhash) 
  {
    #Write-Host -Object '---- Matches ----' -ForegroundColor White -BackgroundColor Green
    return $true
  }
  else 
  {
    #Write-Host -Object '---- Does not match ----' -ForegroundColor White -BackgroundColor Red
    return $false
  }

  #Write-Output -InputObject $output
}

<#
function Import-FileData
{
  <#
      .SYNOPSIS
      A function to simplify importing txt, csv and json files

      .DESCRIPTION
      Playing around with file imports to see if there was a simplify the code. 
      I was working with these files and it seemed messy. I wanted to be able to pass & return the file. 
      It led to this function which works well with txt, csv and json files.  
      It was handy in the one script I was writing at the time, but I don't think it will ever become more then what it is.

      .PARAMETER fileName
      Filename and path of the file you need to import data from

      .PARAMETER FileType
      File type to be imported, but really how you want it to be handled.  
      In otherwords, a 'txt' file could be imported as a csv so you would use the csv type.  
      It works the other way to in the event you want to see the raw data, just use txt.

      .EXAMPLE
      Import-FileData -fileName Value -FileType Value
    
  # >


  param(
    [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName,HelpMessage = 'Name of file to be imported.')]
    [String]$fileName,
    [Parameter(Mandatory,HelpMessage = 'File type to be imported, but really how you want it to be handled.  ie .txt file could be a "csv"')]
    [ValidateSet('csv','txt','json')]
    [String]$FileType
  )
  
  switch ($FileType)
  {
    'csv'    
    {
      $importdata = Import-Csv -Path $fileName
    }
    'txt'    
    {
      $importdata = Get-Content -Path $fileName -Raw
    }  
    'json'   
    {
      $importdata = Get-Content -Path .\config.json
    }
    default    
    {
      $importdata = $null
    }
  }
  return $importdata
}
#>

function Send-eMail
{
  <#
      .SYNOPSIS
      Send an email notification via script.  Uses local service account and mail server.

      .DESCRIPTION
      Send an email notification via script.  Uses local service account and mail server.
      Sends and email from a script run at the server.  This generates output to the console.

      .PARAMETER MailTo
      Receivers email address

      .PARAMETER MailFrom
      Senders email address

      .PARAMETER msgsubj
      Email subject.  This is always a good idea.

      .PARAMETER SmtpServers
      Name or IP addess of SMTP servers

      .PARAMETER MessageBody
      The message.  This could be an error from  a catch statement or just information about it being completed

      .PARAMETER AttachedFile
      Email attachemt

      .PARAMETER ErrorFile
      File to send the error message.

      .EXAMPLE
      Send-eMail -MailTo Value -MailFrom Value -msgsubj Value -SmtpServers Value -MessageBody Value -AttachedFile Value -ErrorFile Value

      .EXAMPLE
      # The "$SplatSendEmail" should be the only information you need to change to send an email.  
      $SplatSendEmail = @{
      MailTo       = @('erik@knarrstudio.com')
      MailFrom     = "$($env:computername)@mail.com"
      msgsubj      = "Service Restarted - $(Get-Date -Format G)"
      SmtpServers  = '192.168.0.5', '192.168.1.8'
      MessageBody  = $EmailMessage
      ErrorFile    = ''
      AttachedFile = $AttachedFile
      Verbose      = $true
      }  
      
      Send-eMail @SplatSendEmail 


      .NOTES
      The current version is somewhat interactive and needs to be run from a console.  
      Later versions should be written to be used without user intervention

  #>


  [CmdletBinding(DefaultParameterSetName = 'Default')]
  param
  (
    [Parameter(Mandatory,HelpMessage = 'To email address(es)', Position = 0)]
    [String[]]$MailTo,
    [Parameter(Mandatory,HelpMessage = 'From email address', Position = 1)]
    [String]$MailFrom,
    [Parameter(Mandatory,HelpMessage = 'Email subject', Position = 2)]
    [String]$msgsubj,
    [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName,HelpMessage = 'SMTP Server(s)', Position = 3)]
    [String[]]$SmtpServers,
    [Parameter(Position = 4)]
    [AllowNull()]
    [Object]$MessageBody,
    [Parameter(Position = 5)]
    [AllowNull()]
    [String]$AttachedFile,
    [Parameter(Position = 6)]
    [AllowEmptyString()]
    [string]$ErrorFile = ''
  )

  $DateTime = Get-Date -Format s

  if([string]::IsNullOrEmpty($MessageBody))
  {
    $MessageBody = ('{1} - Email generated from {0}' -f $env:computername, $DateTime)
    Write-Warning -Message 'Setting Message Body to default message'
  }
  elseif(($MessageBody -match '.txt') -or ($MessageBody -match '.htm'))
  {
    if(Test-Path -Path $MessageBody)
    {
      [String]$MessageBody = Get-Content -Path $MessageBody
    }
  }
  elseif(-not ($MessageBody -is [String]))
  {
    $MessageBody = ('{0} - Original message was not sent as a String.' -f $DateTime)
  }
  else
  {
    $MessageBody = ("{0}`n{1}" -f $MessageBody, $DateTime)
  }
    
  if([string]::IsNullOrEmpty($ErrorFile))
  {
    $ErrorFile = New-TemporaryFile
    Write-Warning  -Message ('Setting Error File to: {0}' -f $ErrorFile)
  }
 
  $SplatSendMessage = @{
    From        = $MailFrom
    To          = $MailTo
    Subject     = $msgsubj
    Body        = $MessageBody
    Priority    = 'High'
    ErrorAction = 'Stop'
  }
  
  if($AttachedFile)
  {
    Write-Verbose -Message 'Inserting file attachment'
    $SplatSendMessage.Attachments = $AttachedFile
  }
  if($MessageBody.Contains('html'))
  {
    Write-Verbose -Message 'Setting Message Body to HTML'
    $SplatSendMessage.BodyAsHtml  = $true
  }
  
  foreach($SMTPServer in $SmtpServers)
  {
    try
    {
      Write-Verbose -Message ('Try to send mail thru {0}' -f $SMTPServer)
      Send-MailMessage -SmtpServer $SMTPServer  @SplatSendMessage
      # Write-Output $SMTPServer  @SplatSendMessage
      Write-Verbose -Message ('successful from {0}' -f $SMTPServer)
      Break 
    } 
    catch 
    {
      $ErrorMessage  = $_.exception.message
      Write-Verbose -Message ("Error Message: `n{0}" -f $ErrorMessage)
      ('Unable to send message thru {0} server' -f $SMTPServer) | Out-File -FilePath $ErrorFile -Append
      ('- {0}' -f $ErrorMessage) | Out-File -FilePath $ErrorFile -Append
      Write-Verbose -Message ('Errors written to: {0}' -f $ErrorFile)
    }
  }
}

function Get-TimeStamp
{
  <#
      .SYNOPSIS
      Simple date time stamp, for the person that is tired of looking up format syntax

      .DESCRIPTION
      Creates a function around the "Get-Date -Uformat" to make common date/time stamps .
      Use the following formats:
          20170316 = YYYYMMDD
          16214855 = DDHHmmss
          17/03/16 21:52 = YYMMDD_HHmm
          1703162145 = YYMMDDHHmm
          07/26/21 08:45:19 = MMDDTT-HH:mm:ss
          03/16/2018 = Default

      .PARAMETER Format
      YYYYMMDD           - Four digit year, two digit Month and day -example: 20211225 (Christmas 2021) 
                           This is for the once a day report

      HHmmss             - Hour, minute, seconds -example: 042000 (today @ 4:20:00) 

      YYYYMMDDHHmm       - Four digit year, two digit Month, Day, Hour, Minute -example: 202112250420 (Christmas 2021 @ 4:20) 
                           This is good for the report that runs more than once a day   

      YYYY-MM-DD         - Four digit year, two digit Month and day -example: 2021-12-25 (Christmas 2021) 
                           Once a day report with some formatting, but still able to be used as a filename

      JJJHHmmss          - Julian Date, Hour, Minutes and Seconds -example: 359042000 (Christmas 2021 @ 4:20:00) 
                           Use this when you are testing, troubleshooting or creating.  You won't have to worry about overwrite or append errors)

      DayOfYear          - Julian Date -example: 360 (Boxing Day 2021) 

      MM-DD-YY_HH.mm.ss  - Two digit year-month-day _ Hours:Minutes:Seconds -example: 12-26-21_07.54.50
                           Filename friendly

      MM/DD/YY HH:mm:ss  - Two digit year-month-day _ Hours:Minutes -example: 12/26/21 07:53:38

      YY-MM-DD_24HH.mm   - Two digit year-month-day _ 24Hour:Minutes -example: 21-12-26_07.58
                           Filename friendly

      YY/MM/DD 24HH:mm   - Two digit year-month-day _ 24Hous:Minutes -example: 21/12/26 07:58 

      tzOffset           - Two digit year AbrvMonth Day 24Hous:Minutes Timezone offset -example: 21 Dec 25 16:20 -06 (Christmas 2021 @ 4:20pm CST) 

      tzOffset-f         - Two digit year AbrvMonth Day 24Hous:Minutes Timezone offset -example: 21-Dec-25_16.20(-06) (Christmas 2021 @ 4:20pm CST) 
                           Filename friendly


      .EXAMPLE
      Get-TimeStamp -Format MM/DD/YY HH:mm:ss 
      Returns - 12/26/21 07:53:38


      .EXAMPLE
      Get-TimeStamp -Format YY-MM-DD_24HH.mm
      Returns - 21-12-26_07.58

      .NOTES
      'YYYYMMDD','HHmmss','YYYYMMDDHHmm','YYYY-MM-DD','JJJHHmmss','DayOfYear','MM-DD-YY_HH.mm.ss','MM/DD/YY HH:mm:ss','YY-MM-DD_24HH.mm','YY/MM/DD 24HH:mm','tzOffset','tzOffset-f'


  #>

  [cmdletbinding(DefaultParameterSetName = 'FileName Set')]
  param
  (
    [Parameter(Mandatory,Position = 0,HelpMessage = 'Use the following formats: "YYYYMMDD", "HHmmss" or for more formats "Help".',ParameterSetName = 'FileName Set')]
    [ValidateSet('YYYYMMDD','HHmmss','YYYYMMDDHHmm','YYYY-MM-DD','JJJHHmmss','DayOfYear','MM/DD/YY HH:mm:ss','YY-MM-DD_24HH.mm','YY/MM/DD 24HH:mm','tzOffset','tzOffset-f','Help')] 
    [String]$Format
  )
  
  switch ($Format) {
    YYYYMMDD
    {
      $SplatFormat = @{
        UFormat = '%Y%m%d'
      }
    } # 20170316 YYYYMMDD
    HHmmss
    {
      $SplatFormat = @{
        UFormat = '%H%M%S'
      }
    } # 214855 HHmmss  
    YYYYMMDDHHmm
    {
      $SplatFormat = @{
        UFormat = '%Y%m%d%H%M'
      }
    } # 1703162145 YYMMDDHHmm
    YYYY-MM-DD
    {
      $SplatFormat = @{
        UFormat = '%F'
      }
    } # 2018-05-12 (ISO 8601 format)
    JJJHHmmss
    {
      $SplatFormat = @{
        UFormat = '%j%H%M%S'
      }
    } # 207094226 JJJHHmmss Julion Day hours minutes
    DayOfYear
    {
      $SplatFormat = @{
        UFormat = '%j'
      }
    } # Day of Year
    MM-DD-YY_HH.mm
    {
      $SplatFormat = @{
        UFormat = '%m-%d-%Y_%H.%M'
      }
    } # 12-26-2021_10.42.36 (MM-DD-YY_HH.mm)
    'MM/DD/YY HH:mm:ss'
    {
      $SplatFormat = @{
        UFormat = '%m/%d/%y %r'
      }
    } # 'MM/DD/YY HH:mm:ss'
    'MM/DD/YY 24HH:mm:ss'
    {
      $SplatFormat = @{
        UFormat = '%D %R:%S'
      } # 'MM/DD/YY 24HH:mm:ss'
    } 
    YYYY-MM-DD_24HH.mm
    {
      $SplatFormat = @{
        UFormat = '%Y-%m-%d_%H.%M'
      }
    }
    tzOffset
    {
      $SplatFormat = @{
        UFormat = '%y %b %d %R %Z'
      }
    }

    tzOffset-f
    {
      $SplatFormat = @{
        UFormat = '%y-%b-%d_%R(%Z)'
      }
    } # YYYY MMM DD - timezone offest
    Help
    {
      Get-Help -Name Get-timeStamp -Parameter Format
      Return
    }
    Default
    {
      $SplatFormat = @{}
    }
  }
    
  [string]$TimeStamp = Get-Date @SplatFormat
  return $TimeStamp
}
<#
    function Get-TimeStampToday 
    {
    Get-TimeStamp -Format YYYYMMDD
    }
    function Get-TimeStampNow 
    {
    Get-TimeStamp -Format HHmmss
    }
    Set-Alias -Name TimeStamp -Value Get-TimeStampNow
    Set-Alias -Name DayStamp -Value Get-TimeStampToday
#>

function New-File
{
  <#
      .SYNOPSIS
      Creates a file and increments the name "(1),(2),(3)..." if the file exists.

      .DESCRIPTION
      Creates a file and increments the name, or allows you to append the base filename with a tag.
      You provide the base name and extension the time/date stamp and if you want to append or overwrite the file.

      This started as a way to build a filename that was timestamped.  It then morphed into creating the file and then incrementing it.
      It has morphed again and no longer adds the date.  I found that the increment was valuable by itself, so the timestamp has been depricated as a default and changed to 'Tag'.

      .PARAMETER FileName
      Name of the file "Import-FileData.ps1"

      .PARAMETER Tag
      This is just what is added to the back of the file name.  You can use a string, or pass a variable. For a timestamp use the "Get-TimeStamp" (See Notes) function
      Try $((Get-Date).Tostring('yyyyMMdd'))

      You can use any format that is legal for a filename.  Using only "Get-Date" will fail.
      
      This is a string input so you can use "foo" or "bar" and it will work.  
      Try $($env:username) or $($env:computername)

      
      .PARAMETER Amend
      Looks for the file and does nothing if it exists.  Good for testing to ensure your output goes somewhere.
      If the file does not exist, then it will create it. 
      If the file exists, it is not changed, but the name is passed back to you

      .PARAMETER Overwrite
      Just simply creates a new file with the "-force" parameter.  
      It doesn't bother to check.  

      .PARAMETER Increment
      This is default and is optional.
      This looks for the file and if it exists, it creates a new file such as "Import-FileData(1).ps1".  If you were to run it again, you would get "Import-FileData(2).ps1"
      If it doesn't exist, it creates the file as input.  "Import-FileData.ps1"

      .EXAMPLE
      New-File  -FileName Import-FileData.ps1

      If Not Exist (Creates): Import-FileData.ps1
      If Exists x2 (Creates): Import-FileData(3).ps1

      
      .EXAMPLE
      New-File  -FileName Import-FileData.ps1 -Tag 123456
      
      If Not Exist (Creates): Import-FileData-123456.ps1
      If Exists x2 (Creates): Import-FileData-123456(3).ps1
      
      .EXAMPLE
      $filename = 'Import-FileData.ps1' ; $timeStamp = Get-TimeStamp -Format YYYYMMDD -AsFilename ; New-File $filename $timeStamp
      
      If Not Exist (Creates): Import-FileData-20210727.ps1

      .EXAMPLE
      $filename = 'Import-FileData.ps1' ; Get-TimeStamp -Format YYYYMMDD -AsFilename | New-File $filename

      If Not Exist (Creates): Import-FileData-20210727.ps1

      .EXAMPLE
      New-File  -FileName Import-FileData.ps1 -Amend
      
      If Not Exist (Creates): Import-FileData.ps1
      If Exist (No Change): Import-FileData.ps1
      If the file exists, it is not changed, but the name is passed back to you

      .EXAMPLE
      New-File  -FileName Import-FileData.ps1 -Overwrite
      If Not Exist (Creates): Import-FileData.ps1
      If Exists (Overwrites): Import-FileData.ps1

      .EXAMPLE
      New-File  -FileName Import-FileData.ps1 -Increment
      If Not Exist (Creates): Import-FileData-20210727.ps1
      If Exists (Increments num in "($i)"): Import-FileData-20210727(1).ps1

      .NOTES
      

      Regarding the Get-TimeStamp:
      The "Get-TimeStamp", which was originally built into the script, but pulled out to be more widely used.
      Get-TimeStamp -Format YYYY-MM-DD -AsFilename 
      Excepted Formats: formats - YYYYMMDD, DDHHmmss, YYMMDD-24HHmm, YYYYMMDDHHmm, MM-DD-YY_HHmmss, YYYY-MM-DD, JJJHHmmss, DayOfYear, tzOffset
      The formats with the "ss" on the end are for seconds, so every second you could create a new file.  
      The formats with the "-f" on the end are the ones which have special characters and will need the "-AsFilename" to be used in a filename


      .INPUTS
      String

      .OUTPUTS
      File with name basesd in input

  #>

  [cmdletbinding(DefaultParameterSetName = 'FileName Set')]
  #[cmdletbinding()]
  param
  (
    [Parameter(Mandatory,Position = 0,ValueFromPipeline, ValueFromPipelineByPropertyName,HelpMessage = 'File name "Fullname.extension" | example: test.txt',ParameterSetName = 'FileName Set')]
    [Parameter(Mandatory,Position = 0,ValueFromPipeline, ValueFromPipelineByPropertyName,HelpMessage = 'File name "Fullname.extension" | example: test.txt',ParameterSetName = 'Increment')]
    [Parameter(Mandatory,Position = 0,ValueFromPipeline, ValueFromPipelineByPropertyName,HelpMessage = 'File name "Fullname.extension" | example: test.txt',ParameterSetName = 'Overwrite')]
    [Parameter(Mandatory,Position = 0,ValueFromPipeline, ValueFromPipelineByPropertyName,HelpMessage = 'File name "Fullname.extension" | example: test.txt',ParameterSetName = 'Amend')]
    [Alias('file')]
    [String]$Filename,
    
    [Parameter(Mandatory = $false,Position = 1,ValueFromPipeline, ValueFromPipelineByPropertyName,ParameterSetName = 'FileName Set')]
    [Parameter(Mandatory = $false,Position = 1,ValueFromPipeline, ValueFromPipelineByPropertyName,ParameterSetName = 'Increment')]
    [Parameter(Mandatory = $false,Position = 1,ValueFromPipeline, ValueFromPipelineByPropertyName,ParameterSetName = 'Overwrite')]
    [Parameter(Mandatory = $false,Position = 1,ValueFromPipeline, ValueFromPipelineByPropertyName,ParameterSetName = 'Amend')]
    [String]$Tag, 
    
    [Parameter(Mandatory = $true,Position = 2,HelpMessage = 'Amend or Append file',ParameterSetName = 'Amend')]
    [Switch]$Amend,
    
    [Parameter(Mandatory = $false,Position = 2,HelpMessage = 'Creates new file with "(1)"',ParameterSetName = 'Increment')]
    [Switch]$Increment = $true,
    
    [Parameter(Mandatory = $true,Position = 2,HelpMessage = 'Overwrite or Delete and recreate file',ParameterSetName = 'Overwrite')]
    [Switch]$Overwrite,
    
    [Parameter(Mandatory = $false,HelpMessage = 'Returns the filename or filepath.')]
    [ValidateSet('Filename','Filepath')] 
    [Parameter(ParameterSetName = 'FileName Set')]
    [Parameter(ParameterSetName = 'Increment')]
    [Parameter(ParameterSetName = 'Overwrite')]
    [Parameter(ParameterSetName = 'Amend')]
    [String]$Return = 'Filename'
  )
  #Parameter Notes
  # The regex line sometimes is broken when editing: This is the correct syntex: $ptrn = [regex]'^[A-Za-z0-9(?:()_ -]+\.[A-Za-z0-9]*$'
  # Timestamp option - $(Get-Date -UFormat '%y%m%d') 
 
  $ItemType = 'File'
  $dot = '.'
  $SplatFile = @{}

  if($Filename.Contains($dot))
  {
    $fileExt = ('{0}{1}' -f $dot, $Filename.Split($dot)[-1])
    $fileBaseName = $Filename.Replace($fileExt,'')
  }else{
  $fileBaseName = $Filename
  $fileExt =''
  }

  if($Tag)
  {
    $DatedName = ('{0}-{1}' -f $fileBaseName, $Tag)
  }
  else
  {
    $DatedName = $fileBaseName
  }
  $NewFile = ('{0}{1}' -f $DatedName, $fileExt)

  Switch ($true){
    $Amend
    {
      Write-Verbose -Message 'Amend'
      if(-not (Test-Path -Path $NewFile))
      {
        $SplatFile = @{
          Path     = $NewFile
          ItemType = $ItemType
          Force    = $false
        }
        $null = New-Item @SplatFile
      }
    }
    
    $Overwrite
    {
      Write-Verbose -Message 'Overwrite'
      $SplatFile = @{
        Path     = $NewFile
        ItemType = $ItemType
        Force    = $true
      }
      $null = New-Item @SplatFile
    }
    
    Default 
    {
      $i = 1
      if(Test-Path -Path $NewFile)
      {
        do 
        {
          $NewFile = [String]('{0}({1}){2}' -f $DatedName , $i, $fileExt)
          $i++
        }
        while (Test-Path -Path $NewFile)
      }
        
      Write-Verbose -Message 'Increment'

      $SplatFile = @{
        Path     = $NewFile
        ItemType = $ItemType
        Force    = $false
      }
      $null = New-Item @SplatFile
    }

  }

  if($Return -eq 'Filename')
  {
    Return $NewFile
  }
  elseif($Return -eq 'Filepath')
  {
    Return (Get-Item -Path $NewFile).FullName
  }
}

function Get-MyCredential
{
  <#
      .SYNOPSIS
      Stores and retrieves credentials from a file. 
    
      .DESCRIPTION
      Stores your credentials in a file and retreives them when you need them.
      Allows you to speed up your scripts.  
      It looks at when your password was last reset and forces an update to the file if the dates don't match.  
      Because this only works with the specific user logged into a specific computer the name of the file will alway have both bits of information in it.
    
      .PARAMETER Reset
      Allows you to force a password change.

      .PARAMETER Path
      Path to the credential file, if not in current directory.

      .EXAMPLE
      Get-MyCredential

      .EXAMPLE
      Get-MyCredential -Reset -Path Value
      Allows you to change (reset) the password in the password file located at the path.  Then returns the credentials

      .NOTES
      Place additional notes here.

      .LINK
      'https://github.com/KnarrStudio/ITPS.OMCS.CodingFunctions/blob/master/Scripts/Get-MyCredential.ps1'

      .INPUTS
      String

      .OUTPUTS
      Object
  #>
  [CmdletBinding(SupportsShouldProcess, PositionalBinding = $false, ConfirmImpact = 'Medium',
  HelpUri = 'https://github.com/KnarrStudio/ITPS.OMCS.CodingFunctions/blob/master/Scripts/Get-MyCredential.ps1')]
  [Alias('gmc')]
  [OutputType([Object])]
  Param
  (
    [Parameter(Mandatory = $false,Position = 0)]
    [Switch]$Reset,
    [Parameter(Mandatory = $false,Position = 1)]
    [String]$FolderPath = "$env:USERPROFILE\.PsCredentials"
  )
  Begin
  {
    #$PasswordLastSet = (Get-AdUser -Name ${env:USERNAME}).PasswordLastSet #| Select-Object -Property PasswordLastSet 
    $PasswordLastSet = (Get-LocalUser -Name ${env:USERNAME}).PasswordLastSet #| Select-Object -Property PasswordLastSet 
    $credentialPath = ('{0}\myCred_{1}_{2}.xml' -f $FolderPath, ${env:USERNAME}, ${env:COMPUTERNAME})
    
    if(-not (Test-Path -Path $credentialPath))
    {
      $null = New-Item -Path $credentialPath -ItemType File -Force
    }
    $LastWriteTime = (Get-ChildItem -Path $credentialPath).LastWriteTime

    function Script:Set-MyCredential
    {
      param
      (
        [Parameter(Mandatory = $true)]
        [string]$credentialPath
      )
      $credential = Get-Credential -Message 'Credentials to Save'
      $credential | Export-Clixml -Path $credentialPath -Force
    }    
  }
  Process
  {
    if(($Reset -eq $true) -or ($LastWriteTime -lt $PasswordLastSet))
    {
      Set-MyCredential -credentialPath $credentialPath
    }
    $creds = Import-Clixml -Path $credentialPath
  }
  End
  {
    Return $creds
  }
}


Export-ModuleMember -Function Get-Versions
Export-ModuleMember -Function Get-CurrentLineNumber
Export-ModuleMember -Function Set-SafetySwitch
Export-ModuleMember -Function Compare-FileHash
#Export-ModuleMember -Function Import-FileData ## this is going to be removed
#Export-ModuleMember -Function Send-eMail ## This has been depricated
Export-ModuleMember -Function Get-TimeStamp
Export-ModuleMember -Function New-File 
Export-ModuleMember -Function Get-MyCredential




