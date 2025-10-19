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

## Qt6.10.0 完整版本
1. Qt6.10.0 msvc2022_64
2. Qt6.10.0 MinGW1310_64               (使用Qt官方默认编译器版本)
3. Qt6.10.0 MinGW1520_64(UCRT)    
4. Qt6.10.0 LLVM-MinGW17.0.6(UCRT)     (使用Qt官方默认编译器版本)
5. Qt6.10.0 LLVM-MinGW21.1.3(UCRT)

## Qt6.10.0 RP版本
1. Qt6.10.0 msvc2022_64_RP
2. Qt6.10.0 MinGW1310_64_RP            (使用Qt官方默认编译器版本)
3. Qt6.10.0 MinGW1520_64_RP(UCRT)
4. Qt6.10.0 LLVM-MinGW17.0.6_RP(UCRT)  (使用Qt官方默认编译器版本)
5. Qt6.10.0 LLVM-MinGW21.1.3_RP(UCRT)

## Qt5.15.17 完整版本(64位)
1. Qt5.15.17 msvc2022_64     
2. Qt5.15.17 MinGW810_64              (使用Qt官方默认编译器版本)(此版本构建环境同小熊猫C++官方64位版本)

## Qt5.15.17 完整版本(32位)
1. Qt5.15.17 msvc2022_32     
2. Qt5.15.17 MinGW810_32              (使用Qt官方默认编译器版本)(此版本构建环境同小熊猫C++官方32位版本)

## Qt5.15.17 RP版本
1. Qt5.15.17 msvc2022_64_RP
2. Qt5.15.17 MinGW810_64_RP           (使用Qt官方默认编译器版本)

## Qt6.10.0 编译器
1. **msvc2022_64**：Visual Studio 2022 Developer Command Prompt v17.14.16
2. **mingw1310_64**：[13.1.0-202407240918mingw1310.7z](https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/tools_mingw1310/qt.tools.win64_mingw1310/13.1.0-202407240918mingw1310.7z) (Qt官方默认编译器版本)
3. **mingw1520_64_UCRT**：[x86_64-15.2.0-release-posix-seh-ucrt-rt_v13-rev0.7z](https://github.com/niXman/mingw-builds-binaries/releases/download/15.2.0-rt_v13-rev0/x86_64-15.2.0-release-posix-seh-ucrt-rt_v13-rev0.7z)
4. **llvm-mingw17.0.6_64_UCRT**：[17.0.6-202409091150llvm_mingw1706.7z](https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/tools_llvm_mingw1706/qt.tools.win64_llvm_mingw1706/17.0.6-202409091150llvm_mingw1706.7z)  (Qt官方默认编译器版本)
5. **llvm-mingw21.1.3_64_UCRT**：[llvm-mingw-20251007-ucrt-x86_64.zip](https://github.com/mstorsjo/llvm-mingw/releases/download/20251007/llvm-mingw-20251007-ucrt-x86_64.zip)

## Qt5.15.17 编译器
1. **msvc2022_64**：Visual Studio 2022 Developer Command Prompt v17.13.2
2. **mingw1420_64_UCRT**：[x86_64-14.2.0-release-posix-seh-ucrt-rt_v12-rev2.7z](https://github.com/niXman/mingw-builds-binaries/releases/download/14.2.0-rt_v12-rev2/x86_64-14.2.0-release-posix-seh-ucrt-rt_v12-rev2.7z)
3. **mingw1510_64_UCRT**：[x86_64-15.1.0-release-posix-seh-ucrt-rt_v12-rev0.7z](https://github.com/niXman/mingw-builds-binaries/releases/download/15.1.0-rt_v12-rev0/x86_64-15.1.0-release-posix-seh-ucrt-rt_v12-rev0.7z)
4. **mingw810_64**：[8.1.0-1-202411201005x86_64-8.1.0-gdb-11.2.0-release-posix-seh-rt_v6-rev0.7z](https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/tools_mingw81/qt.tools.win64_mingw810/8.1.0-1-202411201005x86_64-8.1.0-gdb-11.2.0-release-posix-seh-rt_v6-rev0.7z) (Qt官方默认编译器版本)
5. **mingw810_32**：[8.1.0-1-202411201005i686-8.1.0-gdb-11.2.0-release-posix-dwarf-rt_v6-rev0.7z](https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/tools_mingw81/qt.tools.win32_mingw810/8.1.0-1-202411201005i686-8.1.0-gdb-11.2.0-release-posix-dwarf-rt_v6-rev0.7z) (Qt官方默认编译器版本)

