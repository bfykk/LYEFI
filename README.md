# LYEFI

**面向普通用户的 OpenCore EFI 配置、自动生成与后期维护工具**

> **来源与许可**：LYEFI 基于 [JeoJay127/RapidEFI-Tool](https://github.com/JeoJay127/RapidEFI-Tool) 的源代码修改而来（导入日期 2026-11-25，品牌改造日期 2026-11-25），遵循 **GNU AGPL-3.0**，原作者版权归 JeoJay127 所有。修改后的完整源码同样以 AGPL-3.0 公开于本仓库。

## 这是什么

LYEFI 把 OpenCore 的配置流程整理成可视化、可检查、可继续维护的操作：手动配置 EFI、根据硬件信息自动生成 EFI、查看 macOS 兼容性、定制 SSDT，并在后续继续加工和维护已经生成的 EFI。

配置逻辑遵循 OpenCore 官方文档与 Dortania OpenCore 安装指南。

> 不能保证所有硬件都能一次成功启动 macOS。生成结果适合作为基础配置，不等于免调试配置。输出 EFI 后请先用备用 U 盘测试启动，不要直接覆盖正在稳定使用的 EFI，并提前备份重要数据。

## 核心功能

| 功能入口 | 主要用途 |
| --- | --- |
| 手动配置 EFI | 自主选择平台、驱动、启动参数、显卡、声卡、网络等配置 |
| 硬件信息 | 查看硬件信息、macOS 兼容性提示、导出硬件报告和 ACPI 表 |
| 自动配置 EFI | 根据硬件信息自动生成 EFI |
| 加工 EFI | 导入 `configModel` 再次调整已生成的 EFI |
| 历史记录 | 回看、对比、再导出历次生成的 EFI |
| 定制 SSDT | 生成常见 SSDT 补丁，处理设备屏蔽、显卡仿冒、亮度、声卡等问题 |
| OCLP-X 补丁 | 查看显卡、WiFi 等 OCLP 相关补丁说明 |
| macOS Tahoe 26 | 查看 Tahoe 相关注意事项与配置提示 |

- 核心能力全部内置在本地，**离线可用**，不依赖网络（仅“检查更新”会访问 GitHub）。
- 每次成功生成 EFI 后自动保存历史记录，并在输出目录写入 `configModel` 便于二次加工。

## 支持范围

- **macOS 版本**：High Sierra 10.13 ~ Tahoe 26
- **系统环境**：Windows 10+（推荐，硬件采集最完整）、macOS 10.15+、Debian 10+ / Ubuntu 20.04–24.04
- **平台**：Intel 0~15 代（笔记本 0~10 代，11 代起核显无法驱动）、AMD Bulldozer/Jaguar、Ryzen、Threadripper；台式机 / 笔记本 / NUC / HEDT

## 从源码构建

需要 Flutter SDK（Dart `>=3.2.3 <4.0`）。

```bash
flutter pub get
flutter build windows --release    # 或 macos / linux
```

产物在 `build/windows/x64/runner/Release/`，可执行文件名为 `LYEFI.exe`。

## 目录结构

```
lib/
  main.dart                  入口（初始化、窗口、路由）
  application/app.dart       应用外壳、导航、主题
  pages/                     各功能页面
  config/                    ConfigModel、配置服务、构建流水线（规则引擎 / 资源规划 / 导出）
  hardware/                  硬件采集、兼容性判断、平台与 SMBIOS 推荐
  ssdttool/                  ACPI 解析与 SSDT 定制引擎
  update/                    检查更新（GitHub Releases）
assets/                      内置 OpenCore、kexts、ACPI、SSDT、主题等离线资源
```

## 许可证

GNU Affero General Public License v3.0，见 [LICENSE](LICENSE)。

依据 AGPL-3.0：修改后的作品对外分发时必须以同一许可证公开完整源码，并显著标注修改内容与日期；若以网络服务形式提供，需向使用者提供获取源码的方式。`assets/` 内的 OpenCore、kext（Lilu、WhateverGreen 等）分别遵循其各自项目的许可证。

## 致谢

OpenCore、Acidanthera、Dortania、OCLP、AMD-OSX、zxystd、ChefKiss 等开源项目与文档，以及 RapidEFI 原作者 JeoJay127 与上游社区的大量实践经验。
