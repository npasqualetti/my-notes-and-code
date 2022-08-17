#This code checks if a file exists in a computer group in AD. Great for checking if packages or files are copied to computers.
#You need to download AD powershell tools
$Collection = Get-ADComputer -filter * -SearchBase "OU=Cincinnati,OU=Computer Groups,DC=contosco,DC=com" | Select-Object SamaccountName
$SamaccountName = $Collection.SamaccountName
foreach ($item in $SamaccountName) {
  $item = $item -replace ".$"
  if (Test-Path \\$item\C$\Temp\file.txt) {
    echo "File is here"
  }else{
    echo (Get-ADComputer -filter "Name -like '$item'" -Properties *).SamaccountName >> C:\Temp\file-check.txt
    echo (Get-ADComputer -filter "Name -like '$item'" -Properties *).Description >> C:\Temp\file-check.txt
  }
}
