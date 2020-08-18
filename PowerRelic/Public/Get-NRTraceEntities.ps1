<#
  .SYNOPSIS
  Queries New Relic for the entities of a distributed trace.
  
  .DESCRIPTION
  The Get-NRTraceEntities cmdlet queries NerdGraph for the entites related to a target distributed trace.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The ID of the target trace.
  
  .OUTPUTS
  domain: The entity's domain
  entityType: The specific type of entity (Domain + Type)
  guid: The unique identifier for this entity
  name: The entity's name
  permalink: The permalink URL of this entity
  tags:
    .key: Key name for this tag
    .value: Value(s) for this tag key
  type: This entity's type
  
  .EXAMPLE
  PS> Get-NRTraceEntities -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -TraceID a1b2c3d4e5f6g7h8i9j0
  List all entities for the trace with ID 'a1b2c3d4e5f6g7h8i9j0'
#>
Function Get-NRTraceEntities {

    [ cmdletbinding() ]
    Param (
    
        [ Parameter ( Mandatory = $true ) ] [ string ] $PersonalAPIKey,
        [ Parameter ( Mandatory = $true ) ] [ string ] $TraceID
    
    )

# Set the NerdGraph URL
$nerdGraphUrl = 'https://api.newrelic.com/graphql'

# Build our authentication header
$header = @{ 'API-Key' = $PersonalAPIKey }

# Build our query payload
$traceQuery = @"
{
    "query": "{ actor { distributedTracing { trace(traceId: \"$TraceID\") { entities { domain entityType guid name permalink tags { key values } type } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $traceQuery ).data.actor.distributedTracing.trace.entities

RETURN $results

}
