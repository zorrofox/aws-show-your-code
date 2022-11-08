import sys
from time import sleep
from pyspark.sql import SparkSession
spark = SparkSession.builder.appName("icebergjob").getOrCreate()

DOC_EXAMPLE_BUCKET = sys.argv[1]

print("S3 bucket name: {}".format(DOC_EXAMPLE_BUCKET))

## Create a DataFrame
data = spark.createDataFrame([
 ("100", "2015-01-01", "2015-01-01T13:51:39.340396Z"),
 ("101", "2015-01-01", "2015-01-01T12:14:58.597216Z"),
 ("102", "2015-01-01", "2015-01-01T13:51:40.417052Z"),
 ("103", "2015-01-01", "2015-01-01T13:51:40.519832Z")
],["id", "creation_date", "last_update_time"])

## Write a DataFrame as a Iceberg dataset to the S3 location
spark.sql("""CREATE TABLE IF NOT EXISTS glue_catalog.default.iceberg_table (id string,
creation_date string,
last_update_time string)
USING iceberg
location '{}/example-prefix/db/iceberg_table'""".format(DOC_EXAMPLE_BUCKET))

data.writeTo("glue_catalog.default.iceberg_table").append()

df = spark.read.format("iceberg").load("glue_catalog.default.iceberg_table")
df.show()