<p align="center">
<img src="./assets/app.png" width=120px height=120px>
</p>

<h1 align="center">AI 学习伴侣</h1>
<h3 align="center">适用于 macOS 的智能学习助手，配备 Live2D 角色</h3>

<p align="center">
<img src="https://img.shields.io/badge/macOS-13.0+-blue.svg?style=flat-square">
<img src="https://img.shields.io/badge/Swift-5.9+-orange.svg?style=flat-square">
<img src="https://img.shields.io/badge/SwiftUI-原生-green.svg?style=flat-square">
<img src="https://img.shields.io/badge/License-GPL%20v3.0-purple.svg?style=flat-square">
</p>

---

## 🎯 什么是 AI 学习伴侣？

**AI 学习伴侣** 是一款原生 macOS 应用程序，将交互式 Live2D 角色与 AI 驱动的学习工具相结合。它就像你的个人学习伙伴，通过对话、闪卡、定时学习会话和智能内容生成，帮助你更有效地学习。

### 核心功能

✨ **交互式 Live2D 角色**
- 响应你学习活动的精美动画角色
- 根据你的进度实时变化的表情和动画
- 可拖动的浮动窗口，随时陪伴

🤖 **AI 驱动的学习**
- 与 GPT-4 对话，获取解释、问题和学习帮助
- 从学习材料自动生成闪卡
- 从任何文本内容创建选择题
- 从图片中提取文字，快速做笔记

📚 **学习工具**
- **番茄钟计时器**：专注会话，自动休息管理
- **闪卡生成器**：AI 从你的内容创建学习卡片
- **问题生成器**：自动生成练习题
- **PDF 报告**：每周学习总结，包含性能指标

🎨 **原生 macOS 体验**
- 使用 SwiftUI 构建，流畅的原生性能
- Metal 驱动的 Live2D 渲染
- macOS 设置集成（⌘,）
- 菜单栏命令和键盘快捷键
- 美观、响应式的界面

---

## 🚀 macOS 快速开始

### 前置要求

- **macOS 13.0 (Ventura)** 或更高版本
- **Xcode 14.0** 或更高版本（用于构建）
- **OpenAI API 密钥**（用于 AI 功能）

### 安装选项

#### 选项一：Xcode 项目（推荐 - 最简单）

1. **打开 Xcode** 并创建新项目：
   - 文件 → 新建 → 项目 (⌘⇧N)
   - 选择 **macOS** → **App**
   - 产品名称：`AILearningCompanion`
   - 界面：**SwiftUI**
   - 语言：**Swift**

2. **添加源文件**：
   - 右键点击项目 → **"将文件添加到 AILearningCompanion..."**
   - 选择 `Sources` 文件夹
   - ✅ **创建组**
   - ✅ **添加到目标: AILearningCompanion**
   - ❌ **取消勾选 "如果需要则复制项目"**（使用引用）

3. **设置应用入口点**：
   - 应用入口点已在 `Sources/UI/LearningCompanionApp.swift` 中定义
   - 你的主 App 文件只需导入并使用它，或替换为：
   ```swift
   import SwiftUI
   
   @main
   struct AILearningCompanionApp: App {
       var body: some Scene {
           WindowGroup {
               ContentView()
           }
       }
   }
   ```

4. **配置构建设置**：
   - 设置 **最低部署版本** 为 **macOS 13.0**
   - 添加 `AILearningCompanion.entitlements` 文件（仓库中已提供）
   - 启用 **App Sandbox**，允许网络和文件访问

5. **构建并运行**：按 **⌘R**

📖 **详细设置**：查看 [XCODE_SETUP.md](./XCODE_SETUP.md) 获取分步说明。

#### 选项二：Swift Package Manager

```bash
# 克隆仓库
git clone https://github.com/yourusername/live2d-kanban-desktop.git
cd live2d-kanban-desktop

# 构建包
swift build

# 或使用构建脚本
chmod +x build_macos.sh
./build_macos.sh
```

> **注意**：SPM 构建的是库。要创建应用包，你仍需要使用 Xcode。

#### 选项三：命令行构建

```bash
# 使构建脚本可执行
chmod +x build_macos.sh

# 运行构建
./build_macos.sh
```

---

## 📖 如何使用

### 首次启动

1. **配置 API 密钥**：
   - 打开 **设置**（⌘,）
   - 在 "AI 配置" 部分输入你的 OpenAI API 密钥
   - 点击 "测试连接" 验证

2. **加载 Live2D 模型**（可选）：
   - 将 Live2D 模型文件放在 `Resources/Models/` 目录
   - 或在设置中指定模型路径

3. **开始学习**：
   - 点击 **"Ask AI"** 开始对话
   - 使用 **"OCR"** 从图片提取文字
   - 从学习材料生成闪卡
   - 启动番茄钟进行专注学习

### 主要功能

#### 💬 与 AI 对话
- 在聊天界面输入问题
- 获取解释、学习技巧和帮助
- 会话期间保持对话历史

#### 📸 OCR 文字提取
- 点击 **"OCR"** 按钮
- 选择或粘贴图片
- 使用 Vision 框架自动提取文字
- 使用提取的文字生成闪卡或问题

#### 🎴 生成闪卡
- 点击 **"Flashcards"** 按钮
- 粘贴或输入学习材料
- AI 自动创建问答对
- 复习和学习你的闪卡

#### ⏱️ 番茄钟计时器
- 点击 **"Pomodoro"** 按钮
- 开始 25 分钟专注会话
- 自动休息和进度跟踪
- 角色响应你的学习状态

#### 🎭 Live2D 角色
- 交互式角色响应你的活动
- 表情根据学习进度变化
- 浮动窗口模式，始终可见的伙伴
- 拖动到屏幕任意位置

---

## 🏗️ 项目架构

这是一个使用现代 Apple 框架构建的**原生 Swift/SwiftUI** 应用程序：

### 技术栈

- **SwiftUI**：原生 UI 框架
- **Metal**：高性能 Live2D 渲染
- **Vision**：OCR 文字识别
- **PDFKit**：报告生成
- **Combine**：响应式编程
- **Async/Await**：现代并发

### 模块结构

```
Sources/
├── AIEngine/          # AI 提供者、聊天和内容生成
├── Live2D/            # Live2D 渲染和角色管理
├── OCR/               # 从图片提取文字
├── StudyModules/      # 闪卡、番茄钟、问题、报告
└── UI/                # SwiftUI 视图和应用结构
```

### 架构原则

- **MVVM**：模型-视图-视图模型模式
- **协议导向**：通过协议进行依赖注入
- **模块化设计**：隔离、可测试的模块
- **平台无关**：适用于 macOS 和 iOS（带平台特定优化）

📚 **详细架构**：查看 [Docs/Architecture.md](./Docs/Architecture.md)

---

## ⚙️ 配置

### 设置（⌘,）

- **AI 配置**：设置你的 OpenAI API 密钥
- **Live2D 角色**：配置模型路径和设置
- **学习偏好**：自定义番茄钟时长、自动启动选项
- **外观**：选择主题（浅色/深色/系统）和强调色
- **浮动窗口**：启用/禁用浮动角色窗口

### 文件位置

- **Live2D 模型**：`Resources/Models/`（或在设置中的自定义路径）
- **设置**：存储在 UserDefaults 中
- **报告**：生成的 PDF 可以保存到任何位置

---

## 🔧 故障排除

### 应用无法构建

- **"找不到类型 'X'"**：确保 `Sources` 中的所有文件都已添加到目标
- **Metal 错误**：验证你的 Mac 支持 Metal（所有现代 Mac 都支持）
- **导入错误**：检查框架是否正确链接

### 运行时问题

- **AI 聊天不工作**：验证 API 密钥已设置且网络访问已启用
- **Live2D 不显示**：检查模型文件是否在正确位置
- **OCR 不工作**：确保图片格式受支持（JPEG、PNG）
- **设置无法保存**：检查应用沙盒权限

### 性能

- **渲染缓慢**：确保 Metal 已启用且 GPU 可用
- **内存使用高**：Live2D 渲染的正常现象；如需要可关闭其他应用

---

## 📋 要求

### 系统要求

- **macOS 13.0 (Ventura)** 或更高版本
- **支持 Metal 的 GPU**（所有现代 Mac）
- **互联网连接**（用于 AI 功能）

### 开发要求

- **Xcode 14.0** 或更高版本
- **Swift 5.9** 或更高版本
- **命令行工具**

### API 要求

- **OpenAI API 密钥**（用于 AI 聊天和内容生成）
  - 获取地址：https://platform.openai.com/api-keys
  - 提供免费层级用于测试

---

## 🎨 功能详解

### Live2D 集成

- **基于 Metal 的渲染**，流畅的 60fps 动画
- **状态机**管理角色情绪和行为
- **番茄钟集成** - 角色响应学习会话
- **表情系统** - 角色显示不同情绪
- **动作播放** - 不同状态的动画

### AI 引擎

- **OpenAI GPT-4** 集成
- **上下文感知对话** - 记住最近的消息
- **闪卡生成** - 从任何文本内容
- **问题生成** - 带选择题选项
- **解释系统** - 用于复杂主题

### 学习模块

- **闪卡**：间隔重复算法、难度跟踪
- **番茄钟**：25/5/15 分钟周期、自动阶段转换
- **问题**：带解释的多选题
- **报告**：带性能指标的 PDF 生成

### OCR 模块

- **Vision 框架**集成
- **多语言支持**
- **自动文字清理**
- **图片格式支持**：JPEG、PNG、HEIC

---

## 🛠️ 开发

### 从源代码构建

```bash
# 克隆仓库
git clone https://github.com/yourusername/live2d-kanban-desktop.git
cd live2d-kanban-desktop

# 在 Xcode 中打开
open -a Xcode .

# 或使用 SPM 构建
swift build
```

### 项目文件

- `Package.swift`：Swift Package Manager 配置
- `AILearningCompanion.entitlements`：应用沙盒权限
- `Info.plist`：应用元数据
- `Sources/`：所有应用源代码
- `Resources/Models/`：Live2D 模型文件位置

### 代码结构

所有代码遵循 Apple 的 Swift API 设计指南：
- 清晰、描述性的命名
- 协议导向设计
- 现代 Swift 并发（async/await）
- 全面的错误处理
- 尽可能平台无关

---

## 📝 许可证

本项目在 **GPL v3.0** 许可证下开源。

**注意**：Live2D Cubism SDK 的使用受 Cubism EULA 约束。模型文件受其各自版权保护。

---

## 🙏 致谢

### 使用的技术

- **Live2D Cubism SDK**：角色渲染
- **SwiftUI**：原生 UI 框架
- **Metal**：GPU 加速渲染
- **Vision**：OCR 功能
- **OpenAI API**：AI 功能

### 特别感谢

本项目代表从 Electron 到原生 Swift/SwiftUI 的完全重写，带来：
- 更好的性能
- 更低的资源使用
- 原生 macOS 集成
- 现代 Apple 设计模式

---

## 🐛 已知问题和路线图

### 当前限制

- Live2D Cubism SDK 集成部分实现（代码中标记了 TODO）
- 某些高级功能需要额外的 API 设置
- 模型加载需要手动配置

### 计划功能

- [ ] 完成 Live2D Cubism SDK 集成
- [ ] 闪卡云同步
- [ ] 小组件扩展
- [ ] Siri 快捷指令集成
- [ ] 高级学习分析
- [ ] 多语言支持

---

## 💬 支持和贡献

### 获取帮助

- **问题**：在 GitHub Issues 上报告错误或请求功能
- **文档**：查看 `Docs/` 文件夹获取详细指南
- **设置帮助**：查看 `XCODE_SETUP.md` 获取详细设置说明

### 贡献

欢迎贡献！请：
1. Fork 仓库
2. 创建功能分支
3. 遵循 Swift 风格指南
4. 提交 Pull Request

---

## 📚 其他文档

- **[运行指南.md](./运行指南.md)**：详细的中文运行说明
- **[XCODE_SETUP.md](./XCODE_SETUP.md)**：详细的 Xcode 设置指南
- **[BUILD_INSTRUCTIONS.md](./BUILD_INSTRUCTIONS.md)**：构建说明
- **[Docs/Architecture.md](./Docs/Architecture.md)**：架构文档
- **[README.md](./README.md)**：英文版 README

---

<p align="center">
<strong>为想要更聪明地学习，而不是更努力地学习的 macOS 用户而构建 ❤️</strong>
</p>

<p align="center">
使用 SwiftUI 构建 • 原生性能 • 精美设计
</p>

