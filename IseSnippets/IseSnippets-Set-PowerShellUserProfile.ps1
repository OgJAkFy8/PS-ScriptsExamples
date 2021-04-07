
$Cred = Get-Credential
$PSDefaultParameterValues.Add("*:Credential",$Cred)
$PSDefaultParameterValues.Add("Get-ChildItem:Force",$True)
$PSDefaultParameterValues.Add("Receive-Job:Keep",$True)
$PSDefaultParameterValues.Add("Format-Table:AutoSize",{if ($host.Name -eq "ConsoleHost"){$true}})
$PSDefaultParameterValues.Add("Send-MailMessage:To","<emailaddress>")
$PSDefaultParameterValues.Add("Send-MailMessage:SMTPServer","mail.whatever.com")
$PSDefaultParameterValues.Add("Update-Help:Module","*")
$PSDefaultParameterValues.Add("Update-Help:ErrorAction","SilentlyContinue")
$PSDefaultParameterValues.Add("Test-Connection:Quiet",$false)
$PSDefaultParameterValues.Add("Test-Connection:Count","1")

