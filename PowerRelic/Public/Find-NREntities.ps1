<#
  .SYNOPSIS
  Queries New Relic for entities.
  
  .DESCRIPTION
  The Find-NREntities cmdlet queries NerdGraph to search for entities by GUID or provided query.
  Notes on Queries: 
    - Single quotes on the internal query are a requirement of the NerdGraph API
    - Most keys and values are case-sensitive, best practice is to make sure your search respects this
    - Operators available include: = | AND | IN | LIKE
    - the IN and LIKE operators create a fuzzy search, no wildcards are needed
    - Searchable fields include: alertSeverity | domain | infrastructureIntegrationType | name | reporting | tags | type
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER SearchParameter
  [REQUIRED] The type of search to perform.
  
  .PARAMETER SearchValue
  [REQUIRED] The search parameters to evaluate against.
  
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
  PS> Find-NREntities -PersonalAPIKey "NRAK-123456789ABCDEFGHIJKLMNOPQR" -SearchParameter GUID -SearchValue "A1B2C3D4E5F6G7H8I9J0"
  Find the entity with GUID 'A1B2C3D4E5F6G7H8I9J0'
  
  .EXAMPLE
  PS> Find-NREntities -PersonalAPIKey "NRAK-123456789ABCDEFGHIJKLMNOPQR" -SearchParameter Query -SearchValue "name LIKE 'my-app'"
  Find all the entities, across all domains, whose name fuzzy matches 'my-app'.
  
  .EXAMPLE
  PS> Find-NREntities -PersonalAPIKey "NRAK-123456789ABCDEFGHIJKLMNOPQR" -SearchParameter Query -SearchValue  "name LIKE 'my-app' AND domain ='INFRA'"
  Find all the entities, across all domains, whose name fuzzy matches 'my-app' and domain = 'INFRA'
#>
Function Find-NREntities {

    [ cmdletbinding() ]
    Param (
    
        [ Parameter ( Mandatory = $true ) ] [ string ] $PersonalAPIKey,
        [ Parameter ( Mandatory = $true ) ] [ ValidateSet( 'GUID','Query' ) ] [ string ] $SearchParameter,
        [ Parameter ( Mandatory = $true ) ] [ string ] $SearchValue
    
    )

# Set the NerdGraph URL
$nerdGraphUrl = 'https://api.newrelic.com/graphql'

# Build our authentication header
$header = @{ 'API-Key' = $PersonalAPIKey }

If( $SearchParameter -eq 'GUID' ){

# Build our query payload
$entityQuery = @"
{
    "query": "{ actor { entities(guids: \"$SearchValue\") { domain entityType guid name permalink type tags { key values } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $entityQuery ).data.actor.entities

RETURN $results

}

If( $SearchParameter -eq 'Query' ){

# Build our query payload
$entityQuery = @"
{
    "query": "{ actor { entitySearch(query: \"$SearchValue\") { results { entities { domain entityType guid name permalink type tags { key values } } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $entityQuery ).data.actor.entitySearch.results.entities

RETURN $results

}

}
