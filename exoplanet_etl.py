from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
from time import sleep
from dotenv import dotenv_values
from sqlalchemy import text
import pandas as pd
import psycopg2
import sqlalchemy
import os
import logging

# Load environment variables
conf = dotenv_values("C:\\Users\\Martin\\exoplanet\\exoplanet_analysis\\.env")
logging.basicConfig(filename='log_exoplanet_etl.log',
                    encoding='UTF-8',
                    level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')

# Set download directory & initiate headless browser
options = webdriver.ChromeOptions()
prefs = {"download.default_directory":"C:\\Users\\Martin\\exoplanet"}
options.add_experimental_option("prefs",prefs)
options.headless = True
try:
    logging.info('Getting CSV file')
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()),options=options)
    # Get data page, check all options, & download CSV
    driver.get("http://exoplanet.eu/catalog/all_fields/#")
    data_filter = driver.find_element(By.CSS_SELECTOR,'.filter_catalog_form')
    status_button = data_filter.find_element(By.CSS_SELECTOR,'.submit_btn_inline')
    checkbox = data_filter.find_element(By.CSS_SELECTOR,'.filter_checkbox')
    download = driver.find_element(By.XPATH,'/html/body/h1/span/a[2]')
    (ActionChains(driver).move_to_element(data_filter)
                        .click(status_button)
                        .click(checkbox)
                        .click(download)
                        .perform())
except Exception as e:
    logging.exception(f"Error occurred while generating web driver")
    raise

    
# Check for file every 60 seconds until it is found or we waited 5 minutes
tries = 5

while not os.path.exists(conf['DATA_FILE']) and tries > 0:
    sleep(60)
    tries -= 1


if tries == 0:
    logging.info('The file took longer than 5 minutes to download.') 

# Get the latest updates & load into database
exoplanet_data = pd.read_csv(conf['DATA_FILE'])
exoplanet_data = exoplanet_data.rename(columns={'# name':'planet_name'})
exoplanet_data['updated'] = (pd.to_datetime(exoplanet_data['updated'])
                               .apply(lambda row: row.date()))
last_updated = exoplanet_data['updated'].max()
inserts = exoplanet_data[exoplanet_data['updated'] == last_updated]
engine = sqlalchemy.create_engine(f"postgresql+psycopg2://{conf['USER']}"
                                + f":{conf['PASS']}@{conf['HOST']}" 
                                + f":{conf['PORT']}/{conf['DB_NAME']}")
# Add new data if it is newer than the last updated date
latest_date = pd.read_sql("""SELECT MAX(updated::DATE) AS updated 
                             FROM exoplanet.exoplanet_data""",
                          engine)

if inserts['updated'].max() >  latest_date['updated'].max():
    try:
        with engine.begin() as conn:
            inserts.to_sql('exoplanet_data',
                            conn,
                            schema='exoplanet',
                            if_exists='append',
                            index=False,
                            chunksize=1000,
                            method='multi')
            logging.info('New data has been inserted')
            # Update dim and fact tables
            conn.execute(text("SELECT exoplanet.update_dim_planet();"))
            conn.execute(text("SELECT exoplanet.update_dim_star();"))
            conn.execute(text("SELECT exoplanet.insert_fact_planet_star();"))
            logging.info('Dimension and fact tables have been updated')
            
    except Exception as err:
        logging.exception("Error occurred while inserting to db")
        raise
        
        
# Delete CSV from folder
try:
    os.remove(conf['DATA_FILE'])
    logging.info("CSV file has been removed")
except:
    logging.exception("Error occurred while trying to remove CSV file")

logging.info('Process has completed successfully!')



driver.close()
driver.quit()