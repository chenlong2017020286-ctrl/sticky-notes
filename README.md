# StickyNotes - 跨平台桌面便笺

Flutter 版本，支持 Android / iOS / Windows。

```
lib/
├── main.dart               # 入口
├── models/note_model.dart  # 数据模型
├── services/storage_service.dart # JSON 存储
├── screens/home_screen.dart # 主界面
├── widgets/
│   ├── note_card.dart      # 便笺卡片
│   └── note_editor.dart    # 编辑对话框
└── theme/app_theme.dart    # 主题
```

## 运行

```bash
flutter run -d windows    # Windows
flutter run -d android    # Android
```

## iOS 打包（无需 Mac）

1. 推送到 GitHub
2. 在 [Codemagic.io](https://codemagic.io) 添加项目
3. 自动构建 → 下载 IPA

或使用 EAS CLI：
```bash
eas build --platform ios --profile production
```
