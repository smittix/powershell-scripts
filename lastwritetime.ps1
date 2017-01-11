##########
# Last Write Time Polling Script
# Written by Bas Stijntjes | REV'IT! | ICT@revit.eu
#
# Used for checking a if a file has been updated in the last X minutes. 
# If not, then something must have gone wrong and send an email alert.
#
# Inspired by http://community.spiceworks.com/profile/show/TyroneSlothrop
# In http://community.spiceworks.com/topic/137779-script-for-file-detection?page=1#entry-744733
#
##########


##########
#
# First check if the parameters have been set at commandline
# If not, set a default value
#
##########

param($path,$age,$from,$to)

#Check file path parameter. if not set, use default full path to the file
if (!$path) {$path = 'C:\yourpath\yourfile.txt'} 

# Check file age in minutes. if not set, use default 20m
if (!$age) {$age = "20"}

# Check mail FROM. if not set, use default
if (!$from) {$from = "aler@yourdomain.com"}

# Check mail TO. if not set, use default
if (!$to) {$to = "yourmail@yourdomain.com"}

##########
#
# We don't want error output to show up, so Keep calm and carry on.
#
##########

$erroractionpreference="SilentlyContinue"

##########
#
# Now set the email settings
#
##########

# specify the SMTP server 
$smtp = "yourmailserver"

# specify the subject of the alert email 


##########
#
# Create a Function to wrap your email sending task
#
##########

function send-email {
Send-MailMessage -Body "$body" -to $to -from $from `
-Subject "$subject" -smtp $smtp
}

##########
#
# And now for the actual action.
#
##########


# Check if the file exists. If not, send an email
if (!$(get-childitem $path)) {
    write-host "$path doesn't exist"
    $body = "$path doesn't exist"
    send-email}

Else {
    # Get LastWriteTime of the file
    $LW = (get-childitem $path).LastWriteTime
    
    # Check if the LastWriteTime is older than X minutes. if it is; send an email
    if ($LW -lt (get-date).AddMinutes(-$age) ) { 
    write-host "$path is older than $age minutes. Last write was $LW"
    $subject = "ALERT: something is wrong!"
    $Body = "$path is older than $age minutes. Last write was $LW"
    send-email } 
    
    # For testing purposes, also send an email if the file has been updated; you can comment this out. 
    Else { 
    write-host "Dont panic; $path is updated in the last $age minutes. Last write was $LW"
    $subject = "Everything OK" 
    $Body = "$path is updated in the last $age minutes. Last write was $LW"
    send-email }  
     
     
    }

#End