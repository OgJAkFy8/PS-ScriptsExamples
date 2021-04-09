  [CmdletBinding()]
  param
  (
    [string]$Title = 'Title',

    [String[]]$Systems = 'Generikstorage',

    $reportpath = '.\ADReport.htm',

    [string]$TitleColor = 'Red',

    [string]$LineColor = 'Yellow',

    [string]$MenuItemColor = 'Cyan'
  )

  Begin {
    # Set Variables
    $i = 1
    $InsertTab = "`t"
  } 
    
  Process {
    if((Test-Path -Path $reportpath) -like $false)
    {
      New-Item -Path $reportpath -ItemType file
    }
    $smtphost = 'smtp.labtest.com' 
    $from = 'DoNotReply@labtest.com' 
    $email1 = 'Sukhija@labtest.com'
    $timeout = '60'

    ###############################HTml Report Content############################
    $report = $reportpath

    $reportHeader = (@'
<html> 
<head> 
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'> 
'<title>{0}</title>' 
'<STYLE TYPE=text/css>' 
</style> 
</head> 
<body> 
<table width='100%'> 
<tr bgcolor='Lavender'> 
<td colspan='7' height='25' align='center'> 
<font face='tahoma' color='#003399' size='4'><strong>Active Directory Health Check</strong></font> 
</td> 
</tr> 
</table> 
 
<table width='100%'> 
<tr bgcolor='IndianRed'> 
<td width='5%' align='center'><B>Identity</B></td> 
<td width='10%' align='center'><B>PingSTatus</B></td> 

<td width='10%' align='center'><B>FSMOCheckTest</B></td>
 
</tr> 
'@ -f $Title)

$reportHeader | Out-File -FilePath $report -Force


foreach ($System in $Systems)
{
  $Identity = $System
  Add-Content -Path $report -Value '<tr>'
  if ( Test-Connection -ComputerName $Identity -Count 1 -ErrorAction SilentlyContinue ) 
  {
    Write-Verbose -Message $System
 
    Add-Content -Path $report -Value ("<td bgcolor= 'GainsBoro' align=center>  <B> {0}</B></td>" -f $Identity) 
    Add-Content -Path $report -Value "<td bgcolor= 'Aquamarine' align=center>  <B>Success</B></td>" 


    ########################################################
    ####################FSMOCheck status##################
    <#    Add-Type -AssemblyName microsoft.visualbasic 
        $cmp = 'microsoft.visualbasic.strings' -as [type]
        $sysvol = Start-Job -ScriptBlock {
        dcdiag /test:FSMOCheck /s:$($args[0])
        } -ArgumentList $DC
        Wait-Job $sysvol -Timeout $timeout
        if($sysvol.state -like 'Running')
        {
        Write-Host $DC `t FSMOCheck Test TimeOut -ForegroundColor Yellow
        Add-Content $report -Value "<td bgcolor= 'Yellow' align=center><B>FSMOCheckTimeout</B></td>"
        Stop-Job $sysvol
        }
        else
        {
        $sysvol1 = Receive-Job $sysvol
        if($cmp::instr($sysvol1, 'passed test FsmoCheck'))
        {
        Write-Host $DC `t FSMOCheck Test passed -ForegroundColor Green
        Add-Content $report -Value "<td bgcolor= 'Aquamarine' align=center><B>FSMOCheckPassed</B></td>"
        }
        else
        {
        Write-Host $DC `t FSMOCheck Test Failed -ForegroundColor Red
        Add-Content $report -Value "<td bgcolor= 'Red' align=center><B>FSMOCheckFail</B></td>"
        }
    }#>
    ########################################################
  } 
  else
  {
    Write-Verbose -Message $System
    Add-Content -Path $report -Value ("<td bgcolor= 'GainsBoro' align=center>  <B> {0}</B></td>" -f $Identity) 
    Add-Content -Path $report -Value "<td bgcolor= 'Red' align=center>  <B>Ping Fail</B></td>" 
    Add-Content -Path $report -Value "<td bgcolor= 'Red' align=center>  <B>Ping Fail</B></td>" 
    Add-Content -Path $report -Value "<td bgcolor= 'Red' align=center>  <B>Ping Fail</B></td>" 
    Add-Content -Path $report -Value "<td bgcolor= 'Red' align=center>  <B>Ping Fail</B></td>" 
    Add-Content -Path $report -Value "<td bgcolor= 'Red' align=center>  <B>Ping Fail</B></td>"
    Add-Content -Path $report -Value "<td bgcolor= 'Red' align=center>  <B>Ping Fail</B></td>"
    Add-Content -Path $report -Value "<td bgcolor= 'Red' align=center>  <B>Ping Fail</B></td>"
    Add-Content -Path $report -Value "<td bgcolor= 'Red' align=center>  <B>Ping Fail</B></td>"
    Add-Content -Path $report -Value "<td bgcolor= 'Red' align=center>  <B>Ping Fail</B></td>"
  }
} 

Add-Content -Path $report -Value '</tr>'
############################################Close HTMl Tables###########################


Add-Content -Path $report  -Value '</table>' 
Add-Content -Path $report -Value '</body>' 
Add-Content -Path $report -Value '</html>' 




  
  }


  End
  {
    ########################################################################################
    #############################################Send Email#################################

    $subject = 'Active Directory Health Monitor' 
    $body = Get-Content -Path '.\ADreport.htm' 
    $smtp = New-Object -TypeName System.Net.Mail.SmtpClient -ArgumentList $smtphost 
    $msg = New-Object -TypeName System.Net.Mail.MailMessage 
    $msg.To.Add($email1)
    $msg.from = $from
    $msg.subject = $subject
    $msg.body = $body 
    $msg.isBodyhtml = $true 
  $smtp.send($msg)  }



         	
		