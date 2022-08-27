"""A collection of functions that handle loading Exoplanet data into the database"""
import sqlalchemy as sql
import pandas as pd
import logging
import sys

logging.basicConfig(
    handlers=[
        logging.FileHandler(r"etl/logs/exoplanet.log"),
        logging.StreamHandler(sys.stdout),
    ],
    encoding="UTF-8",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

# Get the latest updates & load into database
# Get data from path into dataframe
def load_raw_data(path:str):
    """Loads the data from the given path into a DataFrame"""
    exoplanet_data = pd.read_csv(path)
    exoplanet_data = exoplanet_data.rename(columns={"# name": "planet_name"})
    exoplanet_data["updated"] = pd.to_datetime(exoplanet_data["updated"]).apply(
        lambda row: row.date()
    )
    return exoplanet_data


def get_engine(config:dict):
    """Creates a SQLAlchemy engine based on the provided config"""
    engine = sql.create_engine(
        f"{config['DIALECT']}+{config['DRIVER']}://{config['USER']}"
        + f":{config['PASS']}@{config['HOST']}"
        + f":{config['PORT']}/{config['DB_NAME']}"
    )
    return engine


def check_if_update(engine, data:pd.DataFrame):
    """Checks the database to see if the raw data has new records or not"""
    query = "SELECT MAX(updated) AS upated FROM exoplanet.raw_exoplanet_data"
    latest_in_db = pd.read_sql(query, engine)["updated"]
    latest_in_raw = data["updated"].max()
    return latest_in_raw > latest_in_db


def write_to_db(engine, data:pd.DataFrame):
    """Writes data to the database using the given engine"""
    # Insert data into exoplanet.exoplanet_data table 
    has_update = check_if_update(engine, data)
    if has_update:
        try:
            with engine.begin() as conn:
                data.to_sql(
                    "raw_exoplanet_data",
                    conn,
                    schema="exoplanet",
                    if_exists="replace",
                    index=False,
                    chunksize=1000,
                    method="multi",
                )
                logging.info("New data has been inserted")
                # Update dim and fact tables, refresh views
                conn.execute(sql.text("SELECT exoplanet.update_dim_planet();"))
                conn.execute(sql.text("SELECT exoplanet.update_dim_star();"))
                conn.execute(sql.text("SELECT exoplanet.insert_fact_planet_star();"))
                conn.execute(
                    sql.text("REFRESH MATERIALIZED VIEW exoplanet.vw_current_star_detail;")
                )
                conn.execute(
                    sql.text("REFRESH MATERIALIZED VIEW exoplanet.vw_current_exoplanet_detail;")
                )
                conn.execute(
                    sql.text("REFRESH MATERIALIZED VIEW exoplanet.vw_exoplanet_catalog_data;")
                )
                logging.info("Dimension and fact tables have been updated")
                return 0
        except Exception as err:
            logging.exception("Error occurred while inserting to db")
            raise
    logging.info("No new records found in raw data")
    return 0
    

def load(config:dict, path:str):
    """Loads ingested raw data into the database based on the provided configuration"""
    # Get raw data
    data = load_raw_data(path)
    # Get an engine
    engine = get_engine(config)
    # Write the data to the database
    insert = write_to_db(engine, data)
    return insert
