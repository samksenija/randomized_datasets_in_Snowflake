import snowflake.connector
import os

from dotenv import load_dotenv

load_dotenv() 

conn = snowflake.connector.connect(
    user=os.getenv("user"),
    password=os.getenv("password"),
    account=os.getenv("account"),
    warehouse=os.getenv("warehouse"),
    database=os.getenv("database"),
    schema=os.getenv("schema")
)