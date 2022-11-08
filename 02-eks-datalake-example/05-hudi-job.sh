#! /bin/bash

export AWS_REGION=cn-northwest-1
export CLUSTER_NAME=eks-emr-example
export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"

export S3blogbucket=s3://emr-eks-spark-${AWS_REGION}-${AWS_ACCOUNT_ID}

# aws s3 mb $S3blogbucket --region $AWS_REGION
aws s3 cp resources/hudi.py \
  ${S3blogbucket}/eks-emr-spark/hudi.py
# aws s3 cp resources/spark_driver_podtemplate.yaml \
#   ${S3blogbucket}/eks-emr-spark/spark_driver_podtemplate.yaml
# aws s3 cp resources/spark_executor_podtemplate.yaml \
#   ${S3blogbucket}/eks-emr-spark/spark_executor_podtemplate.yaml


export VIRTUAL_CLUSTER_ID=$(aws emr-containers list-virtual-clusters \
	--query "virtualClusters[?state=='RUNNING'].id" \
	--region $AWS_REGION \
	--output text)

export EMR_ROLE_ARN=$(aws iam get-role \
  --role-name EMRContainers-JobExecutionRole \
  --query Role.Arn \
  --region $AWS_REGION  \
  --output text)

aws emr-containers start-job-run \
--virtual-cluster-id $VIRTUAL_CLUSTER_ID \
--name spark-hudi-eks-emr \
--execution-role-arn $EMR_ROLE_ARN \
--release-label emr-6.8.0-latest \
--region $AWS_REGION \
--job-driver '{
    "sparkSubmitJobDriver": {
        "entryPoint": "'${S3blogbucket}'/eks-emr-spark/hudi.py",
        "entryPointArguments": ["'${S3blogbucket}'", "'${AWS_REGION}'"],
        "sparkSubmitParameters": "--jars local:///usr/lib/hudi/hudi-spark-bundle.jar --conf spark.executor.instances=6 --conf spark.executor.memory=1G --conf spark.executor.cores=1 --conf spark.driver.cores=2"
        }
    }' \
--configuration-overrides '{
    "applicationConfiguration": [
      {
        "classification": "spark-defaults", 
        "properties": {
          "spark.driver.memory":"1G",
          "spark.serializer": "org.apache.spark.serializer.KryoSerializer",
          "spark.hadoop.hive.metastore.client.factory.class": "com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory",
          "spark.kubernetes.driver.podTemplateFile":"'${S3blogbucket}'/eks-emr-spark/spark_driver_podtemplate.yaml", 
          "spark.kubernetes.executor.podTemplateFile":"'${S3blogbucket}'/eks-emr-spark/spark_executor_podtemplate.yaml"
         }
      }
    ], 
    "monitoringConfiguration": {
      "cloudWatchMonitoringConfiguration": {
        "logGroupName": "/emr-on-eks/emreksblog", 
        "logStreamNamePrefix": "hudi"
      }, 
      "s3MonitoringConfiguration": {
        "logUri": "'"$S3blogbucket"'/eks-emr-spark/logs/"
      }
    }
}'