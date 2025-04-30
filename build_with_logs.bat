@echo off
REM Create log folder if it doesn't exist
if not exist logs mkdir logs

REM Generate timestamp string
set NOW=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%
set NOW=%NOW: =0%

REM Run CMake generation step (Release mode + compiler flags + intrinsics fix via /FI)
echo [CMAKE GENERATE] at %TIME%
"C:\Program Files\CMake\bin\cmake.exe" -G "Visual Studio 17 2022" -T v140 ^
    -DCMAKE_CXX_FLAGS="/DCRYPTOPP_DISABLE_ASM /DCRYPTOPP_DISABLE_SSE2 /FIintrin_workarounds.h" ^
    -DCMAKE_CONFIGURATION_TYPES="Release" ^
    > logs\cmake_generate_%NOW%.txt 2>&1

REM Run CMake configure step
echo [CMAKE CONFIGURE] at %TIME%
cmake -DUSE_IPHYS=1 >> logs\cmake_generate_%NOW%.txt 2>&1

REM Run CMake build step in RELEASE mode (build key DLL targets with verbosity)
echo [CMAKE BUILD - DLL TARGETS] at %TIME%
cmake --build . --config Release --target client_client --verbose > logs\build_client_client_%NOW%.txt 2>&1

echo [DONE] Build completed. Log is at logs\cmake_generate_%NOW%.txt
