@echo off
REM Create log folder if it doesn't exist
if not exist logs mkdir logs

REM Generate timestamp string
set NOW=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%
set NOW=%NOW: =0%

REM Run CMake generation step
echo [CMAKE GENERATE] at %TIME%
"C:\Program Files\CMake\bin\cmake.exe" -G "Visual Studio 17 2022" -T v140 ^
    -DCMAKE_CXX_FLAGS="/DCRYPTOPP_DISABLE_ASM /DCRYPTOPP_DISABLE_SSE2" ^
    > logs\cmake_generate_%NOW%.txt 2>&1

REM Run CMake configure step
echo [CMAKE CONFIGURE] at %TIME%
cmake -DUSE_IPHYS=1 >> logs\cmake_generate_%NOW%.txt 2>&1

REM Run CMake build step
echo [CMAKE BUILD] at %TIME%
cmake --build . >> logs\cmake_generate_%NOW%.txt 2>&1

echo [DONE] Build completed. Log is at logs\cmake_generate_%NOW%.txt