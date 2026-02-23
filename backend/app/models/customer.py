"""
客户数据模型
"""

from sqlalchemy import Column, Integer, String, DateTime, JSON, Text
from sqlalchemy.orm import relationship
from datetime import datetime

from ..core.database import Base


class Customer(Base):
    """客户模型"""
    
    __tablename__ = "customers"
    
    id = Column(Integer, primary_key=True, index=True)
    
    # 客户基本信息
    name = Column(String, nullable=True)
    phone = Column(String, unique=True, index=True, nullable=True)
    email = Column(String, unique=True, index=True, nullable=True)
    instagram_handle = Column(String, unique=True, index=True, nullable=True)
    
    # 客户元数据
    metadata = Column(JSON, default=dict)
    preferences = Column(JSON, default=dict)
    tags = Column(JSON, default=list)
    
    # 统计信息
    message_count = Column(Integer, default=0)
    last_message_at = Column(DateTime, nullable=True)
    
    # 时间戳
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # 关联关系
    messages = relationship("Message", back_populates="customer")
    
    def __repr__(self):
        return f"<Customer(id={self.id}, name={self.name})>"