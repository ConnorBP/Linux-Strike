@echo off
REM Create log folder if it doesn't exist
if not exist logs mkdir logs

REM Generate timestamp string (safe for filenames)
set NOW=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%
set NOW=%NOW: =0%

REM Run CMake generation step
echo [CMAKE GENERATE] at %TIME%
(
  "C:\Program Files\CMake\bin\cmake.exe" -G "Visual Studio 17 2022" -T v140 ^
    -DCMAKE_CXX_FLAGS="/DCRYPTOPP_DISABLE_ASM /DCRYPTOPP_DISABLE_SSE2" ^
    -DCMAKE_CONFIGURATION_TYPES="Release" ^
    -DZLIB_LIBRARY="%CD%/thirdparty/zlib-1.2.8/zlib.lib" ^
    -DZLIB_INCLUDE_DIR="%CD%/thirdparty/zlib-1.2.8" ^
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
) > logs\cmake_generate_%NOW%.txt 2>&1

REM Run CMake configure step (optional; may not be needed if generation succeeds fully)
echo [CMAKE CONFIGURE] at %TIME%
cmake -DUSE_IPHYS=1 >> logs\cmake_generate_%NOW%.txt 2>&1

REM Build DLL target (with verbosity)
echo [CMAKE BUILD - DLL TARGETS] at %TIME%
cmake --build . --config Release --target client_client --verbose > logs\build_client_client_%NOW%.txt 2>&1

echo [DONE] Build completed. Logs:
echo    CMake: logs\cmake_generate_%NOW%.txt
echo    Build: logs\build_client_client_%NOW%.txt
