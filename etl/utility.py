"""Utility functions to support Exoplanet ETL"""
import os
import sys
import logging
from time import sleep

logging.basicConfig(
    handlers=[
        logging.FileHandler(r"etl/logs/exoplanet.log"),
        logging.StreamHandler(sys.stdout)
    ],
    encoding="UTF-8",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s" 
)

def check_for_file(path:str, tries:int=5, wait_time:int=60):
    """Checks the given path to see if it exists. """
    TRIES = tries
    while not os.path.exists(path) and TRIES > 0:
        sleep(wait_time)
        TRIES -= 1
    
    if TRIES == 0:
        logging.info("The file took longer than 5 minutes to download.")
        return False
    logging.info("The file was found!")
    return True


def delete_file(path:str):
    """Deletes the file at the given path"""
    try:
        os.remove(path)
        logging.info("CSV file has been removed")
    except Exception as e:
        logging.exception("Error occurred while trying to remove CSV file")

