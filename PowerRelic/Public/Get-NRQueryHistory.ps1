<#
  .SYNOPSIS
  Queries New Relic for your NRQL query history
  
  .DESCRIPTION
  The Get-NRQLQueryHistory cmdlet queries NerdGraph for your last 100 NRQL queries.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .OUTPUTS
  accountId: New Relic account ID the NRQL query was executed against
  nrql: NRQL query syntax
  timestamp: DateTime (epoch) the NRQL query was executed

  .EXAMPLE
  PS> Get-NRQLQueryHistory -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR'
  Lists the last 100 NRQL queries executed by the owner of this Personal API Key
#>
Function Get-NRQLQueryHistory {

    [ cmdletbinding() ]
    Param (
    
        [ Parameter ( Mandatory = $true ) ] [ string ] $PersonalAPIKey
    
    )

# Set the NerdGraph URL
$nerdGraphUrl = 'https://api.newrelic.com/graphql'

# Build our authentication header
$header = @{ 'API-Key' = $PersonalAPIKey }

# Build our query payload
$historyQuery = @"
{
    "query": "{ actor { nrqlQueryHistory { accountId nrql timestamp } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $historyQuery ).data.actor.nrqlQueryHistory

RETURN $results

}
