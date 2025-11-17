# 🚀 从这里开始 - 如何运行程序

## ⚠️ 重要：不能直接运行

**这个项目目前不能直接双击运行**，因为：

- ❌ 没有编译好的 `.app` 应用包
- ❌ 没有 Xcode 项目文件
- ✅ 只有源代码，需要先编译

**必须使用 Xcode 先创建项目并构建，然后才能运行。**

---

## ⚡ 最快运行方法（5-10 分钟）

### 方法一：使用 Xcode（推荐）

#### 1️⃣ 打开 Xcode 并创建项目

```bash
# 在终端执行
cd /Users/alex/github/live2d-kanban-desktop
open -a Xcode .
```

或者：
1. 打开 **Xcode**
2. **File → New → Project** (⌘⇧N)
3. 选择 **macOS** → **App**
4. 产品名称：`AILearningCompanion`
5. 界面：**SwiftUI**，语言：**Swift**

#### 2️⃣ 添加源代码

1. 在 Xcode 中，**右键项目名称**
2. **Add Files to "AILearningCompanion"...**
3. 选择 **`Sources`** 文件夹
4. ✅ **Create groups**
5. ✅ **Add to targets: AILearningCompanion**
6. ❌ **取消勾选 "Copy items if needed"**

#### 3️⃣ 设置应用入口

打开 Xcode 创建的 `AILearningCompanionApp.swift`，替换为：

```swift
import SwiftUI

@main
struct AILearningCompanionApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(themeManager)
                .environmentObject(appState)
                .preferredColorScheme(themeManager.colorScheme)
        }
        #if os(macOS)
        .windowStyle(.automatic)
        .defaultSize(width: 1000, height: 700)
        #endif
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
        
        #if os(macOS)
        Settings {
            SettingsView()
                .environmentObject(themeManager)
                .environmentObject(appState)
        }
        #endif
    }
}
```

#### 4️⃣ 配置并运行

1. 选择项目 → **AILearningCompanion** 目标
2. **General** → **Minimum Deployments**: macOS 13.0
3. **Signing & Capabilities** → 启用 **App Sandbox**
4. 添加权限：
   - ✅ **Outgoing Connections (Client)**
   - ✅ **User Selected File (Read/Write)**
5. 选择 **"My Mac"** 作为运行目标
6. 按 **⌘R** 运行！

---

## 📚 详细文档

- **完整设置指南**：[XCODE_SETUP.md](./XCODE_SETUP.md)
- **中文运行指南**：[运行指南.md](./运行指南.md)
- **如何运行**：[如何运行.md](./如何运行.md)

---

## ✅ 运行后

1. **设置 API 密钥**：⌘, → 输入 OpenAI API 密钥
2. **开始使用**：点击 "Ask AI" 开始对话

---

## 🆘 需要帮助？

- 查看详细文档
- 检查 Xcode 控制台的错误信息
- 确保所有文件都添加到目标

**总结**：需要 Xcode 创建项目（约 5-10 分钟），然后就可以运行了！

