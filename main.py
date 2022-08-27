"""
Scraping data from the Extrasolar Planets Encyclopaedia (http:://www.exoplanet.eu)
@Author: Martin Arroyo
"""
import etl.ingestion as ing
import etl.loading as ld
import etl.utility as util
import sys
import logging
import yaml
from yaml.loader import SafeLoader

logging.basicConfig(
        handlers=[
            logging.FileHandler(r"etl/logs/exoplanet.data"),
            logging.StreamHandler(sys.stdout)
        ],
        encoding="UTF-8",
        level=logging.INFO,
        format="%(asctime)s - %(levelname)s - %(message)s"
    )
with open(r"config.yml", "r", encoding="utf-8", errors="ignore") as file:
    conf = yaml.load(file, Loader=SafeLoader)
    
def main():
    # Ingest the data
    logging.info("Ingesting the raw data...")
    ing.ingest(conf["DOWNLOAD_DIR"], conf["EXOPLANET_SITE"])
    # Load if we have successfully gotten the file
    if util.check_for_file(conf["DATA_PATH"]):
        logging.info("Ingestion complete. Now loading raw data to database...")
        ld.load(conf, conf["DATA_PATH"])
        util.delete_file(conf["DATA_PATH"])
        logging.info("Process has completed successfully!")
        return 0
    return 1


if __name__ == '__main__':
    main()    