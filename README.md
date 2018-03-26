# neo4j-openbeerdb

Inspired by https://neo4j.com/graphgist/beer-amp-breweries-graphgist

Powered by http://openbeerdb.com and https://neo4j.com

## Docker

```
docker run -it --rm --publish=7474:7474 --publish=7687:7687 neo4j
```

## Schema

![openbeerdb](http://www.plantuml.com/plantuml/png/SoWkIImgAStDKSWlICrBIaqjIadYqd02qgb5cWgwkdOAO8wcWfL2a6E8gmiMEOYiPt2yMv2dgvzBlByR5rGFH4bHQdbgKIL8ZLEGQxYhIxnZ28e2vyIIrFHyg0fNrw1uPw15xlv1aIYgWaigSrBXIe938drSkM226CQ0fP7DWRa1hD8zDJyvFmLicBkhluy_I1tOLGwfUId0e000 "openbeerdb")

* Beerer
  * beererID
  * lastname
  * firstname

* Beer
  * beerID
  * beerName
  * description
  * abv : alcohol by volume
  * breweryID
  * categoryID
  * styleID

* Brewery
  * breweryID
  * breweryName
  * address1
  * city
  * state
  * zipCode
  * country
  * phoneNumber
  * website
  * description

* Category
  * categoryID
  * categoryName

* Style
  * styleID
  * styleName
  * categoryID

* Geocode
  * geocodeID
  * latitude
  * longitude
  * breweryID

## Create nodes and relationships

```sql
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/aicfr/neo4j-openbeerdb/master/beerers.csv' AS row
CREATE (:Beerer { beererID: toInteger(row.id), lastname: row.lastname, firstname: row.firstname })

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

CREATE INDEX ON :Beerer(beererID);
CREATE INDEX ON :Beer(beerID);
CREATE INDEX ON :Brewery(breweryID);
CREATE INDEX ON :Category(categoryID);
CREATE INDEX ON :Style(styleID);
CREATE INDEX ON :Geocode(geocodeID);

MATCH (b1:Beerer),(b2:Beerer)
WHERE b1.beererID = 1 AND b2.beererID = 6
CREATE (b1)-[:IS_FRIEND_OF {since: '1997-04-22'}]->(b2)

MATCH (b1:Beerer),(b2:Beerer)
WHERE b1.beererID = 3 AND b2.beererID = 6
CREATE (b1)-[:IS_FRIEND_OF {since: '2009-01-20'}]->(b2)

MATCH (b:Beerer),(beer:Beer)
WHERE b.beererID = 3 AND beer.beerID = 4265
CREATE (b)-[:RATED {rating: 5}]->(beer)

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

### Beers for a particular category and brewery location

```sql
MATCH (category:Category {categoryName: "British Ale"}) <- [:BEER_CATEGORY]- (beer:Beer) -[:BREWED_AT] -> (brewery:Brewery {country: "United Kingdom"})
RETURN DISTINCT(beer.beerName) as beer
```
## Resources

* <https://graphaware.com/neo4j/2013/10/11/neo4j-bidirectional-relationships.html>