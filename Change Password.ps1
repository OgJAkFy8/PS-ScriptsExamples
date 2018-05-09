Set-ADAccountPassword -Identity brushde-p -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "1qaz@WSX3edc!QAZ" -Force)


[int]$i = 33; 
do {
    Invoke-WebRequest "http://rsrcngmws01.rsrc.osd.mil:81/DODIDCA_$i.crl" -OutFile ".\DODIDCA_$i.crl"
    $i++; 
    }
 while ($i -lt 43)
