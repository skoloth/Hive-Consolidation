# Hive-Consolidation

Code sample for doing consolidation of hive big data table.

Step 1:

Make sure we can already hive table where data is getting ingested. For illustration purpose, I have uploaded a sample hql file which have logic to create hive table.
The file name is customer_events.hql

Command to run hql file in edge node:
hive -f customer_event.hql

This command will create your hive table in your hadoop cluster.

Step 2:

Let's say you have live data written in table customer_click_events, in day partition. As per the hql file, you can data is written in below hive location
/data/customevents/

So when live data is ingested, the data will be written in day partition. Let's assume today's date is 20200101
- hdfs dfs -ls /data/customevents/day=20200101/

  /data/customevents/day=20200101/part00000-djwhu28391
  
  /data/customevents/day=20200101/part00001-gjwhu28e92
  
  /data/customevents/day=20200101/part00002-hjwhu28342
  
  /data/customevents/day=20200101/part00003-dewhu28392
  
  /data/customevents/day=20200101/part00004-dfdhu24342
  
  /data/customevents/day=20200101/part00005-djwhu28fdf
  
  /data/customevents/day=20200101/part00006-djwffd8392
  
  /data/customevents/day=20200101/part00007-ddfdggg292
  
  so on
 

 --
 --
 --
 
 
 So, when day finishes, you will end up having so many part files ranging anywhere from greater than 100k to million, this purley depends on volume of your applciation.
 You can see the count by, example:
 hdfs dfs -count -v /data/customevents/day=20200101/*
 count = 141000
 
 Step 3:
 
 On 2020-01-02, i.e. next day, around 1 am, now we should run consolidation job. The sample code is uploaded in git. The file name is consolidation.sh.
 Below are command to run in your edge node/box
 
 ./consolidate.sh 20200101
 
 This will now consolidate previous day data. After it finished , you can rerun the count
 hdfs dfs -count -v /data/customevents/day=20200101/*
 count = 800
 
 So before it was 141K and after consolidation, the count is 800. So this will give significant performance benefit.
 
 Final:
 
 We can automate this running daily by having a job scheduler. You can use control m to do that or using cron job.
 
 Conclusion:
 
 This sample code gives you high level idea how to consolidate and steps to do that. You may need to change it as per your project/business needs.
 
 Thank you.
 
 
