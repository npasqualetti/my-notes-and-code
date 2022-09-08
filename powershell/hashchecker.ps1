#This script will automatically email that something is wrong with the previous night's consitency check. 

start-transcript -path C:\HashCheck\debug.log

####### OLD HASH CHECK WOULD READ ALL BYTES IN A FODLER
#
#function Get-FolderHash ($folder) {
#    dir $folder -Recurse |?{!$_.psiscontainer} | %{[Byte[]]$contents += [System.IO.file]::ReadAllBytes($_.fullname)}
#    $hasher = [System.Security.Cryptography.SHA1]::Create()
#    [string]::Join("",$($hasher.computehash($contents) | %{"{0:x2}" -f $_}))
#    }
#
#######

#######
#
#function Get-FolderHash ($folder) {
#    dir $folder -Recurse |?{!$_.psiscontainer} | %{[String[]]$contents += [System.IO.file]::GetLastWriteTimeUtc($_.fullname)}
#    $encoder = New-Object System.Text.UTF8Encoding
#    $contentsEncoded = $encoder.GetBytes($contents)
#    $hasher = [System.Security.Cryptography.SHA1]::Create()
#    [string]::Join("",$($hasher.computehash($contentsEncoded) | %{"{0:x2}" -f $_}))
#    }
#
#######

#UNNOTE AND UPDATE WITH THE CORRECT INSTRUMENT CSV!
$referencecsvPath = "C:\hashcheck\source-destination-backup.csv"
$referencecsv = Import-csv -path $referencecsvPath -Header "source", "destination"
$referencecsvLength = $referencecsv.count


for ($z=0; $z -le $referencecsvLength-1; $z++) {

    $csvPath = $referencecsv.source[$z]
    $csv = Import-csv -path $csvPath -Header "source", "destination"
    $csvLength = $csv.count
    $date = get-date -UFormat "%m_%d_%Y"

        for ($i=0; $i -le $csvLength-1; $i++) {

#            try {


                $sourceHashLocation = $csv.source[$i]
                Write-Output "Source Location: $sourceHashLocation" >> "C:\HashCheck\logs\hashcheck_log_$date.txt"
                #$hashstring1 = Get-FolderHash "$sourceHashLocation"
                $hashstring1 = .\du.exe $sourceHashLocation | Select-String -Pattern 'Size:'
                $hashstuff1 = $hashstring1.ToString()
                #Write-Output "Source Location Hash: $hashstring1" >> "C:\HashCheck\logs\hashcheck_log_$date.txt"
                $hashstring1 >> "C:\HashCheck\logs\hashcheck_log_$date.txt"
                Write-Output ""  >> "C:\HashCheck\logs\hashcheck_log_$date.txt"

                $destinationHashLocation = $csv.destination[$i]
                Write-Output "Destination Location: $destinationHashLocation" >> "C:\HashCheck\logs\hashcheck_log_$date.txt"
                #$hashstring2 = Get-FolderHash "$destinationHashLocation"
                $hashstring2 = .\du.exe $destinationHashLocation | Select-String -Pattern 'Size:'
                $hashstuff2 = $hashstring2.ToString()
                #Write-Output "Destination Location Hash: $hashstring2" >> "C:\HashCheck\logs\hashcheck_log_$date.txt"
                $hashstring2 >> "C:\HashCheck\logs\hashcheck_log_$date.txt"
                Write-Output ""  >> "C:\HashCheck\logs\hashcheck_log_$date.txt"

                    if ($hashstuff1 -eq $hashstuff2) {
                        Write-Output "Yay! Consistency check passed" >> "C:\HashCheck\logs\hashcheck_log_$date.txt"
                        Write-Output ""  >> "C:\HashCheck\logs\hashcheck_log_$date.txt"
                        #Send-MailMessage -SmtpServer "ML370" -From "ConsistencyCheck@test.local" -to npasqualetti@test.local -subject "Consistency Check SUCCESS for $($sourceHashLocation)" -Body "Successful consitency check from $($sourceHashLocation) to $($destinationHashLocation). This email is automated, please direct questions to help@test.local"
                    }else{
                        Write-Output "Sad.. Consistency check failed and I'm going to send an email!" >> "C:\HashCheck\logs\hashcheck_log_$date.txt"
                        Write-Output "" >> "C:\HashCheck\logs\hashcheck_log_$date.txt"
                        Send-MailMessage -SmtpServer "ML370" -From "ConsistencyCheck@test.local" -to npasqualetti@test.local -subject "Consistency Check FAILED for $($sourceHashLocation)" -Body "Failed consitency check from $($sourceHashLocation) to $($destinationHashLocation). If there was an execption previous to receiving this email, you can ignore. If not, ensure that the computer is powered on, locked-up, needs a restart, etc. This email is automated from Utility-1 C:\HashCheck, please direct questions to help@test.local"
                    }

            }#catch{

                #Write-Host "BOOO! Catch this error"  
                #Send-MailMessage -SmtpServer "ML370" -From "ConsistencyCheck@test.local" -to help@test.local -subject "Consistency Check EXCEPTION for $($sourceHashLocation)" -Body "Failed consitency check from $($sourceHashLocation) to $($destinationHashLocation). Ensure that files are not in use. This email is automated from Utility-1 C:\HashCheck, please direct questions to help@test.local"
        #}
    #}
}

Send-MailMessage -SmtpServer "ML370" -From "ConsistencyCheck@test.local" -to npasqualetti@test.local -subject "Consistency Check Log $date" -Body "This email is automated from Utility-1 C:\HashCheck, please direct questions to help@test.local" -Attachments "C:\HashCheck\logs\hashcheck_log_$date.txt"

Stop-Transcript
