$WebResponse = Invoke-WebRequest https://api.coinbase.com/v2/prices/LINK-GBP/sell
$WebResponse.Content > output.txt
