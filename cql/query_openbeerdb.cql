//Beers for a particular category
MATCH (category:Category {categoryName: "German Lager"}) <- [:BEER_CATEGORY]- (beer:Beer)
RETURN DISTINCT(beer.beerName) as beer;

//Beers for a particular category and brewery location
MATCH (category:Category {categoryName: "British Ale"}) <- [:BEER_CATEGORY]- (beer:Beer) -[:BREWED_AT] -> (brewery:Brewery {country: "United Kingdom"})
RETURN DISTINCT(beer.beerName) as beer;

//grab a geocode and the 10 closest other geocodes
MATCH (n1:Geocode)
with n1
limit 1
match (n2:Geocode)
with n1, n2, distance(n1.location, n2.location) as distance
order by distance asc
limit 10
return n1.geocodeID, n2.geocodeID, distance

//for these geocodes, see what breweries they have
MATCH (n1:Geocode)
with n1
limit 1
match (n2:Geocode)
with n1, n2, distance(n1.location, n2.location) as distance
order by distance asc
limit 10
with n1,n2
match path1 = ((n1)-[r1*..2]-()), path2 = ((n2)-[r2*..2]-())
return path1, path2;

//paths across the graph for 10 beers that are close together
MATCH (n1:Geocode)
with n1
limit 1
match (n2:Geocode)
with n1, n2, distance(n1.location, n2.location) as distance
order by distance asc
limit 10
match path = shortestpath ((n1)-[*]-(n2))
where id(n1)<id(n2)
return path;

//beers around seattle
WITH point({latitude: 47.608013, longitude: -122.335167}) AS seattle
MATCH path = (g:Geocode)--(br:Brewery)--(b:Beer)
WHERE distance(g.location, seattle) < 200000
RETURN path

WITH point({latitude: 47.608013, longitude: -122.335167}) AS seattle
MATCH path = (g:Geocode)--(br:Brewery)--(b:Beer)--(s:Style)
WHERE distance(g.location, seattle) < 200000
RETURN path

WITH point({latitude: 47.608013, longitude: -122.335167}) AS seattle
MATCH path = (g:Geocode)--(br:Brewery)--(b:Beer)
WHERE distance(g.location, seattle) < 200000
RETURN distinct br.breweryName, distance(g.location, seattle) as distance
order by distance asc;

//beers around home (51.208155, 4.407244)
WITH point({latitude: 51.208155, longitude: 4.407244}) AS home
MATCH path = (g:Geocode)--(br:Brewery)--(b:Beer)
WHERE distance(g.location, home) < 50000
RETURN distinct br.breweryName, distance(g.location, home) as distance
order by distance asc;

//beers around home (51.208155, 4.407244)
WITH point({latitude: 51.208155, longitude: 4.407244}) AS home
MATCH path = (g:Geocode)--(br:Brewery)--(b:Beer)
WHERE distance(g.location, home) < 50000
RETURN path;