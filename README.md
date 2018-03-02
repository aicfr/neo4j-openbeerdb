# openbeerdb

```
LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/openbeerdb/raw/master/beers.csv' AS line
CREATE (:Beer6 { id: line.id, name: line.name, brewery_id: line.brewery_id, cat_id: line.cat_id})

LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/openbeerdb/raw/master/breweries.csv' AS line
CREATE (:Breweries { id: line.id, name: line.name})

LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/openbeerdb/raw/master/categories.csv' AS line
CREATE (:Category { id: line.id, name: line.cat_name})

LOAD CSV WITH HEADERS FROM 'https://github.com/aicfr/openbeerdb/raw/master/styles.csv' AS line
CREATE (:Breweries { id: line.id, name: line.name})

MATCH (e:Beer6),(w:Breweries)
WHERE e.brewery_id = w.id
CREATE (e)-[r:BREWED_AT]->(w)
RETURN r

MATCH (e:Beer6),(c:Category)
WHERE e.cat_id = c.id
CREATE (e)-[r:BEER_CATEGORY]->(c)
RETURN r
```
