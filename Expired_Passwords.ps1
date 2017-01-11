#Get Users From AD who are enabled
Import-Module ActiveDirectory
$users = get-aduser -filter * -properties * |where {$_.Enabled -eq "True"}

foreach ($user in $users)
{

 if ($user.passwordexpired -eq "True")
 {
  write-host $user.displayname " Password Has Already Expired" 
 
 }
 elseif ($user.passwordneverexpires -ne "True")
 {
  
  $passwordSetDate = $user.PasswordLastSet
  $dfl = (get-addomain).DomainMode

  if ($dfl -eq "Windows2008Domain")
  {
   $accountFGPP = Get-ADUserResultantPasswordPolicy $user 
   

         if ($accountFGPP -ne $null) 
   {
             $maxPasswordAgeTimeSpan = $accountFGPP.MaxPasswordAge
            } 
   else 
   {
                $maxPasswordAgeTimeSpan = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge
            }
      }
      else
      {
              $maxPasswordAgeTimeSpan = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge
         }

    if ($maxPasswordAgeTimeSpan -eq $null -or $maxPasswordAgeTimeSpan.TotalMilliseconds -eq 0) 
  {
            Write-Host  "MaxPasswordAge is not set for the domain or is set to zero!"
        }
  else
  {
        
   $today = get-date
   $expireson = $passwordsetdate + $maxpasswordagetimespan
   $daystoexpire = $expireson - $today
  
   if ($daystoexpire -lt $expireindays)
   {
     $emailaddress = $null
     $emailaddress = $user.emailaddress
     
     if ($emailaddress -ne $null)
     {
     
      $subject="Your password will expire in $expireIn days"
       $body="Your password will expire in $expireIn days"
       Send-Mailmessage -smtpServer $smtpServer -from support@yourdomain.com -to $emailaddress -subject $subject -body $body -priority High 
     }
     
   }
   
  }

 }
}