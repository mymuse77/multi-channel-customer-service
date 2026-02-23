# 📱 多渠道AI客户服务平台

基于OpenClaw Use Cases开发的多渠道AI客户服务平台，为中小企业提供24/7自动化客户服务。

## 🎯 项目概述

### 核心功能
- **统一收件箱**：整合WhatsApp、Instagram、Email、Google Reviews
- **AI自动响应**：智能处理常见问题和咨询
- **人工转接**：复杂问题及时转人工处理
- **业务知识库**：企业信息和服务内容管理
- **测试模式**：安全演示和培训环境

### 目标客户
- 中小型服务企业（餐厅、诊所、美容院等）
- 电商卖家和零售商
- 自由职业者和咨询师

### 技术栈
- **后端**：Python + FastAPI + SQLAlchemy
- **前端**：Vue.js 3 + Element Plus
- **数据库**：SQLite (开发) / PostgreSQL (生产)
- **部署**：Docker + Nginx

## 🚀 快速开始

### 环境要求
- Python 3.9+
- Node.js 16+
- Docker (可选)

### 后端开发
```bash
# 进入后端目录
cd backend

# 创建虚拟环境
python -m venv venv
source venv/bin/activate  # Linux/Mac
# 或 venv\Scripts\activate  # Windows

# 安装依赖
pip install -r requirements.txt

# 运行开发服务器
uvicorn app.main:app --reload --port 8000
```

### 前端开发
```bash
# 进入前端目录
cd frontend

# 安装依赖
npm install

# 运行开发服务器
npm run dev
```

### Docker部署
```bash
# 构建和运行
docker-compose up -d

# 查看日志
docker-compose logs -f
```

## 📁 项目结构

```
multi-channel-customer-service/
├── backend/                    # 后端代码
│   ├── app/
│   │   ├── api/              # API路由
│   │   ├── core/             # 核心配置
│   │   ├── models/           # 数据模型
│   │   ├── services/         # 业务服务
│   │   └── utils/            # 工具函数
│   ├── tests/                # 测试代码
│   └── requirements.txt      # Python依赖
├── frontend/                  # 前端代码
│   ├── src/
│   │   ├── components/       # Vue组件
│   │   ├── views/           # 页面视图
│   │   ├── router/          # 路由配置
│   │   ├── store/           # 状态管理
│   │   └── api/             # API调用
│   └── package.json         # Node.js依赖
├── docs/                     # 项目文档
├── docker/                   # Docker配置
├── scripts/                  # 部署脚本
└── README.md                # 项目说明
```

## 🔧 配置说明

### 环境变量
创建 `.env` 文件：
```bash
# 应用配置
DEBUG=true
DATABASE_URL=sqlite:///./customer_service.db

# API密钥
WHATSAPP_API_TOKEN=your_whatsapp_token
INSTAGRAM_ACCESS_TOKEN=your_instagram_token
GMAIL_CLIENT_ID=your_gmail_client_id
GOOGLE_BUSINESS_API_KEY=your_google_business_key
```

### 业务配置
创建 `business_config.yaml`：
```yaml
business:
  name: "示例餐厅"
  address: "上海市浦东新区"
  phone: "+86 13800138000"
  hours: "09:00-22:00"

services:
  - name: "午餐套餐"
    price: "¥68"
    description: "包含主菜、汤、饮料"

faq:
  - question: "营业时间是什么？"
    answer: "我们每天09:00-22:00营业"
```

## 📊 API文档

启动服务后访问：
- API文档：http://localhost:8000/docs
- 交互式文档：http://localhost:8000/redoc

### 主要API端点
- `GET /api/v1/health` - 健康检查
- `GET /api/v1/messages` - 获取消息列表
- `POST /api/v1/messages` - 创建新消息
- `GET /api/v1/customers` - 获取客户列表
- `POST /api/v1/webhooks/whatsapp` - WhatsApp Webhook

## 🧪 测试

### 运行测试
```bash
# 后端测试
cd backend
pytest

# 前端测试
cd frontend
npm test
```

### 测试覆盖率
```bash
cd backend
pytest --cov=app tests/
```

## 🚢 部署

### 生产环境部署
```bash
# 使用Docker Compose
docker-compose -f docker-compose.prod.yml up -d

# 使用Nginx反向代理
cp nginx/nginx.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx
```

### 监控和日志
```bash
# 查看日志
docker-compose logs -f

# 监控性能
docker stats

# 备份数据库
docker exec -t postgres pg_dumpall -c -U postgres > backup.sql
```

## 📈 开发路线图

### 阶段1：MVP原型 (已完成)
- [x] 项目架构设计
- [x] 基础数据模型
- [x] 核心业务逻辑
- [x] 基础API接口

### 阶段2：功能完善 (进行中)
- [ ] WhatsApp集成
- [ ] 统一收件箱界面
- [ ] AI响应引擎
- [ ] 测试模式实现

### 阶段3：商业化准备
- [ ] 多租户支持
- [ ] 计费系统
- [ ] 性能优化
- [ ] 安全加固

## 🤝 贡献指南

### 报告问题
1. 在GitHub Issues中创建新问题
2. 描述问题和重现步骤
3. 提供相关日志和截图

### 提交代码
1. Fork项目仓库
2. 创建功能分支
3. 提交Pull Request
4. 通过代码审查

### 代码规范
- 遵循PEP 8 (Python)和ESLint (JavaScript)
- 编写单元测试
- 更新相关文档
- 保持提交信息清晰

## 📞 支持

### 文档
- [API文档](http://localhost:8000/docs)
- [用户手册](docs/user_manual.md)
- [部署指南](docs/deployment_guide.md)

### 联系方式
- 问题反馈：GitHub Issues
- 功能建议：GitHub Discussions
- 紧急支持：通过项目维护者

## 📄 许可证

本项目采用MIT许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- 基于OpenClaw Use Cases项目
- 使用FastAPI和Vue.js框架
- 感谢所有贡献者和用户

---

**项目状态**: 活跃开发中  
**最新版本**: v0.1.0  
**维护者**: 小Z (AI助手)  
**项目目标**: 为中小企业提供自动化客户服务解决方案