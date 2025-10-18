@chcp 65001
@cd /d %~dp0

:: 设置Qt版本
SET QT_VERSION=%1
SET QT_TYPE=%2
SET QT_RP=%4

:: 设置MinGW版本代号
SET MinGW_VERSION=%3

:: 设置Qt路径和编译器路径
set PATH=D:\a\buildRedPanda-CPP\%QT_VERSION%-%QT_TYPE%\%MinGW_VERSION%%QT_RP%\bin;D:\a\buildRedPanda-CPP\Tools\llvm-mingw1706_64\bin;%PATH%

:: 设置源代码路径、build文件夹路径、安装文件夹路径(即使路径含空格也不加引号)
set SRC_DIR=D:\a\buildRedPanda-CPP\RedPanda-CPP
set BUILD_DIR=D:\a\buildRedPanda-CPP\build
set INSTALL_DIR=D:\a\buildRedPanda-CPP\RedPanda-CPP-Qt%QT_VERSION%-%QT_TYPE%-%MinGW_VERSION%%QT_RP%

:: 创建并定位到构建目录：
mkdir "%BUILD_DIR%" && cd /d "%BUILD_DIR%"

:: 配置、构建、安装。对于 MinGW 工具链：
qmake PREFIX="%INSTALL_DIR%" "%SRC_DIR%\Red_Panda_CPP.pro"
mingw32-make -j%NUMBER_OF_PROCESSORS%
mingw32-make install
:: windeployqt "%INSTALL_DIR%\RedPandaIDE.exe"
