"""
意图分类服务
"""

from typing import Dict, List, Optional
import re


class IntentClassifier:
    """意图分类器"""
    
    def __init__(self):
        # 意图分类规则
        self.rules: Dict[str, List[str]] = {
            "business_hours": [
                "营业时间", "几点开门", "几点关门", "什么时候营业", 
                "open", "close", "hours", "time"
            ],
            "menu_inquiry": [
                "菜单", "价格", "多少钱", "有什么菜", "推荐",
                "menu", "price", "cost", "dish", "recommend"
            ],
            "reservation": [
                "预订", "预约", "订位", "订桌", "预定",
                "reservation", "book", "appointment", "table"
            ],
            "complaint": [
                "投诉", "不满意", "退款", "差评", "问题", "抱怨",
                "complaint", "refund", "problem", "issue", "bad"
            ],
            "location": [
                "地址", "在哪里", "怎么去", "位置", "地图",
                "address", "location", "where", "map", "directions"
            ],
            "delivery": [
                "外卖", "配送", "送货", "送到", "取货",
                "delivery", "takeout", "pickup", "ship"
            ],
            "contact": [
                "电话", "联系方式", "联系", "客服",
                "phone", "contact", "call", "support"
            ],
            "pricing": [
                "价格", "费用", "收费", "多少钱",
                "price", "cost", "fee", "charge", "how much"
            ],
            "availability": [
                "有空", "有位置", "能订", "可以",
                "available", "free", "vacant", "can"
            ],
            "thanks": [
                "谢谢", "感谢", "好评", "很好",
                "thanks", "thank", "good", "great", "awesome"
            ]
        }
        
        # 意图优先级
        self.priority = {
            "complaint": 10,
            "reservation": 8,
            "delivery": 6,
            "business_hours": 5,
            "menu_inquiry": 5,
            "location": 4,
            "contact": 3,
            "pricing": 3,
            "availability": 2,
            "thanks": 1,
            "general_inquiry": 0
        }
    
    def classify(self, text: str, language: str = "zh") -> Dict[str, any]:
        """
        分类消息意图
        
        Args:
            text: 消息文本
            language: 语言代码
            
        Returns:
            意图分类结果
        """
        text_lower = text.lower().strip()
        
        # 检测语言（简单实现）
        if language == "auto":
            language = self._detect_language(text)
        
        # 匹配所有意图
        matched_intents = []
        for intent, keywords in self.rules.items():
            for keyword in keywords:
                if keyword.lower() in text_lower:
                    matched_intents.append(intent)
                    break
        
        # 如果没有匹配到意图，返回通用咨询
        if not matched_intents:
            return {
                "intent": "general_inquiry",
                "confidence": 0.3,
                "language": language,
                "matched_keywords": []
            }
        
        # 选择优先级最高的意图
        best_intent = max(
            matched_intents, 
            key=lambda x: self.priority.get(x, 0)
        )
        
        # 计算置信度（简单实现）
        confidence = min(0.3 + len(matched_intents) * 0.1, 0.9)
        
        return {
            "intent": best_intent,
            "confidence": confidence,
            "language": language,
            "matched_keywords": matched_intents
        }
    
    def _detect_language(self, text: str) -> str:
        """检测语言"""
        # 简单的中英文检测
        chinese_chars = len(re.findall(r'[\u4e00-\u9fff]', text))
        english_chars = len(re.findall(r'[a-zA-Z]', text))
        
        if chinese_chars > english_chars:
            return "zh"
        elif english_chars > chinese_chars:
            return "en"
        else:
            return "zh"  # 默认中文
    
    def get_intent_description(self, intent: str) -> str:
        """获取意图描述"""
        descriptions = {
            "business_hours": "营业时间咨询",
            "menu_inquiry": "菜单和价格咨询",
            "reservation": "预订和预约",
            "complaint": "投诉和问题反馈",
            "location": "地址和位置咨询",
            "delivery": "外卖和配送咨询",
            "contact": "联系方式咨询",
            "pricing": "价格和费用咨询",
            "availability": "可用性咨询",
            "thanks": "感谢和好评",
            "general_inquiry": "一般咨询"
        }
        return descriptions.get(intent, "未知意图")