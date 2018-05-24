$urls = Get-Content -Path "<PATH>\raw_uber_data_urls.txt"
$destfolder = "<PATH>\Azure\Azure SQLDW\NYC Data\Uber\"
foreach ($url in $urls)
{
    $dest = $url -split "data/"
    $output =$destfolder+$dest[1]
    Start-BitsTransfer -Source $url -Destination $output
}
