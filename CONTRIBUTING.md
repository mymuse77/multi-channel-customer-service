# 贡献指南

感谢你考虑为多渠道客户服务平台项目做出贡献！

## 🚀 开始贡献

### 报告问题
1. 在GitHub Issues中搜索是否已有类似问题
2. 如果没有，创建新Issue
3. 描述清晰的问题，包括：
   - 问题描述
   - 重现步骤
   - 期望行为
   - 实际行为
   - 截图或日志（如果适用）

### 功能建议
1. 在GitHub Discussions中发起讨论
2. 描述功能需求和场景
3. 讨论技术实现方案
4. 获得社区反馈后提交PR

### 提交代码
1. Fork项目仓库
2. 创建功能分支：`git checkout -b feature/your-feature-name`
3. 提交更改：`git commit -m 'Add some feature'`
4. 推送到分支：`git push origin feature/your-feature-name`
5. 提交Pull Request

## 📋 开发流程

### 1. 设置开发环境
```bash
# 克隆仓库
git clone https://github.com/YOUR_USERNAME/multi-channel-customer-service.git
cd multi-channel-customer-service

# 后端设置
cd backend
python -m venv venv
source venv/bin/activate  # Linux/Mac
pip install -r requirements.txt

# 前端设置
cd ../frontend
npm install
```

### 2. 代码规范

#### Python代码
- 遵循PEP 8规范
- 使用Black进行代码格式化
- 使用isort进行导入排序
- 编写类型注解

```bash
# 格式化代码
black app/
isort app/

# 类型检查
mypy app/
```

#### JavaScript/Vue代码
- 遵循ESLint规则
- 使用Prettier格式化
- 编写类型定义

```bash
# 格式化代码
npm run format

# 代码检查
npm run lint
```

### 3. 测试要求
- 为新功能编写单元测试
- 确保测试覆盖率不降低
- 测试通过后再提交PR

```bash
# 运行测试
cd backend
pytest

# 测试覆盖率
pytest --cov=app tests/
```

### 4. 文档更新
- 更新相关API文档
- 更新用户指南
- 更新部署文档
- 添加代码注释

## 🏗️ 项目结构

### 后端结构
```
backend/
├── app/
│   ├── api/          # API端点
│   ├── core/         # 核心配置
│   ├── models/       # 数据模型
│   ├── services/     # 业务逻辑
│   └── utils/        # 工具函数
├── tests/            # 测试代码
└── requirements.txt  # 依赖管理
```

### 前端结构
```
frontend/
├── src/
│   ├── components/   # 可复用组件
│   ├── views/        # 页面组件
│   ├── router/       # 路由配置
│   ├── store/        # 状态管理
│   └── api/          # API调用
└── package.json      # 依赖管理
```

## 🧪 测试指南

### 单元测试
```python
# tests/test_example.py
def test_example():
    assert 1 + 1 == 2
```

### 集成测试
```python
# tests/integration/test_api.py
def test_api_endpoint(client):
    response = client.get("/api/health")
    assert response.status_code == 200
```

### 端到端测试
```bash
# 使用Cypress或Playwright
npm run e2e
```

## 📝 提交规范

### 提交信息格式
```
类型(范围): 描述

详细说明（可选）

关闭 #Issue编号
```

### 类型说明
- `feat`: 新功能
- `fix`: 修复bug
- `docs`: 文档更新
- `style`: 代码格式
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建过程或辅助工具

### 示例
```
feat(api): 添加消息列表API端点

- 实现GET /api/v1/messages端点
- 添加分页和过滤功能
- 更新API文档

关闭 #123
```

## 🔍 代码审查

### 审查要点
1. **功能完整性**：是否实现需求
2. **代码质量**：是否遵循规范
3. **测试覆盖**：是否有足够测试
4. **文档更新**：是否更新相关文档
5. **性能影响**：是否影响系统性能

### 审查流程
1. 创建Pull Request
2. 等待CI/CD检查通过
3. 等待维护者审查
4. 根据反馈修改代码
5. 通过审查后合并

## 🛡️ 安全指南

### 安全注意事项
1. 不要提交敏感信息（API密钥、密码等）
2. 验证用户输入，防止注入攻击
3. 使用参数化查询，防止SQL注入
4. 实施适当的身份验证和授权
5. 定期更新依赖包

### 安全报告
如果发现安全漏洞，请：
1. 不要公开披露
2. 通过安全邮件或私密方式报告
3. 等待修复后再公开

## 🤝 行为准则

### 我们的承诺
我们致力于为每个人提供友好、尊重和包容的社区环境。

### 我们的标准
- 使用友好和尊重的语言
- 尊重不同的观点和经验
- 优雅地接受建设性批评
- 关注社区的最佳利益
- 对其他社区成员表示同理心

### 不可接受的行为
- 使用性化语言或图像
- 挑衅、侮辱或贬低性评论
- 公开或私下骚扰
- 未经明确许可发布他人私人信息
- 其他不专业或不合适的行为

## 📞 获取帮助

### 沟通渠道
- GitHub Issues: 问题报告和功能建议
- GitHub Discussions: 技术讨论和问答
- Pull Requests: 代码贡献

### 学习资源
- [FastAPI文档](https://fastapi.tiangolo.com/)
- [Vue.js文档](https://vuejs.org/)
- [OpenAPI规范](https://swagger.io/specification/)

---

感谢你的贡献！🎉