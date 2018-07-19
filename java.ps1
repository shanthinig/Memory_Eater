param([string] $path)
write-host "Java Installation begins" 
(new-object System.Net.WebClient).Downloadfile('http://scriptingteam.s3.amazonaws.com/corentrepo/workloads/windows/Java/jdk-8u66-windows-x64.exe', 'C:\jre-8u91-windows-x64.exe')
start-process -FilePath "C:/jre-8u91-windows-x64.exe" -passthru -wait -ArgumentList "INSTALL_SILENT=1 SPONSORS=0 NOSTARTMENU=1 REBOOT=0 EULA=0 STATIC=1" ;
del C:\jre-8u91-windows-x64.exe
write-host $path
$XmlDocument = [xml](Get-Content -Path $path/input/body.xml)
$var=$($XmlDocument.SelectSingleNode("//saasbox/nodes/node[@name = 'dbnode']")).SelectSingleNode("//devices/device/publicip").InnerText
echo $var
cd $path
(Get-Content jtrac.properties) | ForEach-Object { $_ -replace "localhost", $var } | Set-Content jtrac.properties
#copy-item -path ./jtrac.properties -destination $HOME\.jtrac\ –recurse