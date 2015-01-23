--Loading files into relations
jan = LOAD 'hdfs:/data/big/201201hourly.txt USING PigStorage(',');
feb = LOAD 'hdfs:/data/big/201202hourly.txt USING PigStorage(',');
mar = LOAD 'hdfs:/data/big/201203hourly.txt USING PigStorage(',');
apr = LOAD 'hdfs:/data/big/201204hourly.txt USING PigStorage(',');

--Combining the relations
month_quad = UNION jan,feb,mar,apr;

--Splitting relations
SPLIT month_quad INTO split_jan IF SUBSTRING(date, 4, 6) == '01', split_feb IF SUBSTRING(date, 4, 6) == '02', split_mar IF SUBSTRING(date, 4, 6) == '03', split_apr IF SUBSTRING(date, 4, 6) == '04';

--JOining all relations

wstatns = LOAD 'hdfs:/data/big/stations.txt' USING PigStorage() AD (id:int, name:chararray);

JOIN month_quad BY wban, wstatns by id;


--STORE 
STORE month_quad INTO 'hdfs:/data/big/results/joinedmnths' USING PigStorage('|*|');
