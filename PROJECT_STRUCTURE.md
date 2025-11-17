# 项目结构说明

## macOS 应用文件结构

本项目是一个纯 Swift/SwiftUI 原生 macOS 应用，已移除所有 Electron/Web 相关文件。

### 核心文件

```
.
├── Sources/                    # Swift 源代码（所有应用逻辑）
│   ├── AIEngine/              # AI 引擎模块
│   ├── Live2D/                # Live2D 渲染模块
│   ├── OCR/                   # OCR 文字识别模块
│   ├── StudyModules/          # 学习工具模块
│   └── UI/                    # SwiftUI 界面模块
│
├── Resources/                  # 资源文件
│   └── Models/                # Live2D 模型文件目录
│
├── Package.swift              # Swift Package Manager 配置
├── AILearningCompanion.entitlements  # macOS 应用权限
├── Info.plist                 # macOS 应用配置
├── build_macos.sh             # 构建脚本
│
└── 文档/
    ├── README.md              # 英文 README
    ├── README_CN.md           # 中文 README
    ├── 运行指南.md            # 中文运行指南
    ├── XCODE_SETUP.md         # Xcode 设置指南
    ├── BUILD_INSTRUCTIONS.md  # 构建说明
    └── Docs/
        └── Architecture.md    # 架构文档
```

### 已删除的文件

以下 Electron/Web 相关文件已被删除：
- ❌ `package.json`, `package-lock.json` - Node.js 配置
- ❌ `index.html`, `index.js`, `preload.js` - Electron 主文件
- ❌ `PTBox.html`, `Settings.html` - Electron HTML
- ❌ `node_modules/` - Node.js 依赖
- ❌ `includes/` - Web/Electron UI 文件
- ❌ `cubism_v3/` - JavaScript 版 Live2D（使用 Swift/Metal 版本）
- ❌ `Alert Alarms/` - Electron 音频文件
- ❌ `install.ico` - Windows 安装图标

### 保留的资源

`assets/` 目录中的文件保留，可用于：
- 应用图标（app.png, applogo.png, applogo256.png）
- 演示图片（demo.png）
- 其他 UI 资源（如需要）

### 运行要求

- macOS 13.0+
- Xcode 14.0+
- Swift 5.9+

