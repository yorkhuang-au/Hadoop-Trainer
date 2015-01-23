###Lesson 4
####1. Installing Ubantu Server  
  * Select OpenSSH
  * Set up static IP (optional)  
>`	sudo vi /etc/network/interfaces  
	auto eth0  
	iface eth0 inet static  
	     address 192.168.186.3  
	     netmask 255.255.255.0  
	     gateway 192.168.186.2  
	     dns-nameservers 192.168.186.2  
	sudo ifdown eth0  
	sudo ifup eth0  
	or sudo reboot
	`
	<br><br>
>`	edit c:\windows\system32\drivers\etc\hosts
	<server ip> <server name>`

####2. Installing Hadoop on Ubantu Server  
  * Update Ubuntu Server  
>`	sudo apt-get update`
  
  * Create ssh key
>`	ssh_keygen  
	cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys  
	ssh <server ip>  `
		
  * Install Java JDK
>`	sudo apt-get install openjdk-7-jdk 	
	java -version  
	java -showversion  
	update-java-alternatives -l  
	ln -s <java folder> /usr/local/java  `
		
  * Download and install Hadoop 1.2.1  
	Go to [Apache Hadoop homepage](http://hadoop.apache.org/releases.html#Download ) to download Hadoop 1.2.1  
>`   tar -xzvf hadoop-1.2.1.tar.gz  
	ln -s <hadoop folder> /usr/local/`
	<br><br>
>`	vi ~/.bashrc  
	export HADOOP_PREFIX=/usr/local/hadoop  
	export PATH=$PATH:$HADOOP_PREFIX/bin  
	exec bash  `
	<br><br>
>`	vi /usr/local/hadoop/conf/hadoop-env.sh  
	JAVA_HOME=/usr/local/java  
	HADOOP_OPTS=`
	<br><br>
>`	mkdir /usr/local/hadoop/logs  
	mkdir /usr/local/hadoop/tmp`
	<br><br>
>`	vi /usr/local/hadoop/conf/core-site.xml  
	fs.default.name = hdfs://<server ip>:9000  
	hadoop.tmp.dir = /usr/local/hadoop/tmp`
	<br><br>
>`	vi /usr/local/hadoop/conf/hdfs-site.xml  
	dfs.replication = 1`
	<br><br>
>`	vi /usr/local/hadoop/conf/mapred-site.xml  
	mapred.job.tracker = <server ip>:9001`
	<br><br>
>`	vi /usr/local/hadoop/conf/masters  
	localhost`
	<br><br>
>`	vi /usr/local/hadoop/conf/slaves  
	localhost`
	<br><br>
>`	hadoop namenode -format`

  * Start/stop hadoop and testing  
>`	start-all.sh  
	jps  
	stop-all.sh  
	hadoop fs -mkdir -ls -copyFromLocal -copyToLocal -cat -rm -rmr  
	hadoop jar /usr/local/hadoop/hadoop-examples-1.2.1.jar word count <input> <output>`
	<br><br>
	Browse hdfs at http://<server ip>:50070

####3. Installing Hadoop on Ubantu Cluster  
  * Clone the ubuntu server vm  
  * Set up each machine  
>`	sudo vi /etc/hostname  
	<server name>  
	sudo vi /etc/network/interfaces  
	change ip  `
	<br><br>
	On master  
>`	vi /usr/local/hadoop/conf/masters  
	<master ip>  
	vi /usr/local/hadoop/conf/slaves  
	<all data node ips>
	vi core-site.xml, hdfs-site.xml, mapred-site.xml  
	ssh-copy-id -i ~/.ssh/id_rsa hadoop-user@<all data node ips>`
	<br><br>
	On slaves  
>`	vi /usr/local/hadoop/conf/masters  
	<master ip>  
	vi /usr/local/hadoop/conf/slaves  
	<its own ip>  
	vi core-site.xml, hdfs-site.xml, mapred-site.xml  
	ssh-copy-id -i ~/.ssh/id_rsa hadoop-user@<master ip>`
	<br><br>
	On master  
>`	start-all.sh`  
	Test by copying file on master and view on slaves  
>`	hadoop dfsadmin -safemode leave`  

####4. Installing Hadoop 2.0
  * Clone the ubuntu server vm  
  * Set up the new server vm
>`	sudo vi /etc/hostname  
	<server name>  
	sudo vi /etc/network/interfaces  
	change ip`
	<br><br>
>`	sudo apt-get install ssh  
	sudo apt-get install rsync  
	ssh-keygen  
	cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys`
	<br><br>
>`	vi hadoop-env.sh  
	JAVA_HOME HADOOP_PREFIX`
	<br><br>
>`	vi core-site.xml  
	fs.defaultFS = hdfs://<server ip>:9000`
	<br><br>
>`	vi hdfs-site.xml  
	dfs.replication = 1`
	<br><br>
>`	vi mapred-site.xml  
	mapreduce.framework.name = yarn`
	<br><br>
>`	vi yarn-site.xml  
	yarn.nodemanager.aux-services = mapreduce_shuffle`
	<br><br>
>`	start-dfs.sh  
	start-yarn.sh`
	`
###Lesson 5
####1. Installing Ubantu Desktop  
  * Download and install ubuntu desktop
  * Install Eclipse from software centre
  * Install hadoop as per server
####2. Create Eclipse Project  
  * Use Eclipse to create WordCount project
  * Run on /data/small/war_and_peace.txt
>`	set arguements:
	hdfs://localhost:9000/data/small/war_and_peace.txt
	hdfs://localhost:9000/data/small/output1`  
	Browse the hadoop web ui
####3. Run JAR  
  * Run the a jar
>`	hadoop jar /usr/local/hadoop/hadoop-example-1.2.1jar pi 10 10`
####4. Create AvgTemp project
  * Create in Eclipse
>`	AvgTemperature.java, AvgTemperatureMapper.java, AvgTemperatureReducer.java  
	hdfs://<ip>:9000/data/big/201201hourly.txt  
	hdfs://<ip>:9000/data/big/output1`  
	Browse web ui  

	
###Lesson 6
####1. Set up HDFS infrastructure  
  * Check r/w rates
>`	hadoop jar /usr/local/hadoop/hadoop-test-1.2.1.jar TestDFSIO -write nrFiles 5 -fileSize 100  
	hadoop jar /usr/local/hadoop/hadoop-test-1.2.1.jar TestDFSIO -read  nrFiles 5 -fileSize 100`
	
  * Change block size  
>`	vi hdfs-site.xml  
	dfs.block.size=134217728  
	stop / start -all.sh  
	hadoop fs -copyFromLocal /data/big/201201hourly.txt hdfs:/datanew/big/201201hourl.txt`  
	Browse webui to see block size change
  
  * Decomission
>`	vi /usr/local/hadoop/conf/exclude  
	ip of nodes to exclude  
	hadoop dfsadmin -refreshNodes`
####2. Writable Classes
  * Create Project  
	App.java, EarthquakeMapper.java, EarthQuakeReducer.java, input.csv  
  * Run and Browse web UI
	
###Lesson 7
####1. Download and Install Pig
  * Download and Install
  [www.pig.apache.org](http://www.pig.apache.org)  
  Project->Release-> version 0.11.1  
>`	tar -xvzf pig-0.11.1.tar.gz  
	ln -s <pig folder> /usr/local/pig  
	vi .bashrc  
	export PIG_PREFIX  
	export PATH  
	pig -x local  
	pig -x mapreduce`
	
  * Test local and mapreduce modes  
>`	pig -x local  
	ls /  
	pig -x mapreduce  
	ls hdfs:/`
	
  * Access Remote Cluster - Optional  
	On hadoop master  
>`	cd $HADOOP_HOME
	tar -czvf client.tar.z core-site.xml hadoop-env.sh hdfs-site.xml log4j.properties mapred-site.xml ssl-client.xml.example`  

	On local machine  
>`	mkdir hadoop.conf  
	cd hadoop.conf  
	tar -zxvf ../client.tar.z .  
	vi .bashrc or .profile  
	export HADOOP_CONF_DIR=$HOME/hadoop.conf  
	export JAVA_HOME =`

####2. Convert lines into words
  * Mapreduce Mode  
>`  hadoop fs -copyFromLocal /data/testdata.txt hdfs:/data/testing/testdata.txt  
	pig  
	ls hdfs:/data/testing  
	file = LOAD 'hdfs:/data/testing/testdata.txt' USING PigStorage() AS (lines:chararray);  
	words = FOREACH file GENERATE FLATTEN(TOKENIZE(lines)) as word;  
	dump words;`
	
  *	Local Mode  
>`	pig -x local
	ls ~/data/testing
	file = LOAD 'hdfs:/data/testing/testdata.txt' USING PigStorage() AS (lines:chararray);  
	words = FOREACH file GENERATE FLATTEN(TOKENIZE(lines)) as word;  
	dump words;`
  
####3. Examples	
  * Example - User login 
>`	vi login.txt  
	name, 20150122114530  
	copyFromLocal  
	pig  
	userLogin = load '/learning/login.txt' using PigStorage(',') as (user:chararray, time:long);  
	dump userLogin;`
  *	Example - WordCount  
>`	file=load ’hdfs:/data/testing/testdata.txt’ using PigStorage() as (line:chararray);  
	words = foreach file generate flatten(tokenize(lines)) as word;  
	wgroup = group words by word;  
	wagg = foreach wgroup generate group as word, count(words);  
	dump wagg;`  
	Try local mode too  
  * Example - Load Temperatures  
>`	hadoop fs -copyFromLocal /home/sl000/data/big/* hdfs:/data/big/  
	Check .pig_schema file exists
	pig  
	jan = LOAD 'hdfs:/data/big/201201hourly.txt' USING PigStorage(',');  
	feb = LOAD 'hdfs:/data/big/201202hourly.txt' USING PigStorage(',');  
	mar = LOAD 'hdfs:/data/big/201203hourly.txt' USING PigStorage(',');  
	apr = LOAD 'hdfs:/data/big/201204hourly.txt' USING PigStorage(',');  
	STORE jan INTO 'hdfs:/data/big/results/weatherresults1' USING PigStorage('|');`  
	Browse web ui  
	
  * Example - Count the Occurances script  
    Create script, run on war_and_peace.txt, browse web ui  
	
  * Example - Combining, Splitting, and Joining of Temperatures
>`	jan = LOAD 'hdfs:/data/big/201201hourly.txt USING PigStorage(',');  
	feb = LOAD 'hdfs:/data/big/201202hourly.txt USING PigStorage(',');  
	mar = LOAD 'hdfs:/data/big/201203hourly.txt USING PigStorage(',');  
	apr = LOAD 'hdfs:/data/big/201204hourly.txt USING PigStorage(',');  
	month_quad = UNION jan,feb,mar,apr;  
	Store month_quad into 'hdfs:/data/big/pigresults/month_quad';`
	
	Browse the web ui. (50070)  
>`	SPLIT month_quad INTO split_jan IF SUBSTRING (date, 4, 6) == '01', split_feb IF SUBSTRING (date, 4, 6) == '02', split_mar IF SUBSTRING (date, 4, 6) == '03', split_apr IF SUBSRTING (date, 4, 6) == '04';  
	STORE split_jan INTO 'hdfs:/data/big/results/jan';`
	
	Browse the web ui again.

  * Example - Transform and shape Temperatures Script
	Create, run and browse.

	
	
  