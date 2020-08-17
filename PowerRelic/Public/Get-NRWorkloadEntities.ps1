<#
  .SYNOPSIS
  Queries New Relic for all entities assigned to a workload.
  
  .DESCRIPTION
  The Get-NRWorkloadEntities cmdlet queries NerdGraph for a list of all entities assigned to a target workload.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The New Relic Account ID to be queried against.
  
  .PARAMETER AccountID
  [REQUIRED] The GUID of the target workload.
  
  .OUTPUTS
  createdAt: The DateTime (epoch) this workload was created
  createdBy:
      .email: The user's email address who created this workload
      .id: The user's ID who created this workload
      .name: The user's name who created this workload
  entities: 
      .guid: A list of entity GUIDs in this workload
  entitySearchQueries:
    .createdAt: The DateTime (epoch) this query was created
    .createdBy:
        .email: The user's email address who created this query
        .id: The user's ID who created this query
        .name: The user's name who created this query 
    .query: The query used to dynamically populate this workload
    .updatedAt: The DateTime (epoch) this query was last updated
  entitySearchQuery: The full query of both static and dynamically assigned entities for this workload
  guid: The GUID of this workload
  name: The display name of this workload
  permalink: The permalink URL of this workload
  scopeAccounts:
      .accountIds: List of accounts that will be used to get entities from
  updatedAt: The DateTime (epoch) this workload was last updated

  .EXAMPLE
  PS> Get-NRWorkloadEntities -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567 -GUID A1B2C3D4E5F6G7H8I9J0
  List all entities in the workload with GUID 'A1B2C3D4E5F6G7H8I9J0' in account 1234567
#>
Function Get-NRWorkloadEntities {

    [ cmdletbinding() ]
    Param (
    
        [ Parameter ( Mandatory = $true ) ] [ string ] $PersonalAPIKey,
        [ Parameter ( Mandatory = $true ) ] [ int ] $AccountID,
        [ Parameter ( Mandatory = $true ) ] [ string ] $GUID
    
    )

# Set the NerdGraph URL
$nerdGraphUrl = 'https://api.newrelic.com/graphql'

# Build our authentication header
$header = @{ 'API-Key' = $PersonalAPIKey }

# Build our query payload
$workloadsQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { workload { collection(guid: \"$GUID\") { createdAt createdBy { email id name } entities { guid } entitySearchQueries { createdAt createdBy { email id name } query updatedAt } entitySearchQuery guid name permalink scopeAccounts { accountIds } updatedAt } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $workloadsQuery ).data.actor.account.workload.collection

RETURN $results

}
