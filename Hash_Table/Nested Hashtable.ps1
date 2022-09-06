#Nested Hashtable

$nht = @{
  Main1 = 'apples'
  Main2 = @{
    Sub1 = 'c:\temp\'
    Sub2 = 'Pumkin'
  }
  Main3 = 'testing'
  Main4 = @{
    Sub1 = 'c:\temp\'
    Sub2 = 'grapes'
  }
}

$nht.Main2.Sub2