<#
  .SYNOPSIS
  Lists Alert Policies for an account.
  
  .DESCRIPTION
  The Get-NRAlertPolicies cmdlet queries NerdGraph for either a specific alert policy by ID, or a list of all alert policies within an account.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The New Relic Account ID to be queried against.
  
  .PARAMETER PolicyID
  [OPTIONAL] A single Alert Policy ID to be queried.
  
  .OUTPUTS
  id: Alert Policy ID
  incidentPreference: Alert Policy Incident Preference
  name: Alert Policy Name
  
  .EXAMPLE
  PS> Get-NRAlertPolicies -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567
  List all Alert Policies for Account ID 1234567
  
  .EXAMPLE
  PS> Get-NRAlertPolicies -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567 -PolicyID 98765
  Find and list Alert Policy ID 98765 for Account ID 1234567
#>
Function Get-NRAlertPolicies {

[ cmdletbinding() ]
Param (

    [ Parameter ( Mandatory = $true ) ] [ string ] $PersonalAPIKey,
    [ Parameter ( Mandatory = $true ) ] [ int ] $AccountID,
    [ Parameter ( Mandatory = $false ) ] [ int ] $PolicyID

)

# Set the NerdGraph URL
$nerdGraphUrl = 'https://api.newrelic.com/graphql'

# Build our authentication header
$header = @{ 'API-Key' = $PersonalAPIKey }

# Build our query payload based on whether $PolicyID is provided or not

If( $PolicyID ) {

$alertPolicyQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { alerts { policiesSearch(searchCriteria: {ids: $PolicyID}) { policies { id name incidentPreference } } } } } }",
    "variables": null
}
"@

}

Else {

$alertPolicyQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { alerts { policiesSearch { policies { id name incidentPreference } } } } } }",
    "variables": null
}
"@

}
# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $alertPolicyQuery ).data.actor.account.alerts.policiesSearch.policies

RETURN $results

}
