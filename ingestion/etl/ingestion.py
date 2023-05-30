"""
Functions that handle ingesting data from the Exoplanet Catalog
@Author: Martin Arroyo
"""
import sys
from loguru import logger
from time import sleep
from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager



def get_driver(download_path):
    """Creates and returns a Selenium driver based on our required config"""
    # Set download directory & initiate headless browser
    options = webdriver.ChromeOptions()
    prefs = {"download.default_directory": download_path}
    options.add_experimental_option("prefs", prefs)
    options.headless = True
    driver = webdriver.Chrome(
        service=Service(ChromeDriverManager().install()), options=options
    )
    return driver


def get_remote_driver(download_path):
    """Gets a remote Selenium driver (used for Docker)"""
    # Set download directory & initiate headless browser
    options = webdriver.ChromeOptions()
    prefs = {"download.default_directory": download_path}
    options.add_experimental_option("prefs", prefs)
    options.headless = True
    driver = webdriver.Remote(
        command_executor="http://localhost:4444",
        options=options
    )
    return driver


def download_data(driver, url):
    """Filters the Exoplanet data and downloads it to our preferred location"""
    try:
        logger.info("Getting CSV file")
        # Get data page, check all options, & download CSV
        driver.get(url)
        data_filter = driver.find_element(By.CSS_SELECTOR, ".filter_catalog_form")
        status_button = data_filter.find_element(By.CSS_SELECTOR, ".submit_btn_inline")
        checkbox = data_filter.find_element(By.CSS_SELECTOR, ".filter_checkbox")
        download = driver.find_element(By.XPATH, "/html/body/h1/span/a[2]")
        (
            ActionChains(driver)
            .move_to_element(data_filter)
            .click(status_button)
            .click(checkbox)
            .click(download)
            .perform()
        )
        # Wait a few seconds before closing
        logger.info("File has been downloaded")
        sleep(3)
        driver.close()
        driver.quit()
    except Exception as e:
        logger.exception("Error occurred while generating web driver")
        raise
        

def ingest(download_path, url):
    """Ingests data from the Extrasolar Planet Encyclopaedia"""
    # Get the driver
    driver = get_driver(download_path)
    # Download the data
    download_data(driver, url)
