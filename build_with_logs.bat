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

REM Run CMake configure step
echo [CMAKE CONFIGURE] at %TIME%
cmake -DUSE_IPHYS=1 >> logs\cmake_generate_%NOW%.txt 2>&1

REM Build DLL target
echo [CMAKE BUILD - DLL TARGETS] at %TIME%
cmake --build . --config Release --target client_client --verbose > logs\build_client_client_%NOW%.txt 2>&1

echo [DONE] Build completed. Logs:
echo    CMake: logs\cmake_generate_%NOW%.txt
echo    Build: logs\build_client_client_%NOW%.txt

REM Extract error/warning counts from the build log
echo [SUMMARY]
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"^[ ]*[0-9][0-9]* [Ww]arning(s)" logs\build_client_client_%NOW%.txt') do echo %%A:%%B
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"^[ ]*[0-9][0-9]* [Ee]rror(s)" logs\build_client_client_%NOW%.txt') do echo %%A:%%B

REM ——————————————————————————————————————————————
REM  Extract raw errors, then run PS to clean them up
REM ——————————————————————————————————————————————

REM 2) invoke our PS parser with the updated path
powershell -NoProfile -ExecutionPolicy Bypass -File "build_fixes\scripts\extract_errors.ps1" ^
   -InputFile "logs\build_client_client_%NOW%.txt" ^
   -OutputFile "logs\build_errors_cleaned_%NOW%.txt"

REM 3) report back
if exist "logs\build_errors_cleaned_%NOW%.txt" (
  echo [ERROR DETAILS] cleaned output in logs\build_errors_cleaned_%NOW%.txt
) else (
  echo [ERROR DETAILS] parsing failed; check logs\build_client_client_%NOW%.txt and build_fixes\scripts\extract_errors.ps1
)

REM Report on mm_loadu_si64-specific issues
if exist "logs\mm_loadu_si64_issues.txt" (
  echo [INTRINSIC ERRORS] details in logs\mm_loadu_si64_issues.txt
) else (
  echo [INTRINSIC ERRORS] none found or parsing failed
)