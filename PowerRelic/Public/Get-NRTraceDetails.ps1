<#
  .SYNOPSIS
  Queries New Relic for a distributed trace.
  
  .DESCRIPTION
  The Get-NRTraceDetails cmdlet queries NerdGraph for details of a target distributed trace.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The ID of the target trace.
  
  .OUTPUTS
  backendDurationMs: The duration in milliseconds for the back-end part of this trace
  durationMs: The total duration of this trace in milliseconds
  spans:
      .attributes: A key:value map for all attributes of this span
      .clientType: Type of entity that was called, when the span represents a call to another entity
      .durationMs: The duration of this span in milliseconds
      .entityGuid: Unique identifier for the entity that created this span
      .id: Unique identifier for this span
      .name: The name of this span
      .parentId: The identifier of the caller of this span (null if this is the root span)
      .processBoundary: The position of a span with respect to the boundaries between processes in the trace
      .spanAnomalies:
          .anomalousValue: The value of the span attribute which was detected as being anomalous
          .anomalyType: The attribute of the span which was detected as being anomalous
          .averageMeasure: The average value for the attribute on similar spans
      .timestamp: The DateTime (epoch) of this span's start time
  timestamp: The DateTime (epoch) of this trace's start time
  
  .EXAMPLE
  PS> Get-NRTraceDetails -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -TraceID a1b2c3d4e5f6g7h8i9j0
  List all details for the trace with ID 'a1b2c3d4e5f6g7h8i9j0'
#>
Function Get-NRTraceDetails {

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
    "query": "{ actor { distributedTracing { trace(traceId: \"$TraceID\") { backendDurationMs durationMs timestamp spans { attributes clientType durationMs entityGuid id name parentId processBoundary timestamp spanAnomalies { anomalousValue anomalyType averageMeasure } } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $traceQuery ).data.actor.distributedTracing.trace

RETURN $results

}
