#!/bin/bash
# GitHub仓库设置脚本 - 为 mymuse77 定制

set -e

echo "🚀 GitHub仓库设置脚本"
echo "======================"
echo "GitHub用户: mymuse77"
echo "邮箱: mymuse@foxmail.com"
echo "仓库: multi-channel-customer-service"
echo ""

# 进入项目目录
cd "$(dirname "$0")/.."

# 检查GitHub CLI是否安装
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI未安装"
    echo "请先安装GitHub CLI："
    echo "  Ubuntu: sudo apt install gh"
    echo "  macOS: brew install gh"
    exit 1
fi

# 检查是否已登录
echo "🔍 检查GitHub登录状态..."
if gh auth status &> /dev/null; then
    echo "✅ 已登录GitHub"
    
    # 显示当前用户
    CURRENT_USER=$(gh api user --jq .login)
    echo "   当前用户: $CURRENT_USER"
    
    if [ "$CURRENT_USER" != "mymuse77" ]; then
        echo "⚠️  当前登录用户不是 mymuse77"
        echo "   建议使用正确账户："
        echo "   gh auth logout"
        echo "   gh auth login"
        exit 1
    fi
else
    echo "❌ 未登录GitHub"
    echo ""
    echo "📋 登录步骤："
    echo "1. 运行: gh auth login"
    echo "2. 选择: GitHub.com"
    echo "3. 选择: HTTPS协议"
    echo "4. 选择: 使用浏览器登录"
    echo "5. 在浏览器中授权"
    echo ""
    echo "请先登录，然后重新运行此脚本"
    exit 1
fi

# 检查仓库是否已存在
echo ""
echo "🔍 检查仓库是否已存在..."
if gh repo view mymuse77/multi-channel-customer-service &> /dev/null; then
    echo "✅ 仓库已存在: https://github.com/mymuse77/multi-channel-customer-service"
    
    # 检查是否已设置远程仓库
    if git remote get-url origin &> /dev/null; then
        echo "✅ 远程仓库已配置"
    else
        echo "⚙️  配置远程仓库..."
        git remote add origin https://github.com/mymuse77/multi-channel-customer-service.git
    fi
    
    # 推送代码
    echo "📤 推送代码到GitHub..."
    git push -u origin main
    
    echo ""
    echo "🎉 代码已推送到现有仓库！"
    echo "   访问: https://github.com/mymuse77/multi-channel-customer-service"
    
else
    echo "📦 创建新仓库..."
    
    # 创建仓库
    gh repo create multi-channel-customer-service \
        --description "多渠道AI客户服务平台" \
        --public \
        --source=. \
        --remote=origin \
        --push
    
    echo ""
    echo "🎉 仓库创建成功！"
    echo "   访问: https://github.com/mymuse77/multi-channel-customer-service"
fi

# 设置仓库信息
echo ""
echo "⚙️  设置仓库信息..."

# 设置仓库主题
echo "   设置主题标签..."
gh api -X PATCH /repos/mymuse77/multi-channel-customer-service \
    -f 'topics=["customer-service", "ai", "automation", "openclaw", "python", "vuejs"]' \
    --silent

# 设置仓库描述（更详细）
echo "   更新详细描述..."
gh api -X PATCH /repos/mymuse77/multi-channel-customer-service \
    -f 'description="多渠道AI客户服务平台 - 基于OpenClaw的自动化客户服务解决方案"'

# 启用功能
echo ""
echo "🔧 启用仓库功能..."

# 启用Issue
echo "   启用Issues..."
gh api -X PATCH /repos/mymuse77/multi-channel-customer-service \
    -f 'has_issues=true'

# 启用Wiki
echo "   启用Wiki..."
gh api -X PATCH /repos/mymuse77/multi-channel-customer-service \
    -f 'has_wiki=true'

# 启用Projects
echo "   启用Projects..."
gh api -X PATCH /repos/mymuse77/multi-channel-customer-service \
    -f 'has_projects=true'

# 创建初始Issue
echo ""
echo "📝 创建初始Issue..."
gh issue create \
    --title "项目初始化完成" \
    --body "## 🎉 项目初始化完成

多渠道AI客户服务平台项目已成功初始化并推送到GitHub。

### ✅ 已完成的工作
- 项目架构设计
- 后端FastAPI框架
- 前端Vue.js基础
- Docker部署配置
- 完整文档体系

### 🚀 下一步计划
1. 完善API实现
2. 集成WhatsApp API
3. 开发用户界面
4. 测试和部署

### 📊 技术栈
- 后端: Python + FastAPI
- 前端: Vue.js 3 + Element Plus
- 数据库: PostgreSQL
- 部署: Docker

---
*由AI助手小Z协助创建*" \
    --label "enhancement"

# 显示成功信息
echo ""
echo "=========================================="
echo "✅ GitHub仓库设置完成！"
echo "=========================================="
echo ""
echo "📊 仓库信息:"
echo "   名称: multi-channel-customer-service"
echo "   所有者: mymuse77"
echo "   可见性: 公开"
echo "   地址: https://github.com/mymuse77/multi-channel-customer-service"
echo ""
echo "🔗 相关链接:"
echo "   - 代码: https://github.com/mymuse77/multi-channel-customer-service"
echo "   - Issues: https://github.com/mymuse77/multi-channel-customer-service/issues"
echo "   - Wiki: https://github.com/mymuse77/multi-channel-customer-service/wiki"
echo ""
echo "🚀 下一步建议:"
echo "   1. 访问仓库页面验证设置"
echo "   2. 设置分支保护规则"
echo "   3. 配置CI/CD工作流"
echo "   4. 邀请协作者（如果需要）"
echo ""
echo "💡 提示: 你可以运行 'gh repo view --web' 在浏览器中打开仓库"
echo ""