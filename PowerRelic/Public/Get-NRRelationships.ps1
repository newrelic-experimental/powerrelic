<#
  .SYNOPSIS
  Queries New Relic for an entity's relationships.
  
  .DESCRIPTION
  The Get-NRRelationships cmdlet queries NerdGraph for a list of all relationships found for a target entity.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The GUID of the target entity.
  
  .OUTPUTS
domain: The entity's domain
entityType: The specific type of entity (Domain + Type)
name: The entity's name
permalink: The permalink URL of this entity
relationships:
    .source:
        .entity:
            .domain: This source entity's domain
            .entityType: The specific type of this source entity (Domain + Type)
            .guid: This source entity's GUID
            .name: This source entity's name
            .permalink: This source entity's permalink
            .reporting: Binary indicator on whether this source entity is reporting data
            .tags:
                .key: Key name for this tag
                .values: Value(s) for this tag key
            .type: This source entity's type
    .target:
        .entity:
            .domain: This target entity's domain
            .entityType: The specific type of this target entity (Domain + Type)
            .guid: This target entity's GUID
            .name: This target entity's name
            .permalink: This target entity's permalink
            .reporting: Binary indicator on whether this target entity is reporting data
            .tags:
                .key: Key name for this tag
                .values: Value(s) for this tag key
            .type: This target entity's type
tags:
    .key: Key name for this tag
    .values: Value(s) for this tag key
type: This entity's type

  .EXAMPLE
  PS> Get-NRRelationships -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -GUID A1B2C3D4E5F6G7H8I9J0
  List all relationships for the entity with GUID 'A1B2C3D4E5F6G7H8I9J0'
#>
Function Get-NRRelationships {

    [ cmdletbinding() ]
    Param (
    
        [ Parameter ( Mandatory = $true ) ] [ string ] $PersonalAPIKey,
        [ Parameter ( Mandatory = $true ) ] [ string ] $GUID
    
    )

# Set the NerdGraph URL
$nerdGraphUrl = 'https://api.newrelic.com/graphql'

# Build our authentication header
$header = @{ 'API-Key' = $PersonalAPIKey }

# Build our query payload
$relationshipsQuery = @"
{
    "query": "{ actor { entity(guid: \"$GUID\") { name relationships { source { entityType guid entity { domain entityType guid name permalink type tags { key values } reporting } } target { entityType guid entity { domain entityType guid name permalink type tags { key values } reporting } } type } entityType domain permalink tags { key values } type } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $relationshipsQuery ).data.actor.entity

RETURN $results

}
