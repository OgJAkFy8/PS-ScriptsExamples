$Secure = Read-Host -AsSecureString
$Encrypted = ConvertFrom-SecureString -SecureString $Secure -Key (1..16)
$Encrypted | Set-Content Encrypted.txt
Get-Content Encrypted.txt | ConvertTo-SecureString -Key (1..16)

$Secure_String_Pwd = ConvertTo-SecureString "P@ssW0rD!" -AsPlainText -Force


if((Get-ChildItem -Path Cert:\CurrentUser\My\).Subject -notcontains 'CN=MyCodeSigning')
{
  $null = New-SelfSignedCertificate -DnsName MyCodeSigning2 -FriendlyName MyCodeSigning2 -CertStoreLocation Cert:\CurrentUser\My\ -Type Codesigning
}

Set-AuthenticodeSignature -FilePath .\Friday-Power1.ps1 -Certificate (Get-ChildItem -Path Cert:\CurrentUser\My\09FF605E7259939F084A2D043CD4CFDF19308CB9 -CodeSigningCert)
(Get-ChildItem -Path Cert:\CurrentUser\My\ -CodeSigningCert) | Where-Object -Property Subject -Match -Value 'Knarrstudio'


$scripts = Get-ChildItem -Path C:\Users\erika\Documents\GitHub\Tools-DeskSideSupport\Scripts

Foreach($scrpt in $scripts.fullname)
{
  Set-AuthenticodeSignature -FilePath $scrpt  -Certificate (Get-ChildItem -Path Cert:\CurrentUser\My\d* -CodeSigningCert)
}


