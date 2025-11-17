#!/bin/bash

# 自动创建 Xcode 项目的脚本
# 使用方法: ./create_xcode_project.sh

set -e

PROJECT_NAME="AILearningCompanion"
PROJECT_DIR=$(pwd)

echo "🚀 正在为 $PROJECT_NAME 创建 Xcode 项目..."

# 检查是否已存在 .xcodeproj
if [ -d "$PROJECT_NAME.xcodeproj" ]; then
    echo "⚠️  项目文件已存在: $PROJECT_NAME.xcodeproj"
    echo "是否要删除并重新创建? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        rm -rf "$PROJECT_NAME.xcodeproj"
    else
        echo "取消操作"
        exit 0
    fi
fi

# 使用 swift package 生成 Xcode 项目
echo "📦 使用 Swift Package Manager 生成 Xcode 项目..."
swift package generate-xcodeproj 2>/dev/null || {
    echo "⚠️  generate-xcodeproj 命令不可用，需要手动创建"
    echo ""
    echo "请按照以下步骤手动创建："
    echo "1. 打开 Xcode"
    echo "2. File → New → Project"
    echo "3. 选择 macOS → App"
    echo "4. 产品名称: $PROJECT_NAME"
    echo "5. 添加 Sources 文件夹到项目"
    echo ""
    echo "或查看 XCODE_SETUP.md 获取详细说明"
    exit 1
}

if [ -d "$PROJECT_NAME.xcodeproj" ]; then
    echo "✅ Xcode 项目创建成功！"
    echo ""
    echo "下一步："
    echo "1. 打开 $PROJECT_NAME.xcodeproj"
    echo "2. 选择 'My Mac' 作为运行目标"
    echo "3. 按 ⌘R 运行"
    echo ""
    echo "正在打开 Xcode..."
    open "$PROJECT_NAME.xcodeproj"
else
    echo "❌ 项目创建失败"
    exit 1
fi

