# buildRedPanda-CPP 从源代码自动构建小熊猫C++

## 说明
1. 本项目的主要目的是从Github上最新的源代码构建小熊猫C++(使用GithubActions自动构建)
2. 目前主要构建`Windows版本`(使用`MSVC`、`MinGW64`、`LLVM-MinGW`三大编译器)
2. 目前主要使用开源版本的Qt5、Qt6版本构建

## 仓库地址
1. 本仓库地址: https://github.com/yuanpeirong/buildRedPanda-CPP
2. 小熊猫C++仓库地址: https://github.com/royqh1979/RedPanda-CPP
3. 目前使用的Qt二进制版本来源: https://github.com/yuanpeirong/buildQt

## 版本说明
1. 无"RP"版本：使用的Qt为从完整源代码构建，构建绝大部分组件
2. 有"RP"版本：使用的Qt为从Qt组件源代码构建，目前只构建qtbase、qttools、qttranslations、qtsvg共4个组件
3. 理论上，两者构建的小熊猫C++二进制文件无差异

## Qt6.12.0 完整版本
1. Qt6.12.0 msvc2022_64
2. Qt6.12.0 msvc2026_64
3. Qt6.12.0 MinGW1510_64              (使用Qt6.12官方默认编译器版本)
4. Qt6.12.0 MinGW1620_64(UCRT)
5. Qt6.12.0 LLVM-MinGW22.1.7(UCRT)     (使用Qt6.12官方默认编译器版本)
6. Qt6.12.0 LLVM-MinGW23.1.5(UCRT)

## Qt6.12.0 RP版本
1. Qt6.12.0 msvc2022_64_RP
2. Qt6.12.0 msvc2026_64_RP
3. Qt6.12.0 MinGW1510_64_RP            (使用Qt6.12官方默认编译器版本)
4. Qt6.12.0 MinGW1620_64_RP(UCRT)
5. Qt6.12.0 LLVM-MinGW22.1.7_RP(UCRT)  (使用Qt6.12官方默认编译器版本)
6. Qt6.12.0 LLVM-MinGW23.1.5_RP(UCRT)

## Qt5.15.19 完整版本(64位)
1. Qt5.15.19 msvc2022_64
2. Qt5.15.19 msvc2026_64
3. Qt5.15.19 MinGW810_64              (使用Qt5.15官方默认编译器版本)
4. Qt5.15.19 MinGW810_1620_64         (Qt5.15使用官方默认编译器构建+小熊猫C++使用最新MinGW64构建)
5. Qt5.15.19 MinGW1620_64(UCRT)

## Qt5.15.19 完整版本(32位)
1. Qt5.15.19 msvc2022_32
2. Qt5.15.19 MinGW810_32              (使用Qt5.15官方默认编译器版本)
3. Qt5.15.19 MinGW810_1620_32         (Qt5.15使用官方默认编译器构建+小熊猫C++使用最新MinGW64构建)

## Qt5.15.19 RP版本(64位)
1. Qt5.15.19 msvc2022_64_RP
2. Qt5.15.19 msvc2026_64_RP
3. Qt5.15.19 MinGW810_64_RP            (使用Qt5.15官方默认编译器版本)
4. Qt5.15.19 MinGW810_1620_64_RP       (Qt5.15使用官方默认编译器构建+小熊猫C++使用最新MinGW64构建)
5. Qt5.15.19 MinGW1620_64_RP(UCRT)

## Qt5.15.19 RP版本(32位)
1. Qt5.15.19 MinGW810_32_RP            (使用Qt5.15官方默认编译器版本)
2. Qt5.15.19 MinGW810_1620_32_RP       (Qt5.15使用官方默认编译器构建+小熊猫C++使用最新MinGW64构建)

## Qt6.12.0 编译器
1. **msvc2022_64**：Visual Studio 2022 Developer Command Prompt v17.14.44
2. **msvc2026_64**：Visual Studio 2026 Developer Command Prompt v18.11.3
3. **mingw1510_64**：[15.1.0-202610271023mingw1510.7z](https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/tools_mingw1510/qt.tools.win64_mingw1510/15.1.0-202610271023mingw1510.7z) (Qt6.12官方默认编译器版本)
4. **mingw1620_64_UCRT**：[x86_64-16.2.0-release-posix-seh-ucrt-rt_v14-rev1.7z](https://github.com/niXman/mingw-builds-binaries/releases/download/16.2.0-rt_v14-rev1/x86_64-16.2.0-release-posix-seh-ucrt-rt_v14-rev1.7z)
5. **llvm-mingw22.1.7_64_UCRT**：[22.1.7-202608200704llvm_mingw2217.7z](https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/tools_llvm_mingw2217/qt.tools.win64_llvm_mingw2217/22.1.7-202608200704llvm_mingw2217.7z)  (Qt6.12官方默认编译器版本)
6. **llvm-mingw23.1.5_64_UCRT**：[llvm-mingw-20261104-ucrt-x86_64.zip](https://github.com/mstorsjo/llvm-mingw/releases/download/20261104/llvm-mingw-20261104-ucrt-x86_64.zip)

## Qt5.15.19 编译器
1. **msvc2022_64**：Visual Studio 2022 Developer Command Prompt v17.14.33
2. **msvc2026_64**：Visual Studio 2026 Developer Command Prompt v18.6.2
3. **mingw810_64**：[8.1.0-1-202411201005x86_64-8.1.0-gdb-11.2.0-release-posix-seh-rt_v6-rev0.7z](https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/tools_mingw81/qt.tools.win64_mingw810/8.1.0-1-202411201005x86_64-8.1.0-gdb-11.2.0-release-posix-seh-rt_v6-rev0.7z) (Qt5.15官方默认编译器版本)
4. **mingw810_32**：[8.1.0-1-202411201005i686-8.1.0-gdb-11.2.0-release-posix-dwarf-rt_v6-rev0.7z](https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/tools_mingw81/qt.tools.win32_mingw810/8.1.0-1-202411201005i686-8.1.0-gdb-11.2.0-release-posix-dwarf-rt_v6-rev0.7z) (Qt5.15官方默认编译器版本)
5. **mingw1620_64_UCRT**：[x86_64-16.2.0-release-posix-seh-ucrt-rt_v14-rev1.7z](https://github.com/niXman/mingw-builds-binaries/releases/download/16.2.0-rt_v14-rev1/x86_64-16.2.0-release-posix-seh-ucrt-rt_v14-rev1.7z)
6. **mingw1630_64**：[x86_64-16.2.0-release-posix-seh-msvcrt-rt_v14-rev1.7z](https://github.com/niXman/mingw-builds-binaries/releases/download/16.2.0-rt_v14-rev1/x86_64-16.2.0-release-posix-seh-msvcrt-rt_v14-rev1.7z)
7. **mingw1630_32**：[i686-16.2.0-release-posix-dwarf-msvcrt-rt_v14-rev1.7z](https://github.com/niXman/mingw-builds-binaries/releases/download/16.2.0-rt_v14-rev1/i686-16.2.0-release-posix-dwarf-msvcrt-rt_v14-rev1.7z)
