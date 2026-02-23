"""
API路由
"""

from fastapi import APIRouter

from . import messages, customers, health, webhooks, whatsapp

api_router = APIRouter()

# 注册路由
api_router.include_router(health.router, tags=["健康检查"])
api_router.include_router(messages.router, prefix="/messages", tags=["消息管理"])
api_router.include_router(customers.router, prefix="/customers", tags=["客户管理"])
api_router.include_router(webhooks.router, prefix="/webhooks", tags=["Webhook接收"])
api_router.include_router(whatsapp.router, prefix="/whatsapp", tags=["WhatsApp集成"])