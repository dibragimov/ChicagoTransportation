/****** Script for aggregating Divvy bikes trips  ******/
SELECT [Community Areas], COUNT([TRIP ID]) numberOfTrips, --DAY([START TIME]) as start_day, MONTH([START TIME]) as start_month, YEAR([START TIME]) as start_year,[Community Areas],
    AVG([TRIP DURATION]) as duration,
	AVG(geography::STGeomFromText([FROM LOCATION], 4326).STDistance(geography::STGeomFromText([TO LOCATION], 4326))/1000) AS distance -- calculate approx distance
FROM [DivvyBike].[dbo].[Divvy_Trips]
WHERE NOT([FROM LOCATION] is null) AND LEN([FROM LOCATION]) > 10 AND NOT([TO LOCATION] is null) AND LEN([TO LOCATION]) > 10
AND YEAR([START TIME]) > 2017
GROUP BY  [Community Areas] --, DAY([START TIME]), MONTH([START TIME]), YEAR([START TIME])
ORDER BY numberOfTrips DESC


/****** Script for converting multi-polygons to polygons (not used)  ******/
SELECT TOP 1000 (geometry::STMPolyFromText([Geometry], 0).STGeometryN(1)).STAsText() as [geometry] --generate_series(1, STNumGeometries())) AS geom 
    ,[CommArea]
FROM [DivvyBike].[dbo].[Comm_Areas_1]



  /****** Script for aggregating BigQuery results for Chicago taxi trips  ******/
SELECT COUNT([duration]) as numOfTrips, AVG([duration]) as [duration], AVG([length]) as distance
      --,[trip_start_year]
      --,[trip_start_month]
      --,[trip_start_day]
      ,[pickup_community_area]
  FROM [DivvyBike].[dbo].[bq-results-20190727-225620-reowvlsj62qi]
  WHERE trip_start_year = 2018
  GROUP BY [pickup_community_area]
  ORDER BY [distance] DESC