from dagster import job, op
from dagster_dbt import dbt_cli_resource

@op(required_resource_keys={"dbt"})
def refresh_dim_customers(context):
    # Assumes every run refreshes the entire dim_customers model
    result = context.resources.dbt.run(models=["dim_customers"])
    context.log.info(f"Dbt run result: {result}")

@op(required_resource_keys={"dbt"})  
def refresh_dim_products(context):
    # Assumes every run refreshes the entire dim_products model
    result = context.resources.dbt.run(models=["dim_products"])
    context.log.info(f"Dbt run result: {result}")

@job(resource_defs={"dbt": dbt_cli_resource.configured({"project_dir": r"C:\PyEnv\Dev\Projects\DataEngineering\DataPlatform\dbtDataPlatform", "profiles_dir": r"C:\Users\SHARK\.dbt"})})
def refresh_data_pipeline():
    refresh_dim_customers()
    refresh_dim_products()
