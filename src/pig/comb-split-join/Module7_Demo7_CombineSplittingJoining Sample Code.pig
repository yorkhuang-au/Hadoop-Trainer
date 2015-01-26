--Loading files into relations
jan = LOAD 'hdfs:/data/big/201201hourly.txt' USING PigStorage(',');
feb = LOAD 'hdfs:/data/big/201202hourly.txt' USING PigStorage(',');
mar = LOAD 'hdfs:/data/big/201203hourly.txt' USING PigStorage(',');
apr = LOAD 'hdfs:/data/big/201204hourly.txt' USING PigStorage(',');

--Combining the relations
month_quad = UNION jan,feb,mar,apr;

--Splitting relations
SPLIT month_quad INTO split_jan IF SUBSTRING(Date, 4, 6) == '01', split_feb IF SUBSTRING(Date, 4, 6) == '02', split_mar IF SUBSTRING(Date, 4, 6) == '03', split_apr IF SUBSTRING(Date, 4, 6) == '04';


wstatns = LOAD 'hdfs:/data/station/station.txt' USING PigStorage(',') AS (id:chararray, name:chararray);

joined = JOIN month_quad BY WBAN, wstatns by id;


--STORE 
STORE joined INTO 'hdfs:/pigresults/joined' USING PigStorage('*');
