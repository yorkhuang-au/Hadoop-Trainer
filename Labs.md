###Lesson 4 Install hadoop on ubuntu server
####1. Installing Ubantu Server  
  * Select OpenSSH
  * Set up static IP (optional)  
  
>`	 sudo vi /etc/network/interfaces`  
	`auto eth0`  
	`iface eth0 inet static`  
	`address 192.168.186.3`  
	`netmask 255.255.255.0`  
	`gateway 192.168.186.2`  
	`dns-nameservers 192.168.186.2`  
	`sudo vi /etc/hosts`  
	`127.0.0.1    uhs1`  
	`sudo vi /etc/hostname`  
	`uhs1`  
	`sudo reboot`

>`	edit c:\windows\system32\drivers\etc\hosts`  
	`<server ip> <server name>`

####2. Installing Hadoop on Ubantu Server  
  * Update Ubuntu Server  
  
>`	sudo apt-get update`

  * Install ssh and rsync  
  
>`	sudo apt-get install ssh`  
	`sudo apt-get install rsync`  
	
  * Create ssh key
  
>`	ssh-keygen`  
	`cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys`  
	`ssh <server ip>  `
		
  * Install Java JDK
  
>`	sudo apt-get install openjdk-7-jdk` 	
	`java -version`  
	`java -showversion`  
	`update-java-alternatives -l`  
	`ln -s <java folder> /usr/local/java  `
		
  * Download and install Hadoop 1.2.1  
	Go to [Apache Hadoop homepage](http://hadoop.apache.org/releases.html#Download ) to download Hadoop 1.2.1  
	
>`   tar -xzvf hadoop-1.2.1.tar.gz`  
	`sudo ln -s <hadoop folder> /usr/local/hadoop`
	
>`	vi ~/.bashrc`  
	`export HADOOP_PREFIX=/usr/local/hadoop`  
	`export PATH=$PATH:$HADOOP_PREFIX/bin`  
	`exec bash  `

>`	vi /usr/local/hadoop/conf/hadoop-env.sh`  
	`JAVA_HOME=/usr/local/java`  
	`HADOOP_OPTS=`

>`	mkdir /usr/local/hadoop/logs`  
	`mkdir /usr/local/hadoop/tmp`

>`	vi /usr/local/hadoop/conf/core-site.xml`  
	`fs.default.name = hdfs://<server ip>:9000`  
	`hadoop.tmp.dir = /usr/local/hadoop/tmp`

>`	vi /usr/local/hadoop/conf/hdfs-site.xml`  
	`dfs.replication = 1`

>`	vi /usr/local/hadoop/conf/mapred-site.xml`  
	`mapred.job.tracker = <server ip>:9001`

>`	vi /usr/local/hadoop/conf/masters`  
	`localhost`

>`	vi /usr/local/hadoop/conf/slaves`  
	`localhost`

>`	hadoop namenode -format`

  * Start/stop hadoop and testing  
  
>`	start-all.sh`  
	`jps`  
	`stop-all.sh`  
	`hadoop fs -mkdir -ls -copyFromLocal -copyToLocal -cat -rm -rmr`  
	`hadoop jar /usr/local/hadoop/hadoop-examples-1.2.1.jar wordcount <input> <output>`

	Browse hdfs at http://<server ip>:50070

####3. Installing Hadoop on Ubantu Cluster  
  * Clone the ubuntu server vm  
  * Set up each machine  
  
>`	sudo vi /etc/hostname`  
	`<server name>`  
	`sudo vi /etc/network/interfaces`  
	`change ip  `

#####On master
	
>`	vi /usr/local/hadoop/conf/masters`  
	`<master ip>`  
	`vi /usr/local/hadoop/conf/slaves`  
	`<all data node ips>`
	`vi core-site.xml, hdfs-site.xml, mapred-site.xml`  
	`ssh-copy-id -i ~/.ssh/id_rsa hadoop-user@<all data node ips>`

#####On slaves  

>`	vi /usr/local/hadoop/conf/masters`  
	`<master ip>`  
	`vi /usr/local/hadoop/conf/slaves`  
	`<its own ip>`  
	`vi core-site.xml, hdfs-site.xml, mapred-site.xml`  
	`ssh-copy-id -i ~/.ssh/id_rsa hadoop-user@<master ip>`  
	`rm -rf /usr/local/hadoop/tmp/*`

#####On master  

>`	start-all.sh`  
	Test by copying file on master and view on slaves  
	
>`	hadoop dfsadmin -safemode leave`  

####4. Installing Hadoop 2.0
  * Clone the ubuntu server vm  
  * Set up the new server vm
  
>`	sudo vi /etc/hostname`  
	`<server name>`  
	`sudo vi /etc/network/interfaces`  
	`change ip`

>`	sudo apt-get install ssh`  
	`sudo apt-get install rsync`  
	`ssh-keygen`  
	`cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys`

>`	vi hadoop-env.sh`  
	`JAVA_HOME HADOOP_PREFIX`

>`	mkdir /usr/local/hadoop/tmp`  
	`mkdir /usr/local/hadoop/logs`

>`	vi core-site.xml`  
	`fs.defaultFS = hdfs://<server ip>:9000`  
	`hadoop.tmp.dir=/usr/local/hadoop/tmp`

>`	vi hdfs-site.xml`  
	`dfs.replication = 1`

>`	vi mapred-site.xml`  
	`mapreduce.framework.name = yarn`

>`	vi yarn-site.xml`  
	`yarn.nodemanager.aux-services = mapreduce_shuffle`

>`	hdfs namenode -format`  
	`start-dfs.sh`  
	`start-yarn.sh`

###Lesson 5 Develop mapreduce on ubuntu desktop
####1. Installing Ubantu Desktop  
  * Download and install ubuntu desktop
  * Install Eclipse from software centre
  * Install hadoop as per server
####2. Create Eclipse Project  
  * Use Eclipse to create WordCount project
  * Run on /data/small/war_and_peace.txt
  
>`	set arguements:`
	`hdfs://localhost:9000/data/small/war_and_peace.txt`
	`hdfs://localhost:9000/data/small/output1`  
	Browse the hadoop web ui
####3. Run JAR  
  * Run the a jar
  
>`	hadoop jar /usr/local/hadoop/hadoop-example-1.2.1jar pi 10 10`
####4. Create AvgTemp project
  * Create in Eclipse
  
>`	AvgTemperature.java, AvgTemperatureMapper.java, AvgTemperatureReducer.java`  
	`hdfs://<ip>:9000/data/big/201201hourly.txt`  
	`hdfs://<ip>:9000/data/big/output1`  
	Browse web ui  
	
###Lesson 6 Advance mapreduce
####1. Set up HDFS infrastructure  
  * Check r/w rates
  
>`	hadoop jar /usr/local/hadoop/hadoop-test-1.2.1.jar TestDFSIO -write nrFiles 5 -fileSize 100`  
	`hadoop jar /usr/local/hadoop/hadoop-test-1.2.1.jar TestDFSIO -read  nrFiles 5 -fileSize 100`
	
  * Change block size  
  
>`	vi hdfs-site.xml`  
	`dfs.block.size=134217728`  
	`stop / start -all.sh`  
	`hadoop fs -copyFromLocal /data/big/201201hourly.txt hdfs:/datanew/big/201201hourl.txt`  
	Browse webui to see block size change
  
  * Decomission
  
>`	vi hdfs-site.xml`  
	`dfs.hosts.exclude=/usr/local/hadoop/conf/exclude`  
	`vi /usr/local/hadoop/conf/exclude`  
	`ip of nodes to exclude`  
	`hadoop dfsadmin -refreshNodes`
####2. Writable Classes
  * Create Project  
	App.java, EarthquakeMapper.java, EarthQuakeReducer.java, input.csv  
  * Run and Browse web UI
	
###Lesson 7 Pig
####1. Download and Install Pig
  * Download and Install
  [www.pig.apache.org](http://www.pig.apache.org)  
  Project->Release-> version 0.11.1 
  
>`	tar -xvzf pig-0.11.1.tar.gz`  
	`ln -s <pig folder> /usr/local/pig`  
	`vi .bashrc`  
	`export JAVA_HOME`  
	`export PIG_PREFIX`  
	`export PATH`  
	`pig -x local`  
	`pig -x mapreduce`
	
  * Test local and mapreduce modes  
  
>`	pig -x local`  
	`ls /`  
	`pig -x mapreduce`  
	`ls hdfs:/`
	
  * Access Remote Cluster - Optional  
#####On hadoop master  
	
>`	cd $HADOOP_HOME`
	`tar -czvf client.tar.z core-site.xml hadoop-env.sh hdfs-site.xml log4j.properties mapred-site.xml ssl-client.xml.example`  

#####On local machine  

>`	mkdir hadoop.conf`  
	`cd hadoop.conf`  
	`tar -zxvf ../client.tar.z .`  
	`vi .bashrc or .profile`  
	`export HADOOP_CONF_DIR=$HOME/hadoop.conf`  
	`export JAVA_HOME =`

####2. Convert lines into words
  * Mapreduce Mode  
  
>`  hadoop fs -copyFromLocal /data/testdata.txt hdfs:/data/testing/testdata.txt`  
	`pig`  
	`ls hdfs:/data/testing`  
	`file = LOAD 'hdfs:/data/testing/testdata.txt' USING PigStorage() AS (lines:chararray);`  
	`words = FOREACH file GENERATE FLATTEN(TOKENIZE(lines)) as word;`  
	`dump words;`
	
  *	Local Mode  
  
>`	pig -x local`  
	`ls /home/hadoop/data/testing`  
	`file = LOAD '/home/hadoop/data/testing/testdata.txt' USING PigStorage() AS (lines:chararray);`  
	`words = FOREACH file GENERATE FLATTEN(TOKENIZE(lines)) as word;`  
	`dump words;`
  
####3. Examples	
  * Example - User login 
  
>`	vi login.txt`  
	`name, 20150122114530`  
	`copyFromLocal`  
	`pig`  
	`userLogin = load '/learning/login.txt' using PigStorage(',') as (user:chararray, time:long);`  
	`dump userLogin;`  
	
  *	Example - WordCount  
  
>`	file = load ’hdfs:/data/testing/testdata.txt’ using PigStorage() as (line:chararray);`  
	`words = foreach file generate flatten(tokenize(lines)) as word;`  
	`wgroup = group words by word;`  
	`wagg = foreach wgroup generate group as word, count(words);`  
	`dump wagg;`  
#####Try local mode too  
	
  * Example - Load Temperatures  
  
>`	hadoop fs -copyFromLocal /home/sl000/data/big/* hdfs:/data/big/`  
	`Check .pig_schema file exists`  
	`pig`  
	`jan = LOAD 'hdfs:/data/big/201201hourly.txt' USING PigStorage(',');`  
	`feb = LOAD 'hdfs:/data/big/201202hourly.txt' USING PigStorage(',');`  
	`mar = LOAD 'hdfs:/data/big/201203hourly.txt' USING PigStorage(',');`  
	`apr = LOAD 'hdfs:/data/big/201204hourly.txt' USING PigStorage(',');`  
	`STORE jan INTO 'hdfs:/data/big/results/weatherresults1' USING PigStorage('|');`  
	
>	Browse web ui  
	
  * Example - Count the Occurances script  
    Create script, run on war_and_peace.txt, browse web ui  
	
  * Example - Combining, Splitting, and Joining of Temperatures
  
>`	jan = LOAD 'hdfs:/data/big/201201hourly.txt USING PigStorage(',');`  
	`feb = LOAD 'hdfs:/data/big/201202hourly.txt USING PigStorage(',');`  
	`mar = LOAD 'hdfs:/data/big/201203hourly.txt USING PigStorage(',');`  
	`apr = LOAD 'hdfs:/data/big/201204hourly.txt USING PigStorage(',');`  
	`month_quad = UNION jan,feb,mar,apr;`  
	`Store month_quad into 'hdfs:/data/big/pigresults/month_quad';`  
	
>	Browse the web ui - 50070  
	
>`	SPLIT month_quad INTO split_jan IF SUBSTRING (Date, 4, 6) == '01', split_feb IF SUBSTRING (Date, 4, 6) == '02', split_mar IF SUBSTRING (Date, 4, 6) == '03', split_apr IF SUBSRTING (Date, 4, 6) == '04';`  
	`STORE split_jan INTO 'hdfs:/data/big/results/jan';`  
	
>	Browse the web ui again.

  * Example - Transform and shape Temperatures Script  
	Create, run and browse.
	
  * Example - Grouping with no of reducer  
	Create, run and browse  

###Lesson 8 Hive
####1. Download and Install Hive
  * Download and Install  
  [  hive-0.11.1 https://archive.apache.org/dist/hive/hive-0.11.0/](https://archive.apache.org/dist/hive/hive-0.11.0/)  
  
>`	tar -xvzf hive-0.11.1.tar.gz`  
	`ln -s <hive folder> /usr/local/hive`  
	`vi .bashrc`  
	`export HIVE_PREFIX=`  
	`export PATH=`  
	`exec bash`  
	`hive`
	
###2. Perform data analytics with hive  
  * Example -  
  
>`	CREATE TABLE book(word STRING)`  
	`ROW FORMAT DELIMITED`  
	`FIELDS TERMINATED BY ' '`  
	`LINES  TERMINATED BY '\';`  
	`LOAD DATA INPATH 'hdfs:/data/small/war_and_peace.txt' INTO TABLE book;`  
	`SHOW TABLES;`  
	`DESCRIBE book;`  
	`SELECT LOWER(word), COUNT(*) AS Count FROM book`  
	`WHERE lower(substring(word,1,3))='was'`  
	`GROUP BY word`  
	`HAVING COUNT > 5`  
	`SORT BY COUNT DESC;`  
	
	Observe job result on the screen

###Lesson 9 Hbase
####1. Download and Install Hbase
  * Download and Install  
  [www.hbase.apache.org](http://www.hbase.apache.org)  
  hbase-0.94.17  
  
>`	tar -xvzf hbase-0.94.17.tar.gz`  
	`ln -s <hbase folder> /usr/local/hbase` 
	`vi .bashrc`  
	`export HBASE_PREFIX =`  
	`export PATH=`  
	`exec bash`  
	`vi hbase-env.sh`  
	`export JAVA_HOME=/usr/local/java`  
	`vi hbase-site.xml`  
	`hbase.rootdir=hdfs://<server ip>:9000/hbase`  
	`vi regionservers`  
	`<region server ip>`  
	`start-hbase.sh`  
	Go to http://<ip>:60010 to verify  
	
####2. Run hbase shell (Optional)
  * Run hbase shell
  
>`	hbase shell`  
	`help`  
	`create 'tbl1', 'cf1'`  
	`list 'tbl1'`  
	`put 'tbl1', 'row1', 'cf1:a', 'val1'`  
	`put 'tbl1', 'row2', 'cf1:b', 'val2'`  
	`put 'tbl1', 'row3', 'cf1:c', 'val3'`  
	`scan 'tbl1'`  
	`get 'tbl1', 'row1'`  
	`disable 'tbl1'`  
	`enable 'tbl1'`  
	`stop-hbase.sh`  
	
###Lession 10 Hadoop Commercial Distribution
####1. Cloudera VM
  * Download Cloudera vm  
  * Show Hue and Cloudera Manager  
  * Eclipse - WordCount  
	Add external libraries - all jars in /usr/lib/hadoop  
	Add all jars in /usr/lib/hadoop/client-0.20  
	Add /usr/lib/hadoop/lib/commons-httpclient-3.1.jar  
	Use war_and_peace.txt  
	
###Lession 11 ZooKeeper, Flume and Sqoop
####1. ZooKeeper  
  * Install and Configure ZooKeeper
	[zookeeper-3.4.5 http://zookeeper.apache.org](http://zookeeper.apache.org)
	
>`	tar -xzvf zookeeper-3.4.5.tar.gz`  
	`ln -s <zookeeper folder> /usr/local/zookeeper`  
	`vi .bashrc`  
	`export ZOOKEEPER_PREFIX=`  
	`export PATH=`  
	`exec bash`  
	`cp zoo_sample.cfg zoo.cfg`
	`vi zoo.conf`  
	`tickTime=2000`  
	`dataDir=/tmp/zookeeper`  
	`clientPort=2181`  
	`zkServer.sh start`  
	`zkCli.sh -server 127.0.0.1:2181`  
	`help`  
	`ls /`  
	`ls /hbase`  
	`get /hbase`
	
####2. Sqoop  
  * Install Sqoop
	[Download version 1.4.5 from http://apache.mirror.uber.com.au/sqoop/1.4.5/sqoop-1.4.5.bin__hadoop-1.0.0.tar.gz ](http://apache.mirror.uber.com.au/sqoop/1.4.5/sqoop-1.4.5.bin__hadoop-1.0.0.tar.gz)
  
>`	tar -xzvf sqoop-1.4.5.bin__hadoop-1.0.0.tar.gz`  
	`ln -s <sqoop folder> /usr/local/sqoop`  
	`vi .bashrc`  
	`export SQOOP_PREFIX`  
	`export PATH`  
	`exec bash`
	`cp /usr/local/sqoop/conf/sqoop-env.template.sh /usr/local/sqoop/conf/sqoop-env.sh`  
	`vi sqoop-env.sh`  
	`export HADOOP_COMMON_HOME=/usr/local/hadoop`  
	`export HADOOP_MAPRED_HOME=/usr/local/hadoop`  
	
  * Install MySql and create table  
  
>`	sudo apt-get install mysql-server`  
	`mysql -u root -p`  
	`create database sl;`  
	`use sl;`  
	`create table authentication(username varchar(30), password varchar(30));`  
	`insert into authentication values('admin', '12345');`  
	`select * from authentication;`
	
  * Download MySql Connector  
	[http://www.mysql.com/downloads/](http://www.mysql.com/downloads/)  
	use platform independent option  
	
>`	cp mysql-connector-java-5.1.34-bin.jar to /usr/local/sqoop/lib`  

  * Import data to sqoop  
>`	mysql`  
	`create user hadoop;`  
	`grant all privileges on *.* to 'hadoop'@'localhost' identified by 'hadoop';`  
	
>`	sqoop list-databases --connect "jdbc:mysql://localhost" --username hadoop --password  hadoop`  
	`sqoop import --connect "jdbc:mysql://localhost/sl" --username hadoop --password hadoop --table authentication --target-dir /data/sqoop/output/authentication -m 1`  
	Browse hdfs web ui  
	
  * Export data from sqoop  
  
>`	mysql -u hadoop -p`  
	`create database s2;`  
	`use s2;`  
	`create table authentication(username varchar(20), password varchar(20));`  
	`quit;`  
	`sqoop export --connect "jdbc:mysql://localhost/s2" --username hadoop --password hadoop --table authentication --export-dir /data/sqoop/output/authentication/`  
	`mysql -u hadoop -p;`  
	`user s2;`  
	`select * from authentication;`  
	
####3. Flume  
  * Download and install  
  [Download version 1.4.0 from http://flume.apache.org](http://flume.apache.org)  
  
>`	tar -xzvf apache-flume-1.4.0-bin.tar.gz`  
	`ln -s <flume folder> /usr/local/flume`  
	`vi .bashrc`  
	`export FLUME_PREFIX`  
	`export PATH`  
	`exec bash`  
	`vi /usr/local/flume/conf/flume.conf`  
	`see york's github`  
	`vi log4???`  
	`check but keep the no change`  
	`chmod a+w /var/log`  
	`create generate_logs.py`  
	`flume-ng agent -c /usr/local/flume/conf -f /usr/local/flume/conf/flume.conf -n sandbox`  
	
	Open another terminal ALT+F2
	
>	`python generate_logs.py`  
	`ls -l /var/log/eventLog*`  
	`hadoop fs -ls /flume/events`  
	`flume-ng version`  
	
###Lession 13 Hadoop Administration and Troubleshooting
####1. Troubleshooting missing datanote  
  * Format namenode and lose data  
  
>`	hadoop namenode -format`  
	`start-all.sh`  
	`jps`
  * Troubleshooting  
  
>`	vi /usr/local/hadoop/logs/hadoop-hadoop-datanode-<machinename>.log`  
	`Note down namespace ID, ie. 1xxxxxx`  
	`vi /usr/local/hadoop/tmp/data/current/VERSION`  
	`replace the namespace id with 1xxxxx`  
	`stop-all.sh`  
	`start-all.sh`  
	`jps`  
	`Check data node exists`
	
####2. Optimize hadoop cluster
  * Create data  
  
>`	hadoop jar /usr/local/hadoop/hadoop-examples-1.2.1.jar tergen 5242880 /data/demoinput`  
	Browse hdfs web ui  
	
  * Run test sort  
  
>`	hadoop jar /usr/local/hadoop/hadoop -examples-1.2.1.jar tersort /data/demoinput /data/demooutput`
	Browse mapreduce ui 50030 and check tersort job  
	
  * Modify config  
  
>`	vi hdfs-site.xml`  
	`dfs.replication = 2, dfs.block.size=134217728, dfs.datanode.handler.count=5`  
	`vi mapred-site.xml`  
	`io.sort.factor=20, io.sort.mb=200, mapred.tasktracker.map.tasks.maximum=3, mapred.reduce.tasks=12, mapred.child.java.opts=-Xmx300m`  
	`hadoop dfs -rmr /data/demooutput`  
	`hadoop dfs -rmr /data/demoinput`  
	`stop-all.sh`  
	`start-all.sh`  
	`jps`  
	`hadoop jar /usr/local/hadoop/hadoop-examples-1.2.1.jar teragen /data/demoinput`  
	`hadoop jar hadoop-examples-1.2.1.jar terasort /data/demoinput /data/demooutput`  
	Brose 50070 web ui for data , click the 2nd job to find execution time.  
	
	
###Tooltips
####1. Access usb on ubuntu
	In the vm setting show all usb devices  
	`sudo fdisk -l`  
	`sudo  mkdir /media/usb`  
	`sudo mount /dev/sdb1 /media/usb`  
	`sudo umount /media/usb`  
	
	
