import logging
import os
from fastapi.logger import logger as fastapi_logger

def setup_logger():
    os.system("cls" if os.name == "nt" else "clear")
    logger = logging.getLogger(__name__)

    if "gunicorn" in os.environ.get("SERVER_SOFTWARE", ""):
        gunicorn_error_logger = logger("gunicorn.error")
        gunicorn_logger = logger("gunicorn")

        root_logger = logger()
        fastapi_logger.setLevel(gunicorn_logger.level)
        fastapi_logger.handlers = gunicorn_error_logger.handlers
        root_logger.setLevel(gunicorn_logger.level)

        uvicorn_logger = logger("uvicorn.access")
        uvicorn_logger.handlers = gunicorn_error_logger.handlers
    else:
        # https://github.com/tiangolo/fastapi/issues/2019
        LOG_FORMAT2 = (
            "[%(threadName)s] %(name)s - %(levelname)s - %(message)s | %(filename)s:%(lineno)d"
        )
        logging.basicConfig(level=logging.INFO, format=LOG_FORMAT2)