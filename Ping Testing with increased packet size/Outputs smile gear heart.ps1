function Answer-Yes {
$ary = @('y','Y'),@('e','E'),@('s','S')
$ary | ForEach-Object{
$NewAns += $_}
$length = $ary.Length

$Ans = for($i=0;$i -le $($length-1) ;++$i){$ary[$i][(random(0..1))]}
$blackpower = [string]$Ans.Replace(' ','')

$blackpower.Replace(' ','')
}

$greenCheck = @{
  Object = [Char]8730
  ForegroundColor = 'Green'
  NoNewLine = $true
  }

Write-Host "Status check... " -NoNewline
Start-Sleep -Seconds 1
Write-Host @greenCheck
Write-Host " (Done)"

$RedX = @{
  Object = [Char]03C7
  ForegroundColor = 'Red'
  NoNewLine = $true
  }

Write-Host "Status check... " -NoNewline
Start-Sleep -Seconds 1
Write-Host @RedX
Write-Host " (Done)"

$symbols = [PSCustomObject] @{
    SMILEY_WHITE = ([char]9786)
    SMILEY_BLACK = ([char]9787)
    GEAR = ([char]9788)
    HEART = ([char]9829)
    DIAMOND = ([char]9830)
    CLUB = ([char]9827)
    SPADE = ([char]9824)
    CIRCLE = ([char]8226)
    NOTE1 = ([char]9834)
    NOTE2 = ([char]9835)
    MALE = ([char]9794)
    FEMALE = ([char]9792)
    YEN = ([char]165)
    COPYRIGHT = ([char]169)
    PI = ([char]960)
    TRADEMARK = ([char]8482)
    CHECKMARK = ([char]8730)
}




"$([char]0x1b)[92m$([char]8730) $([char]0x1b)[91m×]"

