#requires -Version 3.0 -Modules Microsoft.PowerShell.Utility

#This information can be generated from the main script:
$AttachedFile   = 'C:\temp\menu.csv'
$EmailMessage   = ' "EmailMessage" must be a string that specifies the content of the email message.'
# $EmailMessage  = $EmailMessage + $MessageString 
# $EmailMessage  = "C:\Users\New User\Desktop\test-html.html"
# $EmailMessage  = "C:\Users\New User\Desktop\test-test.txt"

$MessageString = (@'

DoD Visitor restarted on {0}

Process status BEFORE restart
{1}

Service status BEFORE restart
{2}

Process status AFTER restart
{3}

Service status AFTER restart
{4}

END OF TIMESTAMP
'@ -f ($env:computername), ($bproc), ($bsrvc), ($aproc), ($asrvc))




<# 
    The region below is portable.  
    In other words, it has been written to be used in many differnet scripts.
    If you choose to do that, then;
    1. Copy the "Function Send-Email" and paste it into your script.
    2. Copy and modify the "SplatSendEmail" hashtable as needed
    3. Make sure the command "Send-eMail @SplatSendEmail" line is located below the function and the Splat

    The "SplatSendEmail" is only to ease the "loading" of the parameters 
    by moving the customization to the top of the script.
#>


#region Portable_Section 

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

#region Portable_Function

function Send-eMail
{
  [CmdletBinding(DefaultParameterSetName = 'Default')]
  param
  (
    [Parameter(Mandatory,HelpMessage = 'To email address(es)', Position = 0)]
    [String[]]$MailTo,
    [Parameter(Mandatory,HelpMessage = 'From email address', Position = 1)]
    [Object]$MailFrom,
    [Parameter(Mandatory,HelpMessage = 'Email subject', Position = 2)]
    [Object]$msgsubj,
    [Parameter(Mandatory,HelpMessage = 'SMTP Server(s)', Position = 3)]
    [String[]]$SmtpServers,
    [Parameter(Position = 4)]
    [AllowNull()]
    $MessageBody,
    [Parameter(Position = 5)]
    [AllowNull()]
    [Object]$AttachedFile,
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
    if(Test-Path $MessageBody)
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
      Write-Host -Object ("`nsuccessful from {0}" -f $SMTPServer) -ForegroundColor green
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

#endregion Portable_Function

Send-eMail @SplatSendEmail 

#endregion Portable_Section
