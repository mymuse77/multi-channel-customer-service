"""
健康检查API
"""

from fastapi import APIRouter

router = APIRouter()


@router.get("/")
async def health():
    """健康检查"""
    return {"status": "healthy", "service": "customer-service-api"}


@router.get("/ready")
async def readiness():
    """就绪检查"""
    return {"status": "ready"}


@router.get("/live")
async def liveness():
    """存活检查"""
    return {"status": "alive"}