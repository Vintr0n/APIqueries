Dim oXMLHTTP
Dim oStream

Set oXMLHTTP = CreateObject("Msxml2.XMLHttp.6.0")

oXMLHTTP.Open "GET", "https://api.coinbase.com/v2/prices/LINK-GBP/sell", False
oXMLHTTP.SetRequestHeader "Authentiction", "0123456789"
oXMLHTTP.Send

If oXMLHTTP.Status = 200 Then
    Set oStream = CreateObject("ADODB.Stream")
    oStream.Open
    oStream.Type = 1
    oStream.Write oXMLHTTP.responseBody
    oStream.SaveToFile "output.txt",2
    oStream.Close

End If