"""
WhatsApp Business API 集成服务
"""

import json
import logging
from typing import Dict, List, Optional, Any
from datetime import datetime
import httpx

from ..core.config import settings

logger = logging.getLogger(__name__)


class WhatsAppService:
    """WhatsApp Business API 服务"""
    
    def __init__(self):
        self.base_url = "https://graph.facebook.com/v18.0"
        self.access_token = settings.WHATSAPP_API_TOKEN
        self.phone_number_id = settings.WHATSAPP_PHONE_NUMBER_ID
        
        # 模拟模式（用于开发测试）
        self.simulation_mode = not (self.access_token and self.phone_number_id)
        
        if self.simulation_mode:
            logger.warning("WhatsApp服务运行在模拟模式（缺少API配置）")
        else:
            logger.info("WhatsApp服务已初始化")
    
    async def send_message(self, to: str, message: str, message_type: str = "text") -> Dict:
        """
        发送WhatsApp消息
        
        Args:
            to: 接收者电话号码（格式：国家代码+号码，如8613800138000）
            message: 消息内容
            message_type: 消息类型（text, template, media等）
            
        Returns:
            发送结果
        """
        if self.simulation_mode:
            logger.info(f"[模拟] 发送WhatsApp消息到 {to}: {message[:50]}...")
            return {
                "success": True,
                "message_id": f"simulated_{datetime.now().timestamp()}",
                "status": "simulated",
                "recipient": to,
                "timestamp": datetime.now().isoformat()
            }
        
        url = f"{self.base_url}/{self.phone_number_id}/messages"
        
        headers = {
            "Authorization": f"Bearer {self.access_token}",
            "Content-Type": "application/json"
        }
        
        payload = {
            "messaging_product": "whatsapp",
            "recipient_type": "individual",
            "to": to,
            "type": message_type
        }
        
        if message_type == "text":
            payload["text"] = {"body": message}
        elif message_type == "template":
            # 模板消息
            payload["template"] = {
                "name": message,  # 这里简化处理
                "language": {"code": "zh_CN"}
            }
        
        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.post(url, headers=headers, json=payload)
                response.raise_for_status()
                result = response.json()
                
                logger.info(f"WhatsApp消息发送成功: {result.get('messages', [{}])[0].get('id', 'unknown')}")
                return {
                    "success": True,
                    "message_id": result.get("messages", [{}])[0].get("id"),
                    "status": "sent",
                    "recipient": to,
                    "timestamp": datetime.now().isoformat(),
                    "raw_response": result
                }
                
        except Exception as e:
            logger.error(f"WhatsApp消息发送失败: {e}")
            return {
                "success": False,
                "error": str(e),
                "recipient": to,
                "timestamp": datetime.now().isoformat()
            }
    
    async def receive_webhook(self, webhook_data: Dict) -> Dict:
        """
        处理WhatsApp Webhook数据
        
        Args:
            webhook_data: Webhook原始数据
            
        Returns:
            处理结果
        """
        logger.info(f"收到WhatsApp Webhook数据: {json.dumps(webhook_data, ensure_ascii=False)[:200]}...")
        
        try:
            # 解析Webhook数据
            entry = webhook_data.get("entry", [{}])[0]
            changes = entry.get("changes", [{}])[0]
            value = changes.get("value", {})
            
            messages = value.get("messages", [])
            contacts = value.get("contacts", [])
            
            processed_messages = []
            
            for msg in messages:
                message_data = self._parse_message(msg)
                if message_data:
                    processed_messages.append(message_data)
            
            return {
                "success": True,
                "processed_count": len(processed_messages),
                "messages": processed_messages,
                "timestamp": datetime.now().isoformat()
            }
            
        except Exception as e:
            logger.error(f"处理WhatsApp Webhook失败: {e}")
            return {
                "success": False,
                "error": str(e),
                "timestamp": datetime.now().isoformat()
            }
    
    def _parse_message(self, message: Dict) -> Optional[Dict]:
        """解析消息数据"""
        try:
            message_type = message.get("type")
            from_number = message.get("from")
            message_id = message.get("id")
            timestamp = message.get("timestamp")
            
            content = None
            
            if message_type == "text":
                content = message.get("text", {}).get("body")
            elif message_type == "image":
                image = message.get("image", {})
                content = {
                    "type": "image",
                    "caption": image.get("caption"),
                    "id": image.get("id"),
                    "mime_type": image.get("mime_type")
                }
            elif message_type == "audio":
                audio = message.get("audio", {})
                content = {
                    "type": "audio",
                    "id": audio.get("id"),
                    "mime_type": audio.get("mime_type")
                }
            elif message_type == "document":
                doc = message.get("document", {})
                content = {
                    "type": "document",
                    "filename": doc.get("filename"),
                    "caption": doc.get("caption"),
                    "id": doc.get("id")
                }
            
            return {
                "message_id": message_id,
                "from": from_number,
                "type": message_type,
                "content": content,
                "timestamp": timestamp,
                "received_at": datetime.now().isoformat()
            }
            
        except Exception as e:
            logger.error(f"解析消息失败: {e}")
            return None
    
    async def get_message_status(self, message_id: str) -> Dict:
        """
        获取消息状态
        
        Args:
            message_id: 消息ID
            
        Returns:
            消息状态
        """
        if self.simulation_mode:
            return {
                "success": True,
                "message_id": message_id,
                "status": "delivered",
                "timestamp": datetime.now().isoformat()
            }
        
        # 实际实现需要调用WhatsApp API获取消息状态
        # 这里返回模拟数据
        return {
            "success": True,
            "message_id": message_id,
            "status": "delivered",
            "timestamp": datetime.now().isoformat()
        }
    
    async def send_template_message(self, to: str, template_name: str, 
                                   language_code: str = "zh_CN", 
                                   components: List[Dict] = None) -> Dict:
        """
        发送模板消息
        
        Args:
            to: 接收者
            template_name: 模板名称
            language_code: 语言代码
            components: 模板组件
            
        Returns:
            发送结果
        """
        if self.simulation_mode:
            logger.info(f"[模拟] 发送模板消息到 {to}: {template_name}")
            return {
                "success": True,
                "message_id": f"template_simulated_{datetime.now().timestamp()}",
                "status": "simulated",
                "template": template_name,
                "recipient": to
            }
        
        # 实际实现
        return await self.send_message(to, template_name, "template")
    
    def get_health_status(self) -> Dict:
        """获取服务健康状态"""
        return {
            "service": "whatsapp",
            "status": "healthy" if not self.simulation_mode else "simulation",
            "simulation_mode": self.simulation_mode,
            "configured": not self.simulation_mode,
            "timestamp": datetime.now().isoformat()
        }


# 创建全局实例
whatsapp_service = WhatsAppService()