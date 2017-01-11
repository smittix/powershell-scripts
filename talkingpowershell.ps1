########################################################################
# Make Powershell talk
# 
# Created By: danielOS
########################################################################

#Change the city and country code for your own 
$url = 'http://api.openweathermap.org/data/2.5/weather?q=Perth,Au&units=metric'

# Change the rss feed but it needs to be an RSS with no images in the discription.
 $report = @()
[xml]$hsg = Invoke-WebRequest 'http://www.abc.net.au/news/feed/51120/rss.xml'
 $report = @()
$report += $hsg.rss.channel.item.description."#cdata-section" | Select -First 10
$report | out-file -append  "c:\News.txt"
gc c:\news.txt | Foreach-Object {$_ -replace "<p>", " "} | Set-Content c:\news2.txt
gc c:\news2.txt | Foreach-Object {$_ -replace "</p>", " "} | Set-Content c:\news.txt
Remove-Item c:\news2.txt
[net.httpWebRequest] $myRequest = [net.webRequest]::create($url)
 $myRequest.Method = "GET"
 [net.httpWebResponse] $myResponse = $myRequest.getResponse()
 $myStreamReader = New-Object IO.StreamReader($myResponse.getResponseStream())
 $myJson = $myStreamReader.ReadToEnd()
 $weatherfeed1 = $myJson | ConvertFrom-Json 
 $report = @()
$report +=  $weatherfeed1 | select-Object -ExpandProperty main | select Temp | ft -HideTableHeaders
$report | out-file -append  "c:\temp.txt"
 $report = @()
$report +=  $weatherfeed1 | select-Object -ExpandProperty Weather | select description | ft -HideTableHeaders
$report | out-file -append  "c:\lookslike.txt"
if ( (Get-Date -UFormat %p) -eq "AM" )
 { $Timeof = "Morning"}
 else {
$Timeof = "Afternoon"
}
$temp = Get-Content c:\temp.txt
$des = Get-Content c:\lookslike.txt 
$a = Get-date 
$time = "Time: " + $a.ToShortTimeString()

Add-Type -AssemblyName System.Speech
$synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
$synthesizer.Speak( "Good $Timeof my name is Mary." )
$synthesizer.Speak( "the $time" )
$synthesizer.Speak( "The current Temperature out side is $temp degrees and the $des" )

Remove-Item c:\temp.txt
Remove-Item c:\lookslike.txt


Add-Type -AssemblyName System.Speech
$synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
$synthesizer.Speak( "Here are the current headlines today." )

$news = Get-Content c:\news.txt 
foreach ($new in $news){
Add-Type -AssemblyName System.Speech
$synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
$synthesizer.Speak( "$new. " )

}
Remove-Item c:\news.txt

Add-Type -AssemblyName System.Speech
$synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
$synthesizer.Speak( "I hope you have a good $Timeof please play later for more news updates. goodbye." )