Function ConvertTo-Ascii ($String) {
($String.ToCharArray() | %{([byte][char]$_)}) -join '|'
}

# Ascii Example: '101|114|105|107|64|69|77|65|73|76|46|99|111|109'
Function ConvertFrom-Ascii ($AsciiString) {
($AsciiString.Split('|') | %{[Char][Byte]$_}) -join ''
}

# Oneliner
# ('101|114|105|107|64|69|77|65|73|76|46|99|111|109'.Split('|') | %{[Char][Byte]$_ }) -join ''
