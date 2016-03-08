#!/bin/bash

EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
PVT_IP=`curl -s http://169.254.169.254/latest/meta-data/local-ipv4`

echo Stream Name: $1
echo Checkpoint DynamoDb Table: $2
echo Elasticsearch Host: $3
echo VPC Log Group Name: $4
echo CloudTrail Log Group Name: $5
echo CloudConfig Log Group Name: $6
echo =====================================
echo Region: $EC2_REGION

sed -i "s/{{aws-region}}/$EC2_REGION/g" ./ls-aws-cwl.conf
sed -i "s/{{stream-name}}/$1/g" ./ls-aws-cwl.conf
sed -i "s/{{checkpoint-ddb}}/$2/g" ./ls-aws-cwl.conf
sed -i "s/{{es-host}}/$3/g" ./ls-aws-cwl.conf
sed -i "s/{{vpc-log-group}}/$4/g" ./ls-aws-cwl.conf
sed -i "s/{{ct-log-group}}/$5/g" ./ls-aws-cwl.conf
sed -i "s/{{config-log-group}}/$6/g" ./ls-aws-cwl.conf

./bin/logstash -f ./ls-aws-cwl.conf