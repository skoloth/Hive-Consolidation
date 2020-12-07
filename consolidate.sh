#!/bin/bash
dateToPartition=$1;
validateArguments();

consolidate(){
#Step 1: First let us create temporary partition
tempPartitionDate=`date '+%C%y%m%d' -d "$dateToPartition+1000 days"`

#Step 2: Insert the hive data into tempPartitionDate
hive -e "use customer; insert into table customer_click_events partition ('$tempPartitionDate') select customerid, name, lastUpdatedActivity, isProductPurchase, purchasedProductName, city from customer_click_events where day='$dateToPartition' ";
status=$?

if [$status -eq 0]; then

#step3: Now once insertion to tempPartitionDate is successful, we can safely overwrite the actual partition date. In below step we are overwriting same data to actual partition, when hive rewrites it writes a bulk with map-reduce job and consolidates by default. 

hive -e "use customer; insert overwrite table customer_click_events partition ('$dateToPartition') select customerid, name, lastUpdatedActivity, isProductPurchase, purchasedProductName, city from customer_click_events where day='$tempPartitionDate' ";
consolidationstatus=$?

    if [$consolidationstatus -eq 0]; then
       #step 4-  Now you can safely drop temp partition data
       hive -e "use customer; ALTER table customer_click_events drop if exists PARTITION (day='$tempPartitionDate')";
    else 
     echo - "failed to drop temp partition, manually drop the temp partition. This rarely happens. Only when cluster is down";
   fi
else
 echo "consolidation failed while inserting into tempPartitionDate"
 exit 12;#Any non-zero exit code to alert that there was a failure in consolidation process.
fi
}

#Validate arguments are passed, 
validateArguments(){
if [ $# -gt 0 ]; then
    consolidate();
else
    echo "Your command line contains no arguments,pass date in YYYYMMDD format, for example pass- ./consolidate.sh 20191010"
	exit 11;#Any non-zero exit code to alert that there was a failure in usage of script.
fi
}
