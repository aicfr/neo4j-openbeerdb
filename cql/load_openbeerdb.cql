//open beer database can be found at
//import script from https://github.com/aicfr/neo4j-openbeerdb

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/aicfr/neo4j-openbeerdb/master/beerers.csv' AS row
CREATE (:Beerer { beererID: toInteger(row.id), beererName: row.name, location: row.location, description: row.descript, website: row.website, picture: row.picture });

LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/neo4j-openbeerdb/raw/master/beers.csv' AS row
CREATE (:Beer { beerID: toInteger(row.id), beerName: row.name, description: row.descript, abv: toFloat(row.abv) });

LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/neo4j-openbeerdb/raw/master/breweries.csv' AS row
CREATE (:Brewery { breweryID: toInteger(row.id), breweryName: row.name, address1: row.address1, city: row.city, state: row.state, zipCode: row.code, country: row.country, phoneNumber: row.phone, website: row.website, description: row.descript });

LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/neo4j-openbeerdb/raw/master/categories.csv' AS row
CREATE (:Category { categoryID: toInteger(row.id), categoryName: row.cat_name });

LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/neo4j-openbeerdb/raw/master/styles.csv' AS row
CREATE (:Style { styleID: toInteger(row.id), styleName: row.style_name });

LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/neo4j-openbeerdb/raw/master/geocodes.csv' AS row
CREATE (:Geocode { geocodeID: toInteger(row.id), latitude: toFloat(row.latitude), longitude: toFloat(row.longitude) });

CREATE INDEX ON :Beerer(beererID);
CREATE INDEX ON :Beer(beerID);
CREATE INDEX ON :Brewery(breweryID);
CREATE INDEX ON :Category(categoryID);
CREATE INDEX ON :Style(styleID);
CREATE INDEX ON :Geocode(geocodeID);

MATCH (b1:Beerer {beererID: 1})
MATCH (b2:Beerer {beererID: 6})
CREATE (b1)-[i:IS_FRIEND_OF]->(b2)
SET i.since = '1997-04-22';

MATCH (b1:Beerer {beererID: 3})
MATCH (b2:Beerer {beererID: 6})
CREATE (b1)-[i:IS_FRIEND_OF]->(b2)
SET i.since = '2009-01-20';

MATCH (beerer:Beerer {beererID: 3})
MATCH (beer:Beer {beerID: 4265})
CREATE (beerer)-[r:RATED]->(beer)
SET r.rating = 5,r.comment = '',r.createdAt = timestamp();

MATCH (beerer:Beerer {beererID: 3})
MATCH (beer:Beer {beerID: 4265})
CREATE (beerer)-[c:CHECKED]->(beer)
SET c.location = 'Vineuil, FR',c.price = 4.5,c.createdAt = timestamp();

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://github.com/aicfr/neo4j-openbeerdb/raw/master/beers.csv" AS row
MATCH (beer:Beer {beerID: toInteger(row.id)})
MATCH (brewery:Brewery {breweryID: toInteger(row.brewery_id)})
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
LOAD CSV WITH HEADERS FROM "https://github.com/aicfr/neo4j-openbeerdb/raw/master/geocodes.csv" AS row
MATCH (brewery:Brewery {breweryID: toInteger(row.brewery_id)})
MATCH (geocode:Geocode {geocodeID: toInteger(row.id)})
MERGE (brewery)-[:GEOLOCATED_AT]->(geocode);


//3.4 locations added from Geocode
MATCH (g:Geocode)
SET g.location = point({latitude: g.latitude, longitude: g.longitude});

CREATE INDEX ON :Geocode(location);
CREATE INDEX ON :Beer(beerName);
CREATE INDEX ON :Beerer(beererName);
CREATE INDEX ON :Brewery(breweryName);
CREATE INDEX ON :Category(categoryName);
CREATE INDEX ON :Style(styleName);