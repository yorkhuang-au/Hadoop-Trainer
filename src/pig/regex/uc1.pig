file = LOAD '/home/hadoop/pigs/input.txt' AS (lines : chararray);  
r1 = FOREACH file GENERATE TRIM(SUBSTRING(lines, 0, INDEXOF(lines, '#', 0))) AS name, (INT) REGEX_EXTRACT(lines, '.*[a|A]ge\\s*(\\d*).*', 1) AS age;
DUMP r1;
r2 = FILTER r1 BY age >30;
DUMP r2;

