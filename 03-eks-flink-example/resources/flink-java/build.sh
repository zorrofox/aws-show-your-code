#! /bin/bash

mvn clean package -Dflink.version=1.16.0
cp target/aws-kinesis-analytics-java-apps-1.0.jar ../
