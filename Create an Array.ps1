$Test = Invoke-Command -ComputerName "" -ScriptBlock {bpclimagelist -U -client WIPRDSHWWPAM01}

$BackupsCatalogWW = Invoke-Command -ComputerName "" -ScriptBlock {bpdbjobs -u -M  MARS }
$BackupsCatalogSM = Invoke-Command -ComputerName "" -ScriptBlock {bpdbjobs -u -M ucprdtesmnbm01}



$ResultsWW = $BackupsCatalogWW.Split("`r`n")  -replace "Dest Media Svr","DestMediaSvr" -replace "Active PID","ActivePID" -replace '\s+',"," -replace ",JobID","JobID"
$ResultsSM = $BackupsCatalogSM.Split("`r`n")  -replace "Dest Media Svr","DestMediaSvr" -replace "Active PID","ActivePID" -replace '\s+',"," -replace ",JobID","JobID"

#declare\initialise variables
$columnCount = "10"
$splitChar = ","
$columnTitles = @()
$resultArray= @()



$ResultsSMminus = $ResultsSM | select -Skip 1

[]


$CombinedResults = $ResultsWW + $ResultsSMminus



#$columnTitles = $results[0] -split ","

foreach($line in $CombinedResults){
    $lineObject = New-Object System.Object   
        if($line -ne $null)
        { 
        $lineSplit = $line.Split($splitChar)
        if($lineSplit.Count -eq $columnCount)
        { 
        if($columnTitles.Count -ne $columnCount)
        {
        $columnTitles = $lineSplit
        }
        else
        {
        for($i=0;$i -lt $columnCount;$i++) 
        {  
        if(($lineSplit[$i] -ne $null) -or ($lineSplit[$i] -ne " "))
        {       
        $lineObject | Add-Member -type NoteProperty -name $columnTitles[$i] -Value $lineSplit[$i]
        } 
        }     
        $resultArray += $lineObject
        }
        }
        }
        }
 
#Return $resultArray



$Uniques = $resultArray.client | select -Unique



Write-host "Total Number of Lines in RAW format: " $CombinedResults.count
Write-host "Total Number of Lines in results: " $resultArray.count
Write-host "Total Number of Unique records: " $uniques.count
