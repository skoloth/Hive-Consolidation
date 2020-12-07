
CREATE DATABASE IF NOT EXISTS CUSTOMER

CREATE EXTERNAL TABLE customer_click_events (
customerid bigint,
name string,
lastUpdatedActivity string,
isProductPurchase boolean,
purchasedProductName string,
city string
) PARTITIONED BY(day string)
  STORED AS ORC LOCATION '/data/customevents/'
  TBLPROPERTIES('orc.bloom.filter.columns'='*','orc.compress'='ZLIB');


