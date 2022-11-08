import sys
from time import sleep
from pyspark.sql import SparkSession
spark = SparkSession.builder.appName("hudijob").getOrCreate()

DOC_EXAMPLE_BUCKET = sys.argv[1]
REGION = sys.argv[2]

hudi_table_name = 'hudi_table'
hudi_table_type = 'COPY_ON_WRITE'

print("S3 bucket name: {}".format(DOC_EXAMPLE_BUCKET))

## Create a DataFrame
data = spark.createDataFrame([
 ("900", "2015-01-01", "2015-01-01T13:51:39.340396Z"),
 ("901", "2015-01-01", "2015-01-01T12:14:58.597216Z"),
 ("902", "2015-01-01", "2015-01-01T13:51:40.417052Z"),
 ("903", "2015-01-01", "2015-01-01T13:51:40.519832Z")
],["id", "creation_date", "last_update_time"])

TABLE_LOCATION="{}/example-prefix/db/hudi_table".format(DOC_EXAMPLE_BUCKET)
hudiOptions = {
    "hoodie.table.name": hudi_table_name,
    "hoodie.datasource.write.table.type": hudi_table_type, # COW or MOR
    "hoodie.datasource.write.recordkey.field": "id,checksum", # a business key that represents SCD 
    "hoodie.datasource.hive_sync.support_timestamp": "true",
    "hoodie.datasource.write.precombine.field": "ts",
    "hoodie.datasource.hive_sync.table": hudi_table_name, # catalog table name
    "hoodie.datasource.hive_sync.database": "default", # catalog database name
    "hoodie.datasource.hive_sync.enable": "true", # enable metadata sync on the Glue catalog
    "hoodie.datasource.hive_sync.mode":"hms", # sync to Glue catalog
    # DynamoDB based locking mechanisms for concurrency control
    "hoodie.write.concurrency.mode":"optimistic_concurrency_control", #default is SINGLE_WRITER
    "hoodie.cleaner.policy.failed.writes":"LAZY", #Hudi will delete any files written by failed writes to re-claim space
    "hoodie.write.lock.provider":"org.apache.hudi.aws.transaction.lock.DynamoDBBasedLockProvider",
    "hoodie.write.lock.dynamodb.table":"myHudiLockTable",
    "hoodie.write.lock.dynamodb.partition_key":"tablename",
    "hoodie.write.lock.dynamodb.region": REGION,
    "hoodie.write.lock.dynamodb.endpoint_url": "dynamodb.{}.amazonaws.com.cn".format(REGION)
}

data.write.format("org.apache.hudi")\
          .option('hoodie.datasource.write.operation', 'insert')\
          .options(**hudiOptions)\
          .mode("overwrite")\
          .save(TABLE_LOCATION)

df = spark.read.format("org.apache.hudi").load(TABLE_LOCATION)
df.show()