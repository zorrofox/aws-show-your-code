import sys
from time import sleep
from pyspark.sql import SparkSession
spark = SparkSession.builder.appName("threadsleep").getOrCreate()
def sleep_for_x_seconds(x):sleep(x*20)
sc=spark.sparkContext
sc.parallelize(range(1,6), 5).foreach(sleep_for_x_seconds)
spark.stop()
