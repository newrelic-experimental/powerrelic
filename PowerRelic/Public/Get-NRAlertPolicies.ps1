#region Top of Script

#requires -version 2

<#
.SYNOPSIS
    Function to list New Relic Alert Policies for an account

.DESCRIPTION
    https://rpm.newrelic.com/api/explore/alerts_policies/list
    https://docs.newrelic.com/docs/alerts/rest-api-alerts/new-relic-alerts-rest-api/rest-api-calls-new-relic-alerts#policies-list

.EXAMPLE
    Get-NRAlertPolicies -AccountAPIKey '1a2b3c4d5e6f'
        List all Alert Policies for an Account
		
	Get-NRAlertPolicies -AccountAPIKey '1a2b3c4d5e6f' -FilterName 'abcdefg'
        List all Alert Policies for an Account, using the search pattern *abcdefg*
		Note the -ExactMatch parameter is defaulted to 'false'
	
	Get-NRAlertPolicies -AccountAPIKey '1a2b3c4d5e6f' -FilterName 'abcdefg' -ExactMatch true
        List all Alert Policies for an Account, with a filter for an exact match of 'abcdefg'

.NOTES
    Version:        1.0
    Author:         Zack Mutchler
    Creation Date:  12/31/2019
    Purpose/Change: Initial Script development
#>

#endregion

#####-----------------------------------------------------------------------------------------#####

Function Get-NRAlertPolicies {

    Param (

        [ Parameter (Mandatory = $true ) ] [ string ] $AccountAPIKey,
        [ Parameter (Mandatory = $false ) ] [ string ] $FilterName,
        [ Parameter (Mandatory = $false ) ] [ ValidateSet( 'true', 'false' ) ] [ string ] $ExactMatch = 'false'

    )

# Set the target URI if no FilterName is provided
If ( ( !$FilterName ) ) {

$getPoliciesUri = "https://api.newrelic.com/v2/alerts_policies.json"

}

# Set the target URI with provided filter
Else {

$getPoliciesUri = "https://api.newrelic.com/v2/alerts_policies.json/?filter[name]=" + $FilterName + '&filter[exact_match]=' + $ExactMatch

}

# Set the headers to pass
$headers = @{ 'X-Api-Key' = $AccountAPIKey; 'Content-Type' = 'application/json' }

# Query the API
Write-Host "Query URL: $( $getPoliciesUri )" -ForegroundColor Cyan
$results = ( Invoke-RestMethod -Method Get -Uri $getPoliciesUri -Headers $headers ).policies

RETURN $results

}