# Image Transformer

一个强大的图片处理工具，支持从系统拖拽图片到应用进行处理，并可导出处理后的图片。

## 功能特性

- 🖱️ **拖拽支持**：支持从系统直接拖拽图片到应用
- 🎨 **参数调整**：支持亮度、对比度、旋转等参数调整
- 🔍 **实时预览**：参数调整时实时预览处理结果
- 💾 **导出功能**：支持处理后图片的导出和保存
- 🌐 **多格式支持**：支持多种图片格式（PNG、JPG、JPEG、GIF、BMP、WEBP、TIFF、TGA等）
- 🍎 **macOS优化**：专为macOS系统优化

## 支持的图片格式

- 通用格式：PNG、JPG、JPEG、GIF、BMP、WEBP、TIFF、TIF、HEIC、HEIF、AVIF、ICNS
- 专业格式：RAW、CR2、CR3、NEF、ARW、ORF、DNG
- 软件格式：PSD、PDD、TGA、PCX、WMF、EMF、CUR、ICO、XBM、XPM
- 矢量格式：SVG、PDF、EPS、AI、CDR、SVGZ
- 其他格式：BPG、PBM、PGM、PPM、SGI、DWG、DXF、TFX、WBMP、CGM、VML

## 使用方法

1. **导入图片**：
   - 通过顶部工具栏的"导入"按钮
   - 或直接从系统拖拽图片到应用窗口

2. **调整参数**：
   - 在右侧参数面板调整亮度、对比度、旋转等参数
   - 实时预览会自动更新显示处理结果

3. **导出图片**：
   - 调整满意后点击顶部工具栏的"导出"按钮
   - 选择保存位置和文件名完成导出

## 技术栈

- Flutter
- desktop_drop: ^0.7.0
- image: 图片处理库
- provider: 状态管理
- flutter_hooks: 函数式组件支持

## 开发说明

此项目为macOS专用版本，已移除其他平台支持以优化性能和减少包大小。

## 构建

```bash
flutter run -d macos
```

## 注意事项

- 目前饱和度调整功能因image包版本差异暂时未实现
- 某些特殊格式（如专业RAW格式）可能需要额外的解码器支持