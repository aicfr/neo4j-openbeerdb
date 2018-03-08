# neo4j-openbeerdb

Inspired by https://neo4j.com/graphgist/beer-amp-breweries-graphgist

Powered by http://openbeerdb.com

## Docker

```
docker run -it --rm --publish=7474:7474 --publish=7687:7687 neo4j
```

## Schema

![openbeerdb](http://www.plantuml.com/plantuml/png/SoWkIImgAStDKSWlICrBIaqjIadYvT9m0Z8q5NHrxHGqd8fIorEBAZKLh1ISWbp3NLtY7KDGLJWdbgIcvqELkBe6nJixXhYw-mT5eYeBBgdCIOMh2Gw9z745Ae2AOXW4baSn2UOEi5BtrFpa_1ImSUwk_Zx-88KGbpcavgK0_GC0 "openbeerdb")

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

MATCH (b:Beer),(br:Brewery)
WHERE b.breweryID = br.breweryID
CREATE (b)-[:BREWED_AT]->(br)

MATCH (b:Beer),(c:Category)
WHERE b.categoryID = c.categoryID
CREATE (b)-[:BEER_CATEGORY]->(c)

MATCH (b:Beer),(s:Style)
WHERE b.styleID = s.styleID
CREATE (b)-[:BEER_CATEGORY]->(s)

MATCH (s:Style),(c:Category)
WHERE s.categoryID = c.categoryID
CREATE (s)-[:STYLE_CATEGORY]->(c)

MATCH (br:Brewery),(g:Geocode)
WHERE br.breweryID = g.breweryID
CREATE (br)-[:GEOLOCATED_AT]->(g)
```

## Queries
### Beers for a particular category

```sql
MATCH (category:Category {categoryName: "German Lager"}) <- [:BEER_CATEGORY]- (beer:Beer)
RETURN DISTINCT(beer.beerName) as beer
```