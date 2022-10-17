#SECRET!!!! DONT PUSH TO REPO
db_username="joseph"
db_password="ting1234"
app_api_key="sdsare43759083321kljdaselojkl3nkj12jk12780ewa"


region="us-east-1"
environment="prod"

custom_domain="www.maitriwind.com"
lambda_runtime="python3.8"
instance_type="t2.micro" #currently this variable is unused

#if you remake this stack, remember to update this
#secret manager name. because ther is a 7 day delay before 
#it is detroyed, so you will get a still exists error.
secret_manager_name="db_secrets98"

#DB parameters
db_storage_min=10
db_storage_max=20
db_instance_class="db.t2.micro"

db_engine="MySQL"
db_port=3306
log_retention=7
db_engine_version="8.0.30"
db_name="mydb"


#vpc
vpc_name_tag=["vpc", "pub-subnet1", "pub_subnet2", "priv_subnet1", "priv_subnet2", "priv_subnet3", "priv_subnet4"]
cidr_blocks= {
    "vpc" = "10.0.0.0/16"
    "pub_sn1"= "10.0.10.0/24"
    "pub_sn2"= "10.0.20.0/24"
    "priv_sn1" = "10.0.30.0/24"
    "priv_sn2" = "10.0.40.0/24"
    "priv_sn3" = "10.0.50.0/24"
    "priv_sn4" = "10.0.60.0/24"
}



