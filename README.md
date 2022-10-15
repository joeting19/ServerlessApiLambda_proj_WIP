# ServerlessApiLambda_proj_WIP
serverless architecture using lambda, API gateway, rds. 

For this project, i design a serverless architecture. I have included a Document presenting a high level overview as well as some specifics regarding configuration.
I use terraform code to build an api gateway, which invokes a lambda function to interact with an RDS database. I have a second lambda function to read and delete data from the database which is older than 30 days. Also include api caching. Secrets are stored in secret manager and decrypted by the lambda function at runtime. Cloudwatch logs are collected for the different components.


Future developments: add postman to test api.
