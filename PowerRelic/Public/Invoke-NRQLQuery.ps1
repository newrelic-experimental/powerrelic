<#
  .SYNOPSIS
  Queries an account for the current license key.
  
  .DESCRIPTION
  The Invoke-NRQLQuery cmdlet queries NerdGraph for the current license key assigned to an account.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The New Relic Account ID to be queried against.
  
  .PARAMETER NRQLQuery
  [REQUIRED] The NRQL query to be sent to NerdGraph.
  
  .OUTPUTS
  nrql: The NRQL query string
  results: The query results; this is a flat list of objects who's structure matches the query submitted
  totalResult: In a FACET query, this contains the aggregate representing all events

  .EXAMPLE
  PS> Invoke-NRQLQuery -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567 -NRQLQuery "SELECT * FROM Transaction LIMIT 2"
  Queries for the top 2 results in the Transaction namespace for Account ID 1234567
#>
Function Invoke-NRQLQuery {

    [ cmdletbinding() ]
    Param (
    
        [ Parameter ( Mandatory = $true ) ] [ string ] $PersonalAPIKey,
        [ Parameter ( Mandatory = $true ) ] [ int ] $AccountID,
        [ Parameter ( Mandatory = $true ) ] [ string ] $NRQLQuery
    
    )

# Set the NerdGraph URL
$nerdGraphUrl = 'https://api.newrelic.com/graphql'

# Build our authentication header
$header = @{ 'API-Key' = $PersonalAPIKey }

# Build our query payload
$query = @"
{
    "query": "{ actor { account(id: $AccountID) { nrql(query: \"$NRQLQuery\") { nrql totalResult results } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $query ).data.actor.account.nrql

RETURN $results

}
