# neo4j-openbeerdb

Inspired by https://neo4j.com/graphgist/beer-amp-breweries-graphgist

Powered by http://openbeerdb.com

## Schema

// TODO

## Create nodes and relationships

```sql
LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/openbeerdb/raw/master/beers.csv' AS row
CREATE (:Beer { beerID: row.id, beerName: row.name, description: row.descript, abv: toFloat(row.abv), breweryID: row.brewery_id, catID: row.cat_id, styleID: row.style_id})

LOAD CSV WITH HEADERS FROM 'https://githurowb.com/aicfr/openbeerdb/raw/master/breweries.csv' AS row
CREATE (:Brewery { breweryID: row.id, breweryName: row.name, address1: row.address1, city: row.city, state: row.state, zipCode: row.code, country: row.country, phoneNumber: row.phone, website: row.website, description: row.descript})

CREATE INDEX ON :Beer(beerID);
CREATE INDEX ON :Brewery(breweryID);

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://github.com/aicfr/openbeerdb/raw/master/beers.csv" AS row
MATCH (beer:Beer {beerID: row.id})
MATCH (brewery:Brewery {breweryID: row.brewery_id})
MERGE (beer)-[:BREWED_AT]->(brewery);
```

## Queries

// TODO
