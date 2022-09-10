function Convert-IPtoBinary
{
  
  param
  (
    [IpAddress]$dottedDecimal
  )
$dottedDecimal.split('.') | ForEach-Object -Process {
    $binary = $binary + $([convert]::toString($_,2).padleft(8,'0'))
  }
  return $binary
}

#^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$


