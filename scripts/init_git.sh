#!/bin/bash
# GitHub仓库初始化脚本

set -e

echo "🚀 开始初始化Git仓库..."

# 进入项目目录
cd "$(dirname "$0")/.."

# 检查是否已初始化Git
if [ -d ".git" ]; then
    echo "⚠️  项目已初始化Git，跳过初始化步骤"
    exit 0
fi

# 初始化Git仓库
echo "📦 初始化Git仓库..."
git init

# 配置Git
echo "⚙️  配置Git..."
git config user.name "${GIT_USER_NAME:-Your Name}"
git config user.email "${GIT_USER_EMAIL:-your.email@example.com}"
git config core.autocrlf input
git config core.safecrlf true

# 添加文件
echo "📝 添加文件到暂存区..."
git add .

# 提交初始版本
echo "💾 提交初始版本..."
git commit -m "初始提交：创建多渠道客户服务平台项目

- 项目架构设计
- 后端FastAPI框架
- 前端Vue.js基础
- Docker部署配置
- 完整文档体系"

echo "✅ Git仓库初始化完成！"

# 提示下一步操作
echo ""
echo "📋 下一步操作："
echo "1. 在GitHub上创建新仓库：https://github.com/new"
echo "2. 设置仓库信息："
echo "   - 名称: multi-channel-customer-service"
echo "   - 描述: 多渠道AI客户服务平台"
echo "   - 可见性: 公开或私有"
echo "3. 添加远程仓库并推送："
echo ""
echo "   git remote add origin https://github.com/YOUR_USERNAME/multi-channel-customer-service.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "4. 或者使用GitHub CLI："
echo ""
echo "   gh repo create multi-channel-customer-service \\"
echo "     --description '多渠道AI客户服务平台' \\"
echo "     --public \\"
echo "     --source=. \\"
echo "     --remote=origin \\"
echo "     --push"
echo ""

# 检查GitHub CLI是否安装
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI已安装"
    echo "   运行 'gh auth login' 登录GitHub"
else
    echo "ℹ️  GitHub CLI未安装，可以安装："
    echo "   Ubuntu: sudo apt install gh"
    echo "   macOS: brew install gh"
fi