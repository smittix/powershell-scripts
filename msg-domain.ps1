Try { 

    Import-Module ActiveDirectory -ErrorAction Stop 
    
}

Catch { 

    Write-Host `
        "Unable to load Active Directory module, is RSAT installed?" `
        -ForegroundColor Red
    Exit 

}

$computers = Get-ADComputer -Filter * | 
select-object -expandproperty name

ForEach ($computer in $computers) {

$msg = read-host "Please enter your message" 

    Invoke-WmiMethod `
        -Path Win32_Process `
        -Name Create `
        -ArgumentList "msg * /time:600 $msg" `
        -ComputerName $computer

}