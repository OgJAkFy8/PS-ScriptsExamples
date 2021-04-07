
$m = @'

$hash = '3C7AB09DDF9D79C4A7CC252BCCBA0A1F7CB57E691A6EF5750A0C080FCCA889F6' # File Hash as string
Compare-Object $(Get-FileHash .\Downloads\filename).hash -DifferenceObject $hash -IncludeEqual

<#
Matching Example:
InputObject                                                      SideIndicator
-----------                                                      -------------
3C7AB09DDF9D79C4A7CC252BCCBA0A1F7CB57E691A6EF5750A0C080FCCA889F6 ==

Non-matching Example:
InputObject                                                      SideIndicator
-----------                                                      -------------
3C7AB09DDF9D79C4A7CC252BCCBA0A1F7CB57E691A6EF5750A0C080FCCA889F  =>
3C7AB09DDF9D79C4A7CC252BCCBA0A1F7CB57E691A6EF5750A0C080FCCA889F6 <=
#>


'@
New-IseSnippet -Text $m -Title 'ks: Compare-FileHash' -Description 'Compare file hash.' -Author 'Knarr Studio'
