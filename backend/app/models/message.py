"""
消息数据模型
"""

from sqlalchemy import Column, Integer, String, DateTime, Enum, JSON, Text, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
import enum

from ..core.database import Base


class ChannelType(enum.Enum):
    """消息渠道类型"""
    WHATSAPP = "whatsapp"
    INSTAGRAM = "instagram"
    EMAIL = "email"
    REVIEW = "review"


class MessageStatus(enum.Enum):
    """消息状态"""
    UNREAD = "unread"
    READ = "read"
    REPLIED = "replied"
    FORWARDED = "forwarded"
    ARCHIVED = "archived"


class MessagePriority(enum.Enum):
    """消息优先级"""
    NORMAL = "normal"
    URGENT = "urgent"
    CRITICAL = "critical"


class Message(Base):
    """消息模型"""
    
    __tablename__ = "messages"
    
    id = Column(Integer, primary_key=True, index=True)
    external_id = Column(String, unique=True, index=True, nullable=True)
    
    # 消息基本信息
    channel = Column(Enum(ChannelType), nullable=False)
    sender = Column(String, nullable=False)
    recipient = Column(String, nullable=True)
    content = Column(Text, nullable=False)
    
    # 消息元数据
    status = Column(Enum(MessageStatus), default=MessageStatus.UNREAD)
    priority = Column(Enum(MessagePriority), default=MessagePriority.NORMAL)
    metadata = Column(JSON, default=dict)
    
    # 时间戳
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    received_at = Column(DateTime, default=datetime.utcnow)
    
    # 关联关系
    customer_id = Column(Integer, ForeignKey("customers.id"), nullable=True)
    customer = relationship("Customer", back_populates="messages")
    
    response_id = Column(Integer, ForeignKey("responses.id"), nullable=True)
    response = relationship("Response", back_populates="message")
    
    def __repr__(self):
        return f"<Message(id={self.id}, channel={self.channel}, sender={self.sender[:20]})>"