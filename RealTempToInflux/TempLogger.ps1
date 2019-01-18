
$influxserver="http://10.10.21.5:8086"
$influxuser="pshell"
$influxpass="pshell"
$db="PowershellStats"
$ServicePoint = [System.Net.ServicePointManager]::FindServicePoint($influxserver+"/write?db=$db")

function post-influx {
Param(
  [string]$data
  )

$authheader = "Basic " + ([Convert]::ToBase64String([System.Text.encoding]::ASCII.GetBytes($influxuser+":"+$influxpass)))
$uri = $influxserver+"/write?db="+$db
Invoke-RestMethod -Headers @{Authorization=$authheader} -Uri $uri -Method POST -Body $data
}

while($true){
$data=Import-Csv "C:\Program Files (x86)\TempLogger\RealTempLog.csv"
$avTemp=([int]$data[-1].cpu_0 + [int]$data[-1].cpu_1 + [int]$data[-1].cpu_2 + [int]$data[-1].cpu_3) /4
$postdata = "Temperature,Host=Mind value="+$avTemp
$postdata
post-influx -data $postdata
$ServicePoint.CloseConnectionGroup("")
Remove-Item "C:\Program Files (x86)\TempLogger\RealTempLog.csv"
start-sleep 30

}
