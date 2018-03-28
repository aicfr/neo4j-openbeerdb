# neo4j-openbeerdb

Inspired by https://neo4j.com/graphgist/beer-amp-breweries-graphgist

Powered by http://openbeerdb.com and https://neo4j.com

## Docker

```
docker run -it --rm --publish=7474:7474 --publish=7687:7687 neo4j
```

## Schema

![openbeerdb](http://www.plantuml.com/plantuml/png/TT3T2e8m50VmUvzYbmhs0bs4fIUBpC4KeYlnuo22RZ8NqTktLafINerjl_C_P_C6bKjrwreYUkG5egmAozxf5QL3LgiDCHk7h0dRfX3OCbSDhvq5un_0FsbLvGfTqefIQy5TqikcnCKYUZv3d4vbfUWwvEeVVnSSaspFZX076TtRGyEdw55AlADylEYEmGM2R9lEWA_xrE8Z05ZcwxU5b5rdAb6F5YUIfDS8hF7m9yPSV-UCCnWPeYX5PS92e15zEJELXxpIl_y4 "openbeerdb")

* Beerer
  * beererID
  * lastname
  * firstname

* Beer
  * beerID
  * beerName
  * description
  * abv : alcohol by volume

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

* Geocode
  * geocodeID
  * latitude
  * longitude

## Create nodes, indexes and relationships
### Create nodes

```sql
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/aicfr/neo4j-openbeerdb/master/beerers.csv' AS row
CREATE (:Beerer { beererID: toInteger(row.id), lastname: row.lastname, firstname: row.firstname })

LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/neo4j-openbeerdb/raw/master/beers.csv' AS row
CREATE (:Beer { beerID: toInteger(row.id), beerName: row.name, description: row.descript, abv: toFloat(row.abv) })

LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/neo4j-openbeerdb/raw/master/breweries.csv' AS row
CREATE (:Brewery { breweryID: toInteger(row.id), breweryName: row.name, address1: row.address1, city: row.city, state: row.state, zipCode: row.code, country: row.country, phoneNumber: row.phone, website: row.website, description: row.descript })

LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/neo4j-openbeerdb/raw/master/categories.csv' AS row
CREATE (:Category { categoryID: toInteger(row.id), categoryName: row.cat_name })

LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/neo4j-openbeerdb/raw/master/styles.csv' AS row
CREATE (:Style { styleID: toInteger(row.id), styleName: row.style_name })

LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/neo4j-openbeerdb/raw/master/geocodes.csv' AS row
CREATE (:Geocode { geocodeID: toInteger(row.id), latitude: toFloat(row.latitude), longitude: toFloat(row.longitude) })
```

### Create indexes

```sql
CREATE INDEX ON :Beerer(beererID);
CREATE INDEX ON :Beer(beerID);
CREATE INDEX ON :Brewery(breweryID);
CREATE INDEX ON :Category(categoryID);
CREATE INDEX ON :Style(styleID);
CREATE INDEX ON :Geocode(geocodeID);
```

### Create relationships

```sql
MATCH (b1:Beerer),(b2:Beerer)
WHERE b1.beererID = 1 AND b2.beererID = 6
CREATE (b1)-[:IS_FRIEND_OF {since: '1997-04-22'}]->(b2)

MATCH (b1:Beerer),(b2:Beerer)
WHERE b1.beererID = 3 AND b2.beererID = 6
CREATE (b1)-[:IS_FRIEND_OF {since: '2009-01-20'}]->(b2)

MATCH (b:Beerer),(beer:Beer)
WHERE b.beererID = 3 AND beer.beerID = 4265
CREATE (b)-[:RATED {rating: 5}]->(beer)

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://github.com/aicfr/neo4j-openbeerdb/raw/master/beers.csv" AS row
MATCH (beer:Beer {beerID: toInteger(row.id)})
MATCH (brewery:Brewery {breweryID: toInteger(row.brewery_id)})
MERGE (beer)-[:BREWED_AT]->(brewery);

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://github.com/aicfr/neo4j-openbeerdb/raw/master/beers.csv" AS row
MATCH (beer:Beer {beerID: toInteger(row.id)})
MATCH (category:Category {categoryID: toInteger(row.cat_id)})
MERGE (beer)-[:BEER_CATEGORY]->(category)

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://github.com/aicfr/neo4j-openbeerdb/raw/master/beers.csv" AS row
MATCH (beer:Beer {beerID: toInteger(row.id)})
MATCH (style:Style {styleID: toInteger(row.style_id)})
MERGE (beer)-[:BEER_STYLE]->(style)

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