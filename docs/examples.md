## Upload to an aws bucket
Profile osps is using &lt;osp⚡&gt; over https, myaws is direct.

![aws upload](img/output.webp)

## Generate TPC-H test data using duckdb

![duckdb](img/DuckDB_Logo-horizontal.svg){ width=120px }

Generate some [TPC-H](https://www.tpc.org/tpch/) testdata using <i class="fab fa-github"> </i> [dbgen](https://github.com/jeroenflvr/dbgen) with a table on an aws bucket and another table on an ibm cos bucket. 

![dbgen x10 (budget vm)](img/dbgen.webp)

![spark](img/Apache_Spark_logo.svg){ width=120px }

Create two dataframes from the tpc-h dataset generated earlier, for customer and orders.
Get the top 10 customers.
All using a single set of credentials.

```python
import os
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, count, max as _max, desc

access_key = os.environ["AWS_ACCESS_KEY_ID"]
secret_key = os.environ["AWS_ACCESS_SECRET_KEY"]

spark = SparkSession.builder \
    .appName("TPCH") \
    .config("spark.hadoop.fs.s3a.access.key", access_key) \
    .config("spark.hadoop.fs.s3a.secret.key", secret_key) \
    .config("spark.hadoop.fs.s3a.endpoint", f"https://localhost:8443") \
    .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem") \
    .config("spark.hadoop.fs.s3a.path.style.access", "true") \
    .getOrCreate()

spark.sparkContext.setLogLevel("ERROR")

customers = spark.read.parquet("s3a://proxy-bucket01/tpch/sf10/customer/")
orders    = spark.read.parquet("s3a://proxy-aws-bucket01/tpch/sf10/orders/")

# join, aggregate, sort, and limit
top10_customers = (
    customers
      .join(orders, customers.c_custkey == orders.o_custkey)
      .groupBy(
          customers.c_custkey.alias("custkey"),
          customers.c_name.alias("name")
      )
      .agg(
          count(orders.o_orderkey).alias("order_count"),
          _max(orders.o_orderdate).alias("last_order_date")
      )
      .orderBy(desc("order_count"))
      .limit(10)
)

top10_customers.show(truncate=False)
```

![spark query](img/spark.webp)

## Integrated in a Fastapi app
Using &lt;osp⚡&gt; for download/upload interface within a fastapi python backend (using [&lt;/&gt; htmx](https://htmx.org/) for our convenience)

Then, ie. When a download link is clicked, generate a presigned link in either a dialog for the user or hidden on the page and use javascript to initiate the download.


## Presigned url
Generate a presigned url against the &lt;osp⚡&gt; endpoint and download a file, going through the same &lt;osp⚡&gt; gateway.

![presigned url download](img/presign_download.webp)

## Query from two different vendors using Presto
![presto logo](img/logo-presto-color.svg){ width=180px } 
![hive logo](img/Apache_Hive_logo.svg){ width=120px }

Create TPC-H customer and order tables using spark, on two different buckets, customer on aws and orders on ibm bucket.

```python
import os
from pyspark.sql import SparkSession

aws_access_key_id = os.environ["AWS_ACCESS_KEY_ID"]
aws_secret_access_key = os.environ["AWS_SECRET_ACCESS_KEY"]
region = "eu-west-3"

spark = (
    SparkSession.builder.appName("S3AExample")
    .config("spark.hadoop.fs.s3a.access.key", aws_access_key_id)
    .config("spark.hadoop.fs.s3a.secret.key", aws_secret_access_key)
    .config("spark.hadoop.fs.s3a.endpoint", f"http://localhost:6190")
    .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
    .config("spark.hadoop.fs.s3a.path.style.access", "true")
    .config("spark.sql.catalogImplementation", "hive")
    .config("spark.hadoop.hive.metastore.uris", "thrift://localhost:9083")
    .getOrCreate()
)

spark.sql(
    """
        CREATE EXTERNAL TABLE default.customer (
        c_custkey     BIGINT,
        c_name        STRING,
        c_address     STRING,
        c_nationkey   BIGINT,
        c_phone       STRING,
        c_acctbal     DOUBLE,
        c_mktsegment  STRING,
        c_comment     STRING
        )
        STORED AS PARQUET
        LOCATION 's3a://proxy-aws-bucket01/tpch/sf10/customer'
    """
)

spark.sql(
    """
        CREATE EXTERNAL TABLE IF NOT EXISTS default.orders (
        o_orderkey     BIGINT,
        o_custkey      BIGINT,
        o_orderstatus  STRING,
        o_totalprice   DOUBLE,
        o_orderdate    DATE,
        o_orderpriority STRING,
        o_clerk        STRING,
        o_shippriority INT,
        o_comment      STRING
        )
        STORED AS PARQUET
        LOCATION 's3a://proxy-bucket01/tpch/sf10/orders'
    """
)
spark.stop()
```

Tables
```SQL
[root@dbc8ec99fdc5 /]# presto-cli --server localhost:8080 --catalog hive --schema default
presto:default> SHOW CREATE TABLE hive.default.customer;
                             Create Table
-----------------------------------------------------------------------
 CREATE TABLE hive.default.customer (
    "c_custkey" bigint,
    "c_name" varchar,
    "c_address" varchar,
    "c_nationkey" bigint,
    "c_phone" varchar,
    "c_acctbal" double,
    "c_mktsegment" varchar,
    "c_comment" varchar
 )
 WITH (
    external_location = 's3a://proxy-aws-bucket01/tpch/sf10/customer',
    format = 'PARQUET'
 )
(1 row)

Query 20250504_175810_00013_d86su, FINISHED, 1 node
Splits: 1 total, 1 done (100.00%)
[Latency: client-side: 74ms, server-side: 59ms] [0 rows, 0B] [0 rows/s, 0B/s]

presto:default> SHOW CREATE TABLE hive.default.orders;
                          Create Table
-----------------------------------------------------------------
 CREATE TABLE hive.default.orders (
    "o_orderkey" bigint,
    "o_custkey" bigint,
    "o_orderstatus" varchar,
    "o_totalprice" double,
    "o_orderdate" date,
    "o_orderpriority" varchar,
    "o_clerk" varchar,
    "o_shippriority" integer,
    "o_comment" varchar
 )
 WITH (
    external_location = 's3a://proxy-bucket01/tpch/sf10/orders',
    format = 'PARQUET'
 )
(1 row)

Query 20250504_175812_00014_d86su, FINISHED, 1 node
Splits: 1 total, 1 done (100.00%)
[Latency: client-side: 74ms, server-side: 56ms] [0 rows, 0B] [0 rows/s, 0B/s]

presto:default>
```


Query tables using presto-cli

![presto query](img/presto_query.webp)