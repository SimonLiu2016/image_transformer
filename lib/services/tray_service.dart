import 'package:tray_manager/tray_manager.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class TrayService {
  static TrayService? _instance;
  static TrayService get instance => _instance ??= TrayService._();

  TrayService._();

  bool _isInitialized = false;

  Future<void> initTray() async {
    if (!_isInitialized) {
      try {
        // 初始化托盘图标
        await trayManager.setIcon('assets/images/app_icons/app_icon.png');

        // 创建托盘菜单
        final menu = Menu(
          items: [
            MenuItem(
              label: 'Show Image Transformer',
              onClick: (_) {
                _showApp();
              },
            ),
            MenuItem(
              label: 'Preferences',
              onClick: (_) {
                _openPreferences();
              },
            ),
            MenuItem.separator(),
            MenuItem(
              label: 'Quit',
              onClick: (_) {
                _quitApp();
              },
            ),
          ],
        );

        await trayManager.setContextMenu(menu);

        // 添加托盘事件监听器
        trayManager.addListener(_TrayEventHandler());

        _isInitialized = true;
        debugPrint('System tray initialized successfully');
      } catch (e) {
        debugPrint('Failed to initialize system tray: $e');
      }
    }
  }

  Future<void> _showApp() async {
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> _openPreferences() async {
    // 这里可以实现打开偏好设置的逻辑
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> _quitApp() async {
    await windowManager.destroy();
  }
}

class _TrayEventHandler extends TrayListener {
  @override
  void onTrayIconMouseDown() {
    // 当点击托盘图标时显示应用窗口
    windowManager.show();
    windowManager.focus();
  }

  @override
  void onTrayIconRightMouseDown() {
    // 当右键点击托盘图标时显示上下文菜单
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    // 处理托盘菜单项点击事件
    debugPrint('Tray menu item clicked: ${menuItem.label}');
  }
}
