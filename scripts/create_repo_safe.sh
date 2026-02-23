#!/bin/bash
# 安全的GitHub仓库创建脚本

set -e

echo "🔐 安全的GitHub仓库创建"
echo "======================="
echo "GitHub用户: mymuse77"
echo "邮箱: mymuse@foxmail.com"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }

# 检查当前状态
echo "🔍 检查当前状态..."
echo ""

# 1. 检查Git配置
echo "1. Git配置检查:"
if [ -d .git ]; then
    print_success "Git仓库已初始化"
    
    # 显示当前分支
    CURRENT_BRANCH=$(git branch --show-current)
    echo "   当前分支: $CURRENT_BRANCH"
    
    # 显示提交历史
    COMMIT_COUNT=$(git log --oneline | wc -l)
    echo "   提交数量: $COMMIT_COUNT"
else
    print_error "不是Git仓库"
    exit 1
fi

echo ""

# 2. 检查SSH配置
echo "2. SSH配置检查:"
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    print_success "SSH配置成功"
    echo "   用户: mymuse77"
else
    print_error "SSH配置失败"
    echo "   请先配置SSH密钥到GitHub"
    exit 1
fi

echo ""

# 3. 检查远程仓库
echo "3. 远程仓库检查:"
if git remote get-url origin &> /dev/null; then
    CURRENT_URL=$(git remote get-url origin)
    echo "   当前远程: $CURRENT_URL"
    
    # 测试连接
    if git ls-remote "$CURRENT_URL" &> /dev/null; then
        print_success "远程仓库可访问"
    else
        print_warning "远程仓库不可访问"
        echo "   可能仓库不存在或权限不足"
    fi
else
    print_warning "未设置远程仓库"
fi

echo ""
echo "=========================================="
echo "📋 创建选项"
echo "=========================================="
echo ""
echo "请选择创建方式："
echo ""
echo "A. 🖥️  使用GitHub CLI创建（需要登录）"
echo "B. 🌐 在GitHub网站创建（推荐）"
echo "C. 🔧 手动配置"
echo ""

read -p "请选择 (A/B/C): " -n 1 -r
echo ""
echo ""

case $REPLY in
    [Aa])
        echo "🖥️  使用GitHub CLI创建..."
        echo ""
        
        # 检查GitHub CLI
        if ! command -v gh &> /dev/null; then
            print_error "GitHub CLI未安装"
            echo "   安装: sudo apt install gh (Ubuntu)"
            echo "   或: brew install gh (macOS)"
            exit 1
        fi
        
        # 检查登录状态
        if ! gh auth status &> /dev/null; then
            print_warning "GitHub CLI未登录"
            echo "   请先运行: gh auth login"
            exit 1
        fi
        
        # 创建仓库
        echo "📦 创建GitHub仓库..."
        gh repo create multi-channel-customer-service \
            --description "多渠道AI客户服务平台" \
            --public \
            --remote=origin \
            --push
        
        print_success "仓库创建完成！"
        ;;
        
    [Bb])
        echo "🌐 在GitHub网站创建"
        echo ""
        echo "请按以下步骤操作："
        echo ""
        echo "1. 打开浏览器，访问: https://github.com/new"
        echo "2. 登录你的GitHub账户 (mymuse77)"
        echo "3. 填写仓库信息："
        echo "   - Repository name: multi-channel-customer-service"
        echo "   - Description: 多渠道AI客户服务平台"
        echo "   - Public/Private: 选择公开或私有"
        echo "   - Initialize with README: ❌ 不要勾选"
        echo "   - Add .gitignore: ❌ 不要选择"
        echo "   - Choose a license: ❌ 不要选择"
        echo "4. 点击 'Create repository'"
        echo ""
        echo "创建成功后，不要执行页面上的Git命令！"
        echo "返回这里继续下一步。"
        echo ""
        
        read -p "仓库创建完成了吗？(y/n): " -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # 设置远程仓库
            echo "⚙️  设置远程仓库..."
            GITHUB_URL="git@github.com:mymuse77/multi-channel-customer-service.git"
            
            git remote remove origin 2>/dev/null || true
            git remote add origin "$GITHUB_URL"
            
            print_success "远程仓库已设置"
            
            # 推送代码
            echo "📤 推送代码..."
            git push -u origin main
            
            print_success "代码推送完成！"
        else
            print_warning "请先创建仓库"
            exit 0
        fi
        ;;
        
    [Cc])
        echo "🔧 手动配置"
        echo ""
        echo "手动步骤："
        echo ""
        echo "1. 在GitHub创建仓库: https://github.com/new"
        echo "2. 获取SSH URL: git@github.com:mymuse77/multi-channel-customer-service.git"
        echo "3. 设置远程仓库:"
        echo "   git remote add origin git@github.com:mymuse77/multi-channel-customer-service.git"
        echo "4. 推送代码:"
        echo "   git push -u origin main"
        echo ""
        echo "完成后告诉我。"
        ;;
        
    *)
        print_error "无效选择"
        exit 1
        ;;
esac

echo ""
echo "=========================================="
echo "🎉 完成！"
echo "=========================================="
echo ""
echo "🌐 你的GitHub仓库:"
echo "   https://github.com/mymuse77/multi-channel-customer-service"
echo ""
echo "📊 项目统计:"
echo "   文件数量: $(find . -type f -name "*.py" -o -name "*.md" -o -name "*.json" -o -name "*.yaml" -o -name "*.sh" | wc -l)个"
echo "   代码行数: $(find . -type f -name "*.py" -o -name "*.js" -o -name "*.vue" | xargs cat 2>/dev/null | wc -l)行"
echo ""
echo "🚀 下一步:"
echo "   1. 访问上面的链接验证仓库"
echo "   2. 设置仓库描述和主题"
echo "   3. 配置分支保护规则"
echo "   4. 开始项目开发"
echo ""