<#
.SYNOPSIS
Returns the last logon times of one or all users in AD.
.DESCRIPTION
LastLogon will return the lastlogon times of all users, or just one user depending on the parameters supplied.
.PARAMETER User
The user you would like to get the lastlogon time for.
.EXAMPLE
LastLogon

Returns a list of the lastlogon times for all users.
.EXAMPLE
LastLogon Twon.of.An

Returns the lastlogon time of Twon.of.An
.NOTES
Author: Twon of An
.LINK
Get-ADUser -properties lastlogon
#>
Function LastLogon
{
	param
	(
		[Parameter(ValueFromPipeline=$true)]
		[String]$user
	)
	$A = @()
	If(!$user)
	{
		$PSusers = Get-ADuser -filter * -properties lastlogon
		ForEach($PSuser in $PSusers)
		{
			If(($PSuser.lastlogon) -and ($PSuser.lastlogon -ne 0))
			{
				$obj = New-Object System.Object
				$obj | add-member -type NoteProperty -name Name -value $PSuser.name
				$obj | add-member -type NoteProperty -name Logon -value ([datetime]::fromfiletime($PSuser.lastlogon))
				$A += $obj
			}
		}
	}
	Else
	{
		$PSuser = Get-ADuser $user -properties lastlogon
		If($PSuser)
		{
			$obj = New-Object System.Object
			$obj | add-member -type NoteProperty -name Name -value $PSuser.name
			$obj | add-member -type NoteProperty -name Logon -value ([datetime]::fromfiletime($PSuser.lastlogon))
			$A += $obj
		}
	}
	$A
}