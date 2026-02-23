#!/bin/bash
# 直接创建GitHub仓库脚本（使用SSH）

set -e

echo "🚀 直接创建GitHub仓库"
echo "====================="
echo "GitHub用户: mymuse77"
echo "仓库名称: multi-channel-customer-service"
echo ""

# 检查SSH配置
echo "🔐 检查SSH配置..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "✅ SSH配置成功"
else
    echo "❌ SSH配置失败，请先配置SSH密钥"
    exit 1
fi

# 检查是否已有远程仓库
echo ""
echo "🔗 检查远程仓库..."
if git remote get-url origin &> /dev/null; then
    CURRENT_URL=$(git remote get-url origin)
    echo "⚠️  已存在远程仓库: $CURRENT_URL"
    
    read -p "是否更新为GitHub仓库？(y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "操作取消"
        exit 0
    fi
fi

# 设置远程仓库URL
echo ""
echo "⚙️  设置远程仓库..."
GITHUB_URL="git@github.com:mymuse77/multi-channel-customer-service.git"

git remote remove origin 2>/dev/null || true
git remote add origin "$GITHUB_URL"

echo "✅ 远程仓库已设置: $GITHUB_URL"

# 推送代码
echo ""
echo "📤 推送代码到GitHub..."
echo "注意：如果仓库不存在，推送会失败"
echo ""

if git push -u origin main 2>&1 | grep -q "error: failed to push"; then
    echo "❌ 推送失败，可能仓库不存在"
    echo ""
    echo "📋 你需要先在GitHub创建仓库："
    echo "1. 访问: https://github.com/new"
    echo "2. 填写信息:"
    echo "   - Repository name: multi-channel-customer-service"
    echo "   - Description: 多渠道AI客户服务平台"
    echo "   - Public/Private: 选择公开或私有"
    echo "   - Initialize with README: ❌ 不勾选"
    echo "3. 点击 'Create repository'"
    echo "4. 不要执行页面上的Git命令"
    echo "5. 重新运行此脚本"
else
    echo "✅ 代码推送成功！"
    echo ""
    echo "🎉 仓库创建完成！"
    echo "   访问: https://github.com/mymuse77/multi-channel-customer-service"
fi

# 显示配置信息
echo ""
echo "=========================================="
echo "📊 配置信息"
echo "=========================================="
echo ""
echo "🔗 远程仓库:"
git remote -v
echo ""
echo "🌐 GitHub仓库:"
echo "   https://github.com/mymuse77/multi-channel-customer-service"
echo ""
echo "🚀 下一步:"
echo "   1. 访问上面的GitHub链接"
echo "   2. 验证所有文件已上传"
echo "   3. 设置仓库描述和主题"
echo "   4. 配置分支保护规则"
echo ""