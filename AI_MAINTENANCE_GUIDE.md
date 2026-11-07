# buildRedPanda-CPP AI 维护指南

> 本文档面向后续参与本项目的 AI 助手（以及人类维护者），沉淀本仓库的构建链路、约定与升级流程。
> **与姊妹仓库的关系**：本仓库使用 [buildQt](https://github.com/yuanpeirong/buildQt) 构建发布的 Qt 静态库来编译 [小熊猫C++（RedPanda-CPP）](https://github.com/royqh1979/RedPanda-CPP)。buildQt 仓库根目录另有一份 `AI_MAINTENANCE_GUIDE.md`，涉及 Qt 源码构建、工具链包结构、libc++ 23 补丁等上游知识时请先查阅该文档。
> 最后验证：2026-11，main 分支「更新至6.12.0」。

---

## 1. 项目概述

- **定位**：CI 仓库，不含应用源码——运行时 `git clone` 上游 RedPanda-CPP（master 分支），配合 buildQt 发布的 Qt 静态库，产出小熊猫C++ 的 Windows 安装目录包（7z → Actions Artifacts）。
- **构建系统**：上游 RedPanda-CPP 是 CMake 项目，本仓库用 **CMake + Ninja**（`-S/-B → --build --parallel → --install --strip`），Qt 静态库链接（`-DCMAKE_EXE_LINKER_FLAGS="-static"`），MSVC 线另加静态 CRT（`-DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded"`）。
- **触发方式**：全部 `workflow_dispatch` 手动触发（无 push/PR/schedule/事件联动）。

## 2. 上下游资产命名链（本仓库的核心约定，改错任何一环构建即失败）

| 环节 | 命名 | 说明 |
|------|------|------|
| buildQt 工作流产物流 | `Qt_<QT_VERSION>-static-Release_<编译器代号>[_RP].7z` | FILE_NAME 约定，与 buildQt 仓库完全一致 |
| buildQt 正式 Release tag | `Qt<QT_VERSION>_rev<N>`（当前为 `_rev0`） | 工作流自动发的是 temp release；buildQt 的 `promote-release.yml`（手动触发）可自动归集为正式 tag 供本仓库引用 |
| 本仓库下载 URL | `https://github.com/yuanpeirong/buildQt/releases/download/Qt<版本>_rev0/Qt_<版本>-static-Release_<编译器代号>[_RP].7z` | Setup 步骤内**按命名约定从 matrix 值直接拼接**（不再写 if 分支映射；810 混搭线多一行 `_1620→810` 资产名映射）；资产不存在时 `curl --fail` 立即报错 |
| Qt.7z 解压后结构 | `<QT_VERSION>-static\<编译器代号>[_RP]\bin\...` | 包内顶层就是 `<版本>-static\`，解压到 runner 根目录即得此结构（与 buildQt 的 INSTALL_DIR 一致） |
| 本仓库产物 | `RedPanda-CPP-Qt<版本>-static-<编译器代号>[_RP].7z` | upload-artifact 上传（本仓库不直接发 GitHub Release） |

## 3. 工作流与构建矩阵一览（7 个 yml）

各 yml 用 `strategy.matrix` 一个文件覆盖多组合：`qt_version × qt_type(固定 static) × compiler_version × qt_rp`，用 `exclude` 排除不存在的组合。**以各 yml 的 matrix 段为准**：

| 工作流 | runner | 覆盖目标 |
|--------|--------|---------|
| `MSVC2022.yml` | windows-2022 | msvc2022_64（Qt 5.15.19 与 6.12.0，完整+RP）+ msvc2022_32（仅 Qt 5.15.19 完整版，exclude 掉其余） |
| `MSVC2026.yml` | 同 MSVC2022 模式 | msvc2026_64 / msvc2026_64_RP |
| `LLVM-MinGW.yml` | windows-latest | Qt 6.12.0 × {llvm-mingw22.1.7_64_UCRT, llvm-mingw23.1.5_64_UCRT} × {完整, RP}（4 组合） |
| `MinGW64.yml` | windows-latest | mingw1620_64_UCRT 线（Qt 6.12.0 与 Qt 5.15.19） |
| `MinGW810_Update_Qt5.15.19.yml` | windows-latest | **混搭线**：Qt 5.15.19 用官方 mingw810 构建 + 小熊猫C++ 用 mingw1620（MSVCRT）编译，产物名 `mingw810_1620_32/64` |
| `MinGW810_64_Qt5.15.19_RP.yml` / `MinGW810_32_Qt5.15.19_RP.yml` | — | Qt 5.15.19 RP 的官方 mingw810_64 / 810_32 线 |

编译器来源（与 buildQt 同源，详见 buildQt 的 AI_MAINTENANCE_GUIDE §1.1）：
- **Qt 官方**：llvm-mingw 22.1.7（`tools_llvm_mingw2217`）、MinGW 15.1.0（`tools_mingw1510`）、mingw 8.1.0（`tools_mingw81`，Qt 5.15 官方默认）
- **社区**：llvm-mingw 23.1.5（mstorsjo）、mingw-builds 16.2.0-rt_v14-rev1（niXman，UCRT 与 MSVCRT 两种变体）
- **Runner 自带**：MSVC（setup-msbuild + vsdevenv 进入 VS 环境）

## 4. 构建流程（每个工作流固定 5 步）与 CI 目录布局

```
① checkout 本仓库（actions/checkout@v7）
② git clone https://github.com/royqh1979/RedPanda-CPP.git（上游 master，不 pin 版本）
③ Setup Compiler and Qt（pwsh）：按 matrix 组合下载编译器包 + 对应 Qt.7z 并解压
④ Build（cmd）：set 四个变量后 call build\<线名>.cmd，内部 cmake 构建
⑤ Package binaries：7z 打包产物 → actions/upload-artifact@v7
```

CI 目录布局（`D:\a\buildRedPanda-CPP\` 为根）：

```
buildRedPanda-CPP\                  仓库检出目录（build\*.cmd 的调用起点）
RedPanda-CPP\                       上游源码（git clone，SRC_DIR）
build\                              cmake 构建目录（BUILD_DIR，固定名）
Tools\llvm-mingw2217_64\bin         Qt 官方 llvm-mingw 22.1.7（7z 解压到此）
llvm-mingw-20261104-ucrt-x86_64\bin 社区 llvm-mingw（zip 顶层同名目录）
mingw64\ / mingw32\                 mingw-builds zip 解压顶层（msvcrt 变体）
<版本>-static\<编译器代号>[_RP]\bin  解压后的 Qt 静态库
RedPanda-CPP-Qt<版本>-static-<编译器代号>[_RP]\  产物目录（INSTALL_DIR，整目录打包）
```

> ⚠️ 编译器 7z/zip 包的内部结构各不相同（官方新版 llvm-mingw2217/mingw1510 的 7z **顶层直接是 bin**、社区 llvm-mingw zip 顶层带同名目录、mingw-builds zip 顶层是 `mingw64/` 或 `mingw32/`），解压 `-o` 目标与 cmd 里 PATH 的硬编码目录名一一对应——改编译器版本时两处必须同步（详见 buildQt 指南 §5.3）。

## 5. cmd 脚本约定（build\ 下与工作流对应）

- **4 个位置参数**：`%1=QT_VERSION`、`%2=QT_TYPE`(static)、`%3=COMPILER_VERSION`、`%4=QT_RP`("" 或 `_RP`)，由工作流的 cmd 步骤 `set` 后 `call` 传入。
- **PATH 约定**：第一段永远是 Qt 静态库 bin（`D:\a\buildRedPanda-CPP\%QT_VERSION%-%QT_TYPE%\%COMPILER_VERSION%%QT_RP%\bin`），后段并联本线编译器的 bin（编译 RedPanda-CPP 本身用）。**各 cmd 的后段是硬编码**（如 `LLVM-MinGW.cmd` 的 `LLVM-MINGW_VERSION=llvm-mingw-20261104-ucrt-x86_64`、`Tools\llvm-mingw2217_64`；`MinGW64.cmd` 的 `mingw64\bin`、`Tools\mingw1510_64\bin`、`mingw32\bin`）——升级编译器时必须同步改。
- **混搭线原理**（MinGW810_Update）：Qt 静态库（mingw810/MSVCRT 构建）与编译应用的新编译器（mingw1620/MSVCRT）ABI 兼容即可，靠 PATH 段顺序实现「Qt 头/库来自 8.1.0 构建、编译器用 16.2.0」。
- **MSVC 线特殊性**：`VsDevCmd.bat -arch=amd64|x86` 进入环境；`-DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded"`（静态 CRT）；`VS_INSTALL_PATH` 硬编码为 `C:\Program Files\Microsoft Visual Studio\2022\Enterprise`（**runner 镜像换 VS 版本/路径时需更新**，MSVC2026.cmd 同理）。
- 通用三连：`cmake -S "%SRC_DIR%" -B "%BUILD_DIR%" -G Ninja ... -DCMAKE_EXE_LINKER_FLAGS="-static"` → `cmake --build %BUILD_DIR% --parallel` → `cmake --install %BUILD_DIR% --strip`。末尾 windeployqt 为注释（仅动态 Qt 场景）。

## 6. 版本升级 SOP（buildQt 发布新 Qt 版本后）

1. **前置确认**：buildQt 侧已完成新版本全线编译，正式 Release（tag `Qt<新版本>_rev0`，含本仓库需要的全部 `Qt_<新版本>-static-Release_<编译器代号>[_RP].7z`）已就绪——可让 buildQt 跑一次 `promote-release.yml` 自动归集 temp release，或按其原流程人工整理。完成后在 Actions 页手动触发本仓库工作流。
2. **更新 matrix**：各 yml 的 `qt_version` 换成/新增新版本；`exclude` 段同步调整。（Qt 下载 URL 按命名约定自动拼接，**无需再维护 if 分支**；仅 810 混搭线保留一行资产名映射。）
3. **更新 cmd 硬编码**：涉及编译器升级的 cmd（`LLVM-MINGW_VERSION`、`Tools\*` 路径等）同步修改；新增编译器线则参照现有线复制 yml+cmd。
4. **先跑 RP 组合**（matrix 里 `_RP`）验证，通过后再跑完整版。
5. 通过后更新 `README.md` 版本矩阵（只记录已验证的组合）与 `HistoricalVersions.md`（旧版本挪入）。
6. 提交、合并 main。

## 7. GitHub Actions 组件（已与 buildQt 对齐，2026-11 验证）

| 组件 | 本仓库 | 说明 |
|------|--------|------|
| `actions/checkout` | v7 | 本仓库全 workflow_dispatch，v7 的 fork PR 保护不影响 |
| `microsoft/setup-msbuild` | v3 | 仅 MSVC2022 / MSVC2026 工作流使用（x86/x64 各一处） |
| `actions/upload-artifact` | v7 | |
| `seanmiddleditch/gha-setup-vsdevenv` | @master | 滚动跟随 |

> 升级 major 前先查各 Action 的 release notes（输入参数是否变化、Node 运行时要求）；避免使用跑在已弃用 Node 20 运行时上的旧 major（GitHub 分阶段停用后会整体失败）。

## 8. 注意事项与已知坑

1. **上游不 pin 版本**：`git clone` RedPanda-CPP 的 master——上游推送即改变构建内容（产品定位如此：始终构建最新）。若遇上游构建失败，先确认是不是上游代码问题再查本仓库；如需可复现构建可改为 `git clone --branch <tag>`。
2. **Qt.7z 解压位置强耦合**：直接 `-oD:\a\buildRedPanda-CPP` 依赖 buildQt 包内顶层为 `<版本>-static\` 的结构约定——buildQt 侧调整打包结构必须同步本仓库。
3. **cmd 硬编码目录名与编译器包结构强耦合**：见 §4 末尾警告与 buildQt 指南 §5.3。
4. **产物只上传 Artifacts，不发 Release**：本仓库的临时发布 tag 是固定的（`temp_RedPanda-CPP-Qt<版本>-...`），重复运行会 tag/资产冲突，故**不做 GitHub Release**（与 buildQt 不同——buildQt 一线一 temp tag 且低频运行、由人工清理）；产物在 Actions 运行页下载（90 天保留期）。
5. **runner 与 MSVC 版本**：MSVC 线的 `VS_INSTALL_PATH` 与镜像 VS 版本绑定（windows-2022 镜像 → VS2022 Enterprise；MSVC2026 线注意其 runner 对应镜像的 VS2026 安装路径），镜像更新可能改变路径。
6. Qt 5.15.19 为 Qt 官方终版，相关线基本冻结；Qt 6 线随 buildQt 演进。

## 9. 历史快照

| 时间 | 内容 |
|------|------|
| 2026-11 | 加固改造（main-new 分支）：curl 加固；Qt 下载从 if 分支墙改为命名约定拼接；cmd 加门禁与 RedPandaIDE.exe 产物校验；工作流保持纯手动触发（产物保持仅 Artifacts，不做 Release——重复运行 tag 冲突） |
| 2026-11 | GitHub Actions 组件对齐 buildQt：checkout v7 / setup-msbuild v3 / upload-artifact v7（vsdevenv@master 不变） |
| 2026-11-06 | 更新至 Qt 6.12.0（matrix 换版 + buildQt `Qt6.12.0_rev0` 资产对接） |
| 2026-08-22 | 更新至 Qt 6.11.2 |
| 2026-08-18 | MinGW64 升级 16.2.0-rt_v14-rev1（含对应 Qt 版本） |
| 2026-07-16 | 工作流拆分/重整（MinGW64_LLVM-MinGW 拆为 LLVM-MinGW.yml；新增 mingw810_32 RP；路径说明修正等） |

---

*本文档由构建链路分析沉淀，如与实际仓库状态不符，以仓库为准并更新本文档。*
