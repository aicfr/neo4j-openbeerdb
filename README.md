# openbeerdb

```sql
LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/openbeerdb/raw/master/beers.csv' AS row
CREATE (:Beer { beerID: row.id, beerName: row.name, breweryID: row.brewery_id, catID: row.cat_id})

LOAD CSV WITH HEADERS FROM 'https://githurowb.com/aicfr/openbeerdb/raw/master/breweries.csv' AS row
CREATE (:Brewery { breweryID: row.id, breweryName: row.name})

CREATE INDEX ON :Beer(beerID);
CREATE INDEX ON :Brewery(breweryID);

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://github.com/aicfr/openbeerdb/raw/master/beers.csv" AS row
MATCH (beer:Beer {beerID: row.id})
MATCH (brewery:Brewery {breweryID: row.brewery_id})
MERGE (beer)-[:BREWED_AT]->(brewery);
```
