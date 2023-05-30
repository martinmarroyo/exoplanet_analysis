"""Utility functions to support Exoplanet ETL"""
import os
import sys
from loguru import logger
from time import sleep

def check_for_file(path:str, tries:int=5, wait_time:int=60):
    """Checks the given path to see if it exists. """
    TRIES = tries
    while not os.path.exists(path) and TRIES > 0:
        sleep(wait_time)
        TRIES -= 1
    
    if TRIES == 0:
        logger.info("The file took longer than 5 minutes to download.")
        return False
    logger.info("The file was found!")
    return True


def delete_file(path:str):
    """Deletes the file at the given path"""
    try:
        os.remove(path)
        logger.info("CSV file has been removed")
    except Exception as e:
        logger.exception("Error occurred while trying to remove CSV file")

