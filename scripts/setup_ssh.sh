#!/bin/bash
# GitHub SSH配置脚本

set -e

echo "🔐 GitHub SSH配置脚本"
echo "====================="
echo "GitHub用户: mymuse77"
echo "邮箱: mymuse@foxmail.com"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 函数：打印带颜色的消息
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 检查SSH目录
echo "🔍 检查SSH配置..."
if [ ! -d ~/.ssh ]; then
    print_warning "SSH目录不存在，创建中..."
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    print_success "SSH目录创建完成"
fi

# 检查现有密钥
echo ""
echo "📋 检查现有SSH密钥..."
EXISTING_KEYS=$(ls ~/.ssh/id_* 2>/dev/null | grep -v .pub || true)

if [ -n "$EXISTING_KEYS" ]; then
    print_success "找到现有SSH密钥："
    for key in $EXISTING_KEYS; do
        if [[ $key == *.pub ]]; then
            echo "  📄 公钥: $(basename $key)"
        else
            echo "  🔑 私钥: $(basename $key)"
        fi
    done
    
    # 显示ed25519公钥
    if [ -f ~/.ssh/id_ed25519.pub ]; then
        echo ""
        echo "📋 你的SSH公钥（ed25519）："
        echo "----------------------------------------"
        cat ~/.ssh/id_ed25519.pub
        echo "----------------------------------------"
    fi
else
    print_warning "未找到SSH密钥"
    
    # 询问是否生成新密钥
    read -p "是否生成新的SSH密钥？(y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🔑 生成新的ed25519 SSH密钥..."
        ssh-keygen -t ed25519 -C "mymuse@foxmail.com" -f ~/.ssh/id_ed25519
        
        print_success "SSH密钥生成完成"
        
        echo ""
        echo "📋 你的新SSH公钥："
        echo "----------------------------------------"
        cat ~/.ssh/id_ed25519.pub
        echo "----------------------------------------"
    else
        print_error "需要SSH密钥才能继续"
        exit 1
    fi
fi

# 检查SSH代理
echo ""
echo "⚙️  检查SSH代理..."
if [ -z "$SSH_AUTH_SOCK" ]; then
    print_warning "SSH代理未运行，启动中..."
    eval "$(ssh-agent -s)" > /dev/null 2>&1
    print_success "SSH代理已启动"
else
    print_success "SSH代理已在运行"
fi

# 添加密钥到代理
echo ""
echo "🔧 添加SSH密钥到代理..."
if ssh-add -l | grep -q "ed25519"; then
    print_success "SSH密钥已在代理中"
else
    ssh-add ~/.ssh/id_ed25519 2>/dev/null || true
    print_success "SSH密钥已添加到代理"
fi

# 测试GitHub连接
echo ""
echo "📡 测试GitHub SSH连接..."
TEST_RESULT=$(ssh -T git@github.com 2>&1 || true)

if echo "$TEST_RESULT" | grep -q "successfully authenticated"; then
    print_success "SSH连接测试成功！"
    echo "   消息: $TEST_RESULT"
else
    print_warning "SSH连接测试未完全成功"
    echo "   输出: $TEST_RESULT"
    echo ""
    print_warning "你需要将SSH公钥添加到GitHub账户"
fi

# 配置Git使用SSH
echo ""
echo "⚙️  配置Git使用SSH协议..."
git config --global url."git@github.com:".insteadOf "https://github.com/" 2>/dev/null || true
print_success "Git SSH协议配置完成"

# 更新项目远程仓库（如果已设置）
echo ""
echo "🔗 检查项目远程仓库配置..."
if [ -d .git ]; then
    CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null || echo "未设置")
    
    if [[ $CURRENT_REMOTE == https://github.com/* ]]; then
        print_warning "当前使用HTTPS协议，建议更新为SSH"
        
        # 提取仓库路径
        REPO_PATH=$(echo $CURRENT_REMOTE | sed 's|https://github.com/||')
        
        # 更新为SSH URL
        SSH_URL="git@github.com:$REPO_PATH"
        
        read -p "是否更新远程仓库为SSH协议？(y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git remote set-url origin "$SSH_URL"
            print_success "远程仓库已更新为SSH协议"
            echo "   新URL: $SSH_URL"
        fi
    elif [[ $CURRENT_REMOTE == git@github.com:* ]]; then
        print_success "远程仓库已使用SSH协议"
        echo "   当前URL: $CURRENT_REMOTE"
    else
        print_warning "远程仓库未设置或使用其他协议"
    fi
else
    print_warning "当前目录不是Git仓库"
fi

# 显示配置摘要
echo ""
echo "=========================================="
echo "🔐 SSH配置摘要"
echo "=========================================="
echo ""
echo "📋 你的SSH公钥（复制到GitHub）："
echo "----------------------------------------"
if [ -f ~/.ssh/id_ed25519.pub ]; then
    cat ~/.ssh/id_ed25519.pub
else
    cat ~/.ssh/id_*.pub 2>/dev/null | head -1 || echo "未找到公钥"
fi
echo "----------------------------------------"
echo ""
echo "🚀 下一步操作："
echo ""
echo "1. 📋 复制上面的SSH公钥"
echo "2. 🌐 访问GitHub设置：https://github.com/settings/keys"
echo "3. 🔑 点击 'New SSH key' 按钮"
echo "4. 📝 填写信息："
echo "   - Title: My Development Machine"
echo "   - Key: 粘贴复制的公钥"
echo "5. ✅ 点击 'Add SSH key'"
echo ""
echo "🔧 验证配置："
echo "   ssh -T git@github.com"
echo ""
echo "📁 你的SSH密钥文件："
echo "   🔐 私钥: ~/.ssh/id_ed25519 (不要分享！)"
echo "   📄 公钥: ~/.ssh/id_ed25519.pub (添加到GitHub)"
echo ""
echo "💡 提示：配置完成后，你可以运行："
echo "   ./scripts/setup_github.sh"
echo "   来自动创建和配置GitHub仓库"
echo ""