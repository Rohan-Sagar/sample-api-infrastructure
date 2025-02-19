import logging
import time
from typing import Dict

import uvicorn
from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)

app = FastAPI(title="Simple API infrastrucure project")

request_count = 0
start_time = time.time()


class HealthCheck(BaseModel):
    status: str
    uptime: float
    request_count: int


@app.get("/health", response_model=HealthCheck)
async def health_check() -> HealthCheck:
    global request_count
    request_count += 1
    logger.info("Request made to /health endpoint")
    return HealthCheck(
        status="OK", uptime=time.time() - start_time, request_count=request_count
    )


@app.get("/metrics")
async def metrics() -> Dict:
    global request_count
    request_count += 1
    logger.info("Request made to /metrics endpoint")
    return {"total_requests": request_count, "uptime_seconds": time.time() - start_time}


@app.get("/version")
def version() -> Dict:
    return {"version": "2.0"}


@app.get("/")
async def read_root() -> Dict:
    global request_count
    request_count += 1
    logger.info("Request made to root endpoint")
    return {"message": "API running"}


def main() -> None:
    try:
        uvicorn.run(
            "main:app",
            host="0.0.0.0",  # NOTE: Can accept connection from any network interface -> important for containerization
            port=8000,
            reload=False,  # NOTE: False because reload is not needed in container
        )
    except Exception as e:
        logger.error(f"Error starting application: {e}")
        raise


if __name__ == "__main__":
    main()
