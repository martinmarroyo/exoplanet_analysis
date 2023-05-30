"""
Scraping data from the Extrasolar Planets Encyclopaedia (http:://www.exoplanet.eu)
@Author: Martin Arroyo
"""
from etl import ingestion as ing
from etl import loading as ld
from etl import utility as util
from loguru import logger
import sys
import yaml
from yaml.loader import SafeLoader

with open(r"config.yml", "r", encoding="utf-8", errors="ignore") as file:
    conf = yaml.load(file, Loader=SafeLoader)
    
def main():
    # Ingest the data
    logger.info("Ingesting the raw data...")
    ing.ingest(conf["DOWNLOAD_DIR"], conf["EXOPLANET_SITE"])
    # Load if we have successfully gotten the file
    if util.check_for_file(conf["DATA_PATH"]):
        logger.info("Ingestion complete. Now loading raw data to database...")
        ld.load(conf, conf["DATA_PATH"])
        util.delete_file(conf["DATA_PATH"])
        logger.info("Process has completed successfully!")
        return 0
    return 1


if __name__ == '__main__':
    main()    