# StickyNotes iOS IPA 构建指南

从 Windows 到 IPA，零 Mac 环境。

---

## 前提条件

- [ ] 代码已推送到 GitHub ✅（已完成）
- [ ] Apple Developer 账号（$99/年）

> Apple Developer 是唯一必须的付费项。在浏览器即可注册：
> https://developer.apple.com/programs/enroll/

---

## 第一步：注册 Codemagic

1. 打开 https://codemagic.io
2. 点击 **Sign up with GitHub**
3. 授权后进入 Dashboard
4. 免费计划：**500 分钟/月**，足够个人使用

---

## 第二步：添加项目

1. 点击 **Add application**
2. 选择 **GitHub** → 授权 Codemagic
3. 找到 `chenlong2017020286-ctrl/sticky-notes`
4. 选择 **Flutter Project**
5. 点击 **Finish**

---

## 第三步：配置 iOS 构建

在项目设置中：

### 3.1 构建设置

| 选项 | 选择 |
|------|------|
| Build machine | **macOS**（必须，iOS 只能在 Mac 上编译） |
| Platform | 勾选 **iOS** |
| Build type | **Release**（正式版）或 **Debug**（开发测试） |

### 3.2 代码签名（最关键一步）

Codemagic 支持**自动签名**，你需要提供 Apple Developer 凭据：

1. 左侧菜单 → **Code signing**
2. 勾选 **iOS code signing**
3. 选择 **Automatic** 模式
4. 输入你的 Apple Developer 账号和密码
5. Codemagic 会自动管理证书

> 如果使用手动签名，需要上传 `.p12` 证书和 `.mobileprovision` 描述文件。

---

## 第四步：触发构建

两种方式：

### 方式 A：手动触发

在 Codemagic 项目页 → **Start new build**
- Branch: `master`
- Platform: 勾选 iOS
- 点击 **Start build**

### 方式 B：自动触发（推荐）

Codemagic 默认已配置 webhook，以后每次 `git push` 自动构建。

---

## 第五步：下载 IPA

构建完成后：

1. 在 Build 列表找到绿色 ✓ 的构建
2. 点击 **Download** → **IPA**
3. 或直接安装到设备：点击 **Install** → 用 iPhone 扫码

---

## 替代方案：Android APK（免费）

如果你想先不花钱就能跑起来：

```bash
# 在 Windows 上直接构建 Android 版本
export PATH="/c/tools/flutter/bin:\$PATH"
flutter build apk --debug
```

APK 位置：`build/app/outputs/flutter-apk/app-debug.apk`

用数据线连 Android 手机，复制 APK 安装即可。

---

## 项目信息

- **GitHub**: https://github.com/chenlong2017020286-ctrl/sticky-notes
- **技术栈**: Flutter 3.41 + Dart 3.11
- **存储**: 本地 JSON 文件（无需服务器）
- **构建服务**: Codemagic（免费 500 分钟/月）
