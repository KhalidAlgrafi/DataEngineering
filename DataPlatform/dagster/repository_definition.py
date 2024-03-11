from dagster import repository
from pipelines.data_pipeline import refresh_data_pipeline

@repository
def repository_definition():
    return [refresh_data_pipeline]
