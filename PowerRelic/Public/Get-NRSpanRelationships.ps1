<#
  .SYNOPSIS
  Queries New Relic for the span relationships in a distributed trace.
  
  .DESCRIPTION
  The Get-NRSpanRelationships cmdlet queries NerdGraph for the parent::child span relationships of a target distributed trace.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The ID of the target trace.
  
  .OUTPUTS
  child: The span identifier of the child for this connection
  parent: The span identifier of the parent for this connection; ultimate parent will be 'root'
  
  .EXAMPLE
  PS> Get-NRSpanRelationships -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -TraceID a1b2c3d4e5f6g7h8i9j0
  List all span relationships for the trace with ID 'a1b2c3d4e5f6g7h8i9j0'
#>
Function Get-NRSpanRelationships {

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
    "query": "{ actor { distributedTracing { trace(traceId: \"$TraceID\") { spanConnections { parent child } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $traceQuery ).data.actor.distributedTracing.trace.spanConnections

RETURN $results

}
