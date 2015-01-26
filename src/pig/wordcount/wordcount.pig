file = LOAD 'hdfs:/data/small/war_and_peace.txt' USING PigStorage() AS (lines : chararray);
words = FOREACH file GENERATE FLATTEN (TOKENIZE (lines)) AS word;
wgroup = GROUP words by word;
wagg = FOREACH wgroup GENERATE group AS word, COUNT(words) AS wcount;
STORE wagg INTO 'hdfs:/pigresults/wordcount' USING PigStorage(',');

