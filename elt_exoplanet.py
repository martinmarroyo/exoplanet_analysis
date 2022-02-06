from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from time import sleep
from dotenv import dotenv_values
import pandas as pd
import psycopg2
import sqlalchemy
import os

# Load environment variables
conf = dotenv_values(".env")

# Set download directory & initiate headless browser
options = webdriver.ChromeOptions()
prefs = {"download.default_directory":conf['DWNLD_DIR']}
options.add_experimental_option("prefs",prefs)
options.headless = True

driver = webdriver.Chrome(executable_path=conf['DRIVER'],options=options)

# Get data page, check all options, & download CSV
driver.get("http://exoplanet.eu/catalog/all_fields/#")

data_filter = driver.find_element_by_css_selector('.filter_catalog_form')
status_button = data_filter.find_element_by_css_selector('.submit_btn_inline')
checkbox = data_filter.find_element_by_css_selector('.filter_checkbox')
download = driver.find_element_by_link_text('CSV')
(ActionChains(driver).move_to_element(data_filter)
                     .click(status_button)
                     .click(checkbox)
                     .click(download)
                     .perform())

# Check for file every 60 seconds until it is found or we waited 5 minutes
tries = 5

while not os.path.exists(conf['DATA_FILE']) and tries > 0:
    sleep(60)
    tries -= 1

# TODO: Implement proper logging
if tries == 0:
    print('The file took longer than 5 minutes to download.') 
    print('Check log and try again.')


# Get the latest updates & load into database
exoplanet_data = pd.read_csv(conf['DATA_FILE'])
exoplanet_data['updated'] = (pd.to_datetime(exoplanet_data['updated'])
                               .apply(lambda row: row.date()))
last_updated = exoplanet_data['updated'].max()
inserts = exoplanet_data[exoplanet_data['updated'] == last_updated]

db_connection = psycopg2.connect(dbname=conf['DB_NAME']
                                ,user=conf['USER']
                                ,password=conf['PASS']
                                ,host=conf['HOST']
                                ,port=conf['PORT'])

engine = sqlalchemy.create_engine(f"postgresql://{conf['USER']}"
                                + f":{conf['PASS']}@{conf['HOST']}" 
                                + f":{conf['PORT']}/{conf['DB_NAME']}")

# Add new data if it is newer than the last updated date
latest_date = pd.read_sql("""SELECT MAX(updated::DATE) 
                                    AS updated 
                             FROM exoplanets"""
                          ,db_connection)

if inserts['updated'].max() >  latest_date['updated'].max():
    inserts.to_sql('exoplanets'
                   ,engine
                   ,if_exists='append'
                   ,chunksize=1000
                   ,method='multi')

# Delete CSV from folder
os.remove(conf['DATA_FILE'])

driver.close()
driver.quit()