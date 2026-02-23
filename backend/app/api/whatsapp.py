"""
WhatsApp API 路由
"""

from fastapi import APIRouter, HTTPException, Depends, Header, Request
from typing import Optional
import json

from ..services.whatsapp_service import whatsapp_service

router = APIRouter()


@router.post("/webhook")
async def receive_webhook(
    request: Request,
    x_hub_signature_256: Optional[str] = Header(None, alias="X-Hub-Signature-256")
):
    """
    接收WhatsApp Webhook
    
    WhatsApp会发送消息到这个端点
    """
    try:
        # 获取原始数据
        body = await request.body()
        webhook_data = json.loads(body.decode('utf-8'))
        
        # 验证签名（实际生产环境需要实现）
        # if not verify_signature(x_hub_signature_256, body):
        #     raise HTTPException(status_code=401, detail="Invalid signature")
        
        # 处理Webhook
        result = await whatsapp_service.receive_webhook(webhook_data)
        
        # 如果是验证请求，返回挑战值
        if "hub.challenge" in webhook_data:
            return int(webhook_data["hub.challenge"])
        
        return {
            "success": True,
            "message": "Webhook processed successfully",
            "processed_messages": result.get("processed_count", 0)
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Webhook processing failed: {str(e)}")


@router.post("/send")
async def send_message(
    to: str,
    message: str,
    message_type: str = "text"
):
    """
    发送WhatsApp消息
    
    Args:
        to: 接收者电话号码
        message: 消息内容
        message_type: 消息类型
    """
    try:
        result = await whatsapp_service.send_message(to, message, message_type)
        
        if not result.get("success"):
            raise HTTPException(status_code=400, detail=result.get("error", "Send failed"))
        
        return {
            "success": True,
            "message_id": result.get("message_id"),
            "status": result.get("status"),
            "recipient": to,
            "timestamp": result.get("timestamp")
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Message send failed: {str(e)}")


@router.get("/status/{message_id}")
async def get_message_status(message_id: str):
    """
    获取消息状态
    
    Args:
        message_id: 消息ID
    """
    try:
        result = await whatsapp_service.get_message_status(message_id)
        
        if not result.get("success"):
            raise HTTPException(status_code=404, detail="Message not found")
        
        return {
            "message_id": message_id,
            "status": result.get("status"),
            "timestamp": result.get("timestamp")
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to get message status: {str(e)}")


@router.post("/send-template")
async def send_template_message(
    to: str,
    template_name: str,
    language_code: str = "zh_CN"
):
    """
    发送模板消息
    
    Args:
        to: 接收者
        template_name: 模板名称
        language_code: 语言代码
    """
    try:
        result = await whatsapp_service.send_template_message(to, template_name, language_code)
        
        if not result.get("success"):
            raise HTTPException(status_code=400, detail="Template send failed")
        
        return {
            "success": True,
            "message_id": result.get("message_id"),
            "template": template_name,
            "recipient": to,
            "status": result.get("status")
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Template send failed: {str(e)}")


@router.get("/health")
async def health_check():
    """WhatsApp服务健康检查"""
    try:
        status = whatsapp_service.get_health_status()
        
        return {
            "service": "whatsapp",
            "status": "healthy",
            "details": status,
            "timestamp": status.get("timestamp")
        }
        
    except Exception as e:
        return {
            "service": "whatsapp",
            "status": "unhealthy",
            "error": str(e),
            "timestamp": datetime.now().isoformat()
        }


@router.get("/config")
async def get_config():
    """获取WhatsApp配置信息（仅开发环境）"""
    from ..core.config import settings
    
    config = {
        "simulation_mode": whatsapp_service.simulation_mode,
        "base_url": whatsapp_service.base_url if not whatsapp_service.simulation_mode else None,
        "has_token": bool(settings.WHATSAPP_API_TOKEN),
        "has_phone_number": bool(settings.WHATSAPP_PHONE_NUMBER_ID)
    }
    
    return config