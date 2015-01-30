

import java.io.IOException; 
import java.util.*; 
import org.apache.hadoop.fs.Path; 
import org.apache.hadoop.conf.*; 
import org.apache.hadoop.io.*; 
import org.apache.hadoop.mapred.*; 
import org.apache.hadoop.util.*; 
import org.apache.hadoop.fs.*;
import org.apache.hadoop.mapred.TextInputFormat;

import java.util.regex.Matcher;
import java.util.regex.Pattern;



public class Insurance { 



	public static class NonSplittableTextInputFormat extends TextInputFormat {
	    @Override
	    protected boolean isSplitable(FileSystem fs, Path file) {
	        return false;
	    }
	}	
  
   public static class Map extends MapReduceBase implements Mapper<LongWritable, Text, Text, Text> { 
        private IntWritable one = new IntWritable(1); 
        private Text word = new Text(); 
        private Text value = new Text();

        private static final String HeaderRegEx = "Perceived\\sHealth\\sStatus\\sby\\sSelected\\sCharacteristics\\sand\\sHealth\\sInsurance\\sStatus:\\s*(\\d+)";
        private static final String PrvInsRegEx = "People\\saged\\s18-64\\s+[\"]*(\\d*).*Privately\\sinsured\\s\\(alone\\sor\\s*in\\scombination\\)\\s*(\\d*\\.\\d*|\\d*).*"
        		+ "People\\saged\\s65\\sand\\solder\\s+[\"]*(\\d*).*Publically\\sinsured\\s\\(no\\sprivate\\)\\s*(\\d*\\.\\d*|\\d*).*"
        		+ "Family\\sincome\\sless\\sthan\\s200\\spercent\\sof\\spoverty\\sthreshold";
    
        private static final Pattern HeaderPattern = Pattern.compile(HeaderRegEx, Pattern.MULTILINE);
        private static final Pattern PrvInsPattern = Pattern.compile(PrvInsRegEx, Pattern.MULTILINE);
 
  
     public void map(LongWritable key, Text value, OutputCollector<Text, Text> output, Reporter reporter) throws IOException { 
          String line = value.toString();

          Matcher headerm = HeaderPattern.matcher(line);

          if(headerm.find()) {

        	  
        	  String line1 = value.toString().replace("," , "");
        	  
        	  Matcher dm = PrvInsPattern.matcher(line1);
        	  
        	  if(dm.find()) {
            	  word.set("18to64-prv-ins");
            	  value.set( dm.group(1) + "," + dm.group(2));
            	  output.collect( word, value);
            	  
            	  word.set("OlderThan65-pub-ins");
            	  value.set(dm.group(3)+","+ dm.group(4));
            	  output.collect(word, value);
        		  
        	  }

          }


        } 
        
      } 
    
  
   public static class Reduce extends MapReduceBase implements Reducer<Text, Text, Text, Text> { 
  
     public void reduce(Text key, Iterator<Text> values, OutputCollector<Text, Text> output, Reporter reporter) throws IOException { 
    	 
          int totsum = 0;
          double sum = 0;
          while (values.hasNext()) {
        	  String [] s = values.next().toString().split(",");
            //sum += values.next().get();
        	  totsum += Integer.parseInt(s[0]);
        	  sum += Integer.parseInt(s[0]) * Double.parseDouble(s[1])/100;
          } 
          
          output.collect(key, new Text( ":  total Num=" + totsum + " key num = " + Math.round(sum) + " %=" + sum/totsum)); 

    	 
        } 
      } 
    
      public static void main(String[] args) throws Exception { 
        JobConf conf = new JobConf(WordCount.class); 
        conf.setJobName("wordcount"); 
    
        conf.setOutputKeyClass(Text.class); 
        conf.setOutputValueClass(Text.class); 
    
        conf.setMapperClass(Map.class); 
//        conf.setCombinerClass(Reduce.class); 
        conf.setReducerClass(Reduce.class); 
    
        conf.setInputFormat(NonSplittableTextInputFormat.class); 
        conf.setOutputFormat(TextOutputFormat.class); 
    
        FileInputFormat.setInputPaths(conf, new Path(args[0])); 
        FileOutputFormat.setOutputPath(conf, new Path(args[1])); 
    
        JobClient.runJob(conf); 
      } 
} 
 
 