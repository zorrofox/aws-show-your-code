import sys
from time import sleep
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *


spark = SparkSession.builder.appName("deltajob").enableHiveSupport().getOrCreate()

DOC_EXAMPLE_BUCKET = sys.argv[1]

print("S3 bucket name: {}".format(DOC_EXAMPLE_BUCKET))

## Create a DataFrame
data = spark.createDataFrame([
 ("800", "2015-01-01", "2015-01-01T13:51:39.340396Z"),
 ("801", "2015-01-01", "2015-01-01T12:14:58.597216Z"),
 ("802", "2015-01-01", "2015-01-01T13:51:40.417052Z"),
 ("803", "2015-01-01", "2015-01-01T13:51:40.519832Z")
],["id", "creation_date", "last_update_time"])

data.withColumn("checksum",md5(concat(col("id"),col("creation_date"),col("last_update_time"))))\
 .write.format("delta")\
 .mode("overwrite")\
 .save('{}/example-prefix/db/delta_table'.format(DOC_EXAMPLE_BUCKET))

## Write a DataFrame as a DELTA dataset to the S3 location
spark.sql("CREATE DATABASE delta_db LOCATION '{}/example-prefix/db/'".format(DOC_EXAMPLE_BUCKET)) # work around for empty path issue
spark.sql("CREATE TABLE IF NOT EXISTS delta_db.delta_table USING DELTA location '{}/example-prefix/db/delta_table'".format(DOC_EXAMPLE_BUCKET))
spark.sql("GENERATE symlink_format_manifest FOR TABLE delta_db.delta_table")
spark.sql("ALTER TABLE delta_db.delta_table SET TBLPROPERTIES(delta.compatibility.symlinkFormatManifest.enabled=true)")

# Create a queriable table in Athena
spark.sql("DROP TABLE delta_db.delta_table")
spark.sql("""
CREATE EXTERNAL TABLE IF NOT EXISTS delta_db.delta_table (
  id string,
  creation_date string,
  last_update_time string,
  checksum string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.SymlinkTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION '{}/example-prefix/db/delta_table/_symlink_format_manifest/'""".format(DOC_EXAMPLE_BUCKET))

df = spark.read.format("delta").load("{}/example-prefix/db/delta_table".format(DOC_EXAMPLE_BUCKET))
df.show()