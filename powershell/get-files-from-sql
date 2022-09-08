$ServerName = "SQL"
$DatabaseName = "Database1"
$data = 11111,22222

#Timeout Params
$QueryTimeout = 120
$ConnectionTimeout = 30

#Action of connecting to the Database and executing the query and returning results if there were any.
$conn=New-Object System.Data.SqlClient.SQLConnection
$ConnectionString = "Server={0};Database={1};Integrated Security=True;Connect Timeout={2}" -f $ServerName,$DatabaseName,$ConnectionTimeout
$conn.ConnectionString=$ConnectionString
$conn.Open()


foreach ($case in $data){
    $Query = "SELECT * FROM [ECM].[dbo].[Files] INNER JOIN [ECM].[dbo].[Folders] ON Files.FolderID=Folders.ID WHERE DisplayName like '%$case%' and IsLatestRevision like '1' and Name like '%Completed Case File%'"
    $Query >>'C:\Users\Nick\Desktop\Data\logs\sqlcommands.txt'
    $cmd=New-Object system.Data.SqlClient.SqlCommand($Query,$conn)
    $cmd.CommandTimeout=$QueryTimeout
    $ds=New-Object system.Data.DataSet
    $da=New-Object system.Data.SqlClient.SqlDataAdapter($cmd)
    [void]$da.fill($ds)
    $ds.Tables >> 'C:\Users\Nick\Desktop\Data\logs\filelog.txt'
    foreach ($item in $ds.tables.Location)
    {
        $RealLocation = $Item.Remove(0,4)
        $FileLocation = '\\PC-1\Storage\' + $RealLocation + '\*'
        New-Item "C:\Users\Nick\Desktop\Data\logs\$case" -Type Directory
        $FileLocation >> "C:\Users\Nick\Desktop\Data\logs\$case\filelocationlog.txt"
        New-Item "C:\Users\Nick\Desktop\Data\$case" -Type Directory
        Copy-Item -Path $FileLocation "C:\Users\Nick\Desktop\Data\$case\" -Recurse
    }

}

$conn.Close()
