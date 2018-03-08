# neo4j-openbeerdb

Inspired by https://neo4j.com/graphgist/beer-amp-breweries-graphgist

Powered by http://openbeerdb.com

## Schema

![neo4j-openbeerdb](http://www.plantuml.com/plantuml/proxy?src=https://raw.githubusercontent.com/aicfr/neo4j-openbeerdb/master/neo4j-openbeerdb.puml)

## Create nodes and relationships

```sql
LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/neo4j-openbeerdb/raw/master/beers.csv' AS row
CREATE (:Beer { beerID: toInteger(row.id), beerName: row.name, description: row.descript, abv: toFloat(row.abv), breweryID: toInteger(row.brewery_id), categoryID: toInteger(row.cat_id), styleID: toInteger(row.style_id) })

LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/neo4j-openbeerdb/raw/master/breweries.csv' AS row
CREATE (:Brewery { breweryID: toInteger(row.id), breweryName: row.name, address1: row.address1, city: row.city, state: row.state, zipCode: row.code, country: row.country, phoneNumber: row.phone, website: row.website, description: row.descript })

LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/neo4j-openbeerdb/raw/master/categories.csv' AS row
CREATE (:Category { categoryID: toInteger(row.id), categoryName: row.cat_name })

LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/neo4j-openbeerdb/raw/master/styles.csv' AS row
CREATE (:Style { styleID: toInteger(row.id), styleName: row.style_name, categoryID: toInteger(row.cat_id) })

LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/neo4j-openbeerdb/raw/master/geocodes.csv' AS row
CREATE (:Geocode { geocodeID: toInteger(row.id), latitude: toFloat(row.latitude), longitude: toFloat(row.longitude), breweryID: toInteger(row.brewery_id) })

CREATE INDEX ON :Beer(beerID);
CREATE INDEX ON :Brewery(breweryID);
CREATE INDEX ON :Category(categoryID);
CREATE INDEX ON :Style(styleID);
CREATE INDEX ON :Geocode(geocodeID);

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://github.com/aicfr/neo4j-openbeerdb/raw/master/beers.csv" AS row
MATCH (beer:Beer {beerID: row.id})
MATCH (brewery:Brewery {breweryID: row.brewery_id})
MERGE (beer)-[:BREWED_AT]->(brewery);

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://github.com/aicfr/neo4j-openbeerdb/raw/master/beers.csv" AS row
MATCH (beer:Beer {beerID: toInteger(row.id)})
MATCH (category:Category {categoryID: toInteger(row.cat_id)})
MERGE (beer)-[:BEER_CATEGORY]->(category);

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://github.com/aicfr/neo4j-openbeerdb/raw/master/beers.csv" AS row
MATCH (beer:Beer {beerID: toInteger(row.id)})
MATCH (style:Style {styleID: toInteger(row.style_id)})
MERGE (beer)-[:BEER_STYLE]->(style);

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://github.com/aicfr/neo4j-openbeerdb/raw/master/styles.csv" AS row
MATCH (style:Style {styleID: toInteger(row.id)})
MATCH (category:Category {categoryID: toInteger(row.cat_id)})
MERGE (style)-[:STYLE_CATEGORY]->(category);

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://github.com/aicfr/neo4j-openbeerdb/raw/master/geocodes.csv" AS row
MATCH (brewery:Brewery {breweryID: toInteger(row.brewery_id)})
MATCH (geocode:Geocode {geocodeID: toInteger(row.id)})
MERGE (brewery)-[:GEOLOCATED_AT]->(geocode);
```

## Queries

// TODO