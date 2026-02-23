# 🔐 GitHub SSH密钥配置指南

## 📋 配置状态
- **SSH密钥类型**: ed25519
- **密钥状态**: 已生成
- **公钥内容**: 已获取
- **GitHub配置**: 待添加

## 🚀 配置步骤

### 步骤1：复制SSH公钥
你的SSH公钥是：
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJbV0LA7vJM1/crPr0and8kWCHRha2In1eQDGTk3W0fn
```

**复制这个公钥**（整行内容）。

### 步骤2：添加到GitHub账户

#### 方法A：通过GitHub网站
1. 登录GitHub：https://github.com
2. 点击右上角头像 → **Settings**
3. 左侧菜单选择 **SSH and GPG keys**
4. 点击 **New SSH key** 按钮
5. 填写信息：
   - **Title**: `My Development Machine`（或自定义名称）
   - **Key type**: 保持默认
   - **Key**: 粘贴上面复制的公钥
6. 点击 **Add SSH key**

#### 方法B：通过GitHub CLI（如果已登录）
```bash
# 添加SSH密钥到GitHub
gh ssh-key add ~/.ssh/id_ed25519.pub --title "My Development Machine"
```

### 步骤3：测试SSH连接
```bash
# 测试SSH连接
ssh -T git@github.com
```

你应该看到类似的消息：
```
Hi mymuse77! You've successfully authenticated, but GitHub does not provide shell access.
```

### 步骤4：配置Git使用SSH
```bash
# 配置Git使用SSH协议
git config --global url."git@github.com:".insteadOf "https://github.com/"
```

## 🔧 项目特定配置

### 1. 更新项目远程仓库URL
```bash
# 进入项目目录
cd /home/vis/clawd/multi-channel-customer-service

# 检查当前远程仓库
git remote -v

# 如果使用HTTPS，更新为SSH
git remote set-url origin git@github.com:mymuse77/multi-channel-customer-service.git
```

### 2. 验证SSH配置
```bash
# 测试项目仓库访问
ssh -T git@github.com

# 验证远程仓库URL
git remote -v
# 应该显示：origin git@github.com:mymuse77/multi-channel-customer-service.git (fetch)
# 应该显示：origin git@github.com:mymuse77/multi-channel-customer-service.git (push)
```

## 🛠️ SSH密钥管理

### 查看现有密钥
```bash
# 查看所有SSH密钥
ls -la ~/.ssh/

# 查看公钥内容
cat ~/.ssh/id_ed25519.pub
```

### 生成新密钥（如果需要）
```bash
# 生成新的ed25519密钥（推荐）
ssh-keygen -t ed25519 -C "mymuse@foxmail.com"

# 或生成RSA密钥（兼容旧系统）
ssh-keygen -t rsa -b 4096 -C "mymuse@foxmail.com"
```

### 密钥权限检查
```bash
# 检查密钥文件权限
ls -la ~/.ssh/id_ed25519*

# 正确权限应该是：
# -rw-------  私钥（只有所有者可读）
# -rw-r--r--  公钥（所有人可读）
```

## 🔒 安全最佳实践

### 1. 密钥保护
- **私钥不要分享**：`~/.ssh/id_ed25519` 是私钥，必须保密
- **设置正确权限**：私钥600权限，公钥644权限
- **使用密码保护**：生成密钥时设置密码（可选但推荐）

### 2. 多设备管理
如果你在多台设备上开发：
1. **每台设备生成独立密钥**
2. **在GitHub添加所有公钥**
3. **使用不同标题区分**：`Work Laptop`、`Home Desktop`等

### 3. 定期轮换
建议每6-12个月：
1. 生成新密钥对
2. 添加到GitHub
3. 删除旧密钥
4. 更新所有仓库配置

## 🚨 故障排除

### 问题1：权限被拒绝
```bash
# 错误信息：Permission denied (publickey)
ssh -T git@github.com
```

**解决方案：**
```bash
# 1. 启动SSH代理
eval "$(ssh-agent -s)"

# 2. 添加私钥到代理
ssh-add ~/.ssh/id_ed25519

# 3. 重新测试
ssh -T git@github.com
```

### 问题2：密钥未找到
```bash
# 错误信息：Could not open a connection to your authentication agent
```

**解决方案：**
```bash
# 1. 确保SSH代理运行
ps aux | grep ssh-agent

# 2. 如果没有运行，启动它
eval "$(ssh-agent -s)"

# 3. 添加密钥
ssh-add ~/.ssh/id_ed25519
```

### 问题3：连接超时
```bash
# 错误信息：Connection timed out
```

**解决方案：**
```bash
# 1. 检查网络连接
ping github.com

# 2. 检查防火墙设置
# 3. 尝试使用HTTPS代替SSH
git remote set-url origin https://github.com/mymuse77/multi-channel-customer-service.git
```

## 📱 多平台配置

### Windows用户
```bash
# 使用Git Bash或WSL
# 步骤与Linux/Mac相同

# 如果使用PowerShell
Get-Content ~/.ssh/id_ed25519.pub
```

### macOS用户
```bash
# 步骤相同
# 密钥通常存储在 ~/.ssh/

# 如果需要添加到钥匙串
ssh-add -K ~/.ssh/id_ed25519
```

### Linux用户
```bash
# 步骤相同
# 确保 ~/.ssh/ 目录权限为700
chmod 700 ~/.ssh
```

## 🔗 相关资源

### 官方文档
- [GitHub SSH文档](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [生成新SSH密钥](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- [测试SSH连接](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/testing-your-ssh-connection)

### 常用命令参考
```bash
# 查看SSH配置
cat ~/.ssh/config

# 调试SSH连接
ssh -vT git@github.com

# 列出所有已添加密钥
ssh-add -l

# 删除所有密钥从代理
ssh-add -D
```

## 🎯 配置验证清单

完成以下检查：
- [ ] SSH公钥已添加到GitHub账户
- [ ] `ssh -T git@github.com` 返回成功消息
- [ ] Git远程仓库URL已更新为SSH格式
- [ ] `git remote -v` 显示SSH URL
- [ ] `git push` 可以正常工作

## 📞 支持

### 遇到问题？
1. **检查错误信息**：复制完整的错误信息
2. **验证步骤**：确保按顺序完成所有步骤
3. **查看日志**：`ssh -vT git@github.com` 查看详细日志
4. **搜索解决方案**：错误信息 + "GitHub SSH"

### 紧急情况
如果无法通过SSH推送代码：
```bash
# 临时使用HTTPS
git remote set-url origin https://github.com/mymuse77/multi-channel-customer-service.git
git push
```

---

**配置完成后**，你可以运行之前的GitHub设置脚本：
```bash
cd /home/vis/clawd/multi-channel-customer-service
./scripts/setup_github.sh
```

**最后更新**: 2026年2月23日  
**适用于**: mymuse77 (mymuse@foxmail.com)