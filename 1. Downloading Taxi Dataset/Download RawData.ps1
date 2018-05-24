$urls = Get-Content -Path "<PathToURLFile>\raw_uber_data_urls.txt"
$destfolder = "<PathToDownloadDataTo>\NYC Data\Uber\"
foreach ($url in $urls)
{
    $dest = $url -split "data/"
    $output =$destfolder+$dest[1]
    Start-BitsTransfer -Source $url -Destination $output
}
