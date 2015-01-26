--Loading files into relations
jan = LOAD 'hdfs:/data/big/201201hourly.txt' USING PigStorage(',');
feb = LOAD 'hdfs:/data/big/201202hourly.txt' USING PigStorage(',');
mar = LOAD 'hdfs:/data/big/201203hourly.txt' USING PigStorage(',');
apr = LOAD 'hdfs:/data/big/201204hourly.txt' USING PigStorage(',');

--Combining the relations
month_quad = UNION jan,feb,mar,apr;

--Splitting relations
SPLIT month_quad INTO split_jan IF SUBSTRING(Date, 4, 6) == '01', split_feb IF SUBSTRING(Date, 4, 6) == '02', split_mar IF SUBSTRING(Date, 4, 6) == '03', split_apr IF SUBSTRING(Date, 4, 6) == '04';

--JOining all relations

wstatns = LOAD 'hdfs:/data/station/station.txt' USING PigStorage(',') AS (id:chararray, name:chararray);
joined = JOIN month_quad BY WBAN, wstatns by id;

--Filtering out all unwanted data

clearsky = FILTER month_quad BY SkyCondition == 'CLR';

--Transforming and shaping relations

shapedWeathers = FOREACH clearsky GENERATE Date, SUBSTRING(Date, 0, 4) as year, SUBSTRING(Date, 4, 6) as month, SUBSTRING(Date, 6, 8) as day, SkyCondition, DryBulbCelsius;

--Grouping relations with specifying the total number of reducers
grpMnthDay = GROUP shapedWeathers BY (month, day) PARALLEL 4;

--STORE 
STORE grpMnthDay INTO 'hdfs:/pigresults/grouping' USING PigStorage('*');
