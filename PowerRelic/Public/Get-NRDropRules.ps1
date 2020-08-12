<#
  .SYNOPSIS
  Queries an account to list all current drop rules.
  
  .DESCRIPTION
  The Get-NRDropRules cmdlet queries NerdGraph for a list of the current drop rules assigned to an account.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The New Relic Account ID to be queried against.
  
  .OUTPUTS
  error:
    .description: Detailed error message
    .reason: The category of error that occurred
  rules:
    .action: The behavior of the drop rule
    .createdAt: The DateTime this drop rule was created
    .createdBy: The user ID who created this drop rule
    .description: Additional information about this drop rule
    .id: The ID of this drop rule
    .nrql: The NRQL used to match data for this drop rule

  .EXAMPLE
  PS> Get-NRDropRules -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567
  Find and list all drop rules for Account ID 1234567
#>
Function Get-NRDropRules {

    [ cmdletbinding() ]
    Param (
    
        [ Parameter ( Mandatory = $true ) ] [ string ] $PersonalAPIKey,
        [ Parameter ( Mandatory = $true ) ] [ int ] $AccountID
    
    )

# Set the NerdGraph URL
$nerdGraphUrl = 'https://api.newrelic.com/graphql'

# Build our authentication header
$header = @{ 'API-Key' = $PersonalAPIKey }

# Build our query payload
# Build our query payload
$rulesQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { nrqlDropRules { list { error { reason description } rules { action createdAt createdBy description id nrql } } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $rulesQuery ).data.actor.account.nrqlDropRules.list

RETURN $results

}
