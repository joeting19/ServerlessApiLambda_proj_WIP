#this program is for creating a table in mysql and 
import json
import pymysql
import boto3
import logging
import sys
from datetime import date

logger = logging.getLogger()
logger.setLevel(logging.INFO)

#make sure these match values in tfvars file
secret_name = "db_secrets11"
region_name = "us-east-1"
db_name='mydb'


# Create a Secrets Manager client
client = boto3.client(
    service_name='secretsmanager',
    region_name=region_name
)
today=date.today()
get_secret_value_response = client.get_secret_value(
    SecretId=secret_name)


if 'SecretString' in get_secret_value_response:
    secret = get_secret_value_response['SecretString']
    # print(secret)
    decryptedkeys=json.loads(secret)  # returns the secret as dictionary  
    name=decryptedkeys['username']
    password=decryptedkeys['password']
    rds_host=decryptedkeys['host']

conn=pymysql.connect(host=rds_host, user=name, passwd=password, db=db_name, connect_timeout=20)

def lambda_handler(event, context):
    today=date.today()
    
    with conn.cursor() as cur:
        cur.execute("Delete from Apptable where DATEDIFF(%s, input_date)=0",(today))
        conn.commit()
        for row in cur:
            print(row)
    conn.commit()
    conn.close()