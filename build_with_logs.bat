
@ECHO OFF
REM Generate timestamp string
set NOW=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%
set NOW=%NOW: =0%
set "PROJECT_ROOT_DIR=%CD%"

echo [INFO] Build started at %NOW%

REM change to the build directory
if not exist cmake-build mkdir cmake-build
cd cmake-build

REM Create log folder if it doesn't exist
if not exist logs mkdir logs

REM --- FIX PATHS FOR WINDOWS BUILDS ---
REM --- Convert paths to use forward slashes ---
set "BUILD_DIR_BASE=%CD%"
set "ZLIB_SUBDIR=thirdparty/zlib-1.2.8"

@REM set "ZLIB_INCLUDE_DIR_ABS=%TOP_SOURCE_DIR%\%ZLIB_SUBDIR%"
@REM set "ZLIB_INCLUDE_DIR_CMAKE=%ZLIB_INCLUDE_DIR_ABS:\=/%"
@REM echo using zlib at: %ZLIB_INCLUDE_DIR_CMAKE%
set "ZLIB_LIBRARY_ABS=%BUILD_DIR_BASE%\%ZLIB_SUBDIR%\Release\zlib.lib"
set "ZLIB_LIBRARY_CMAKE=%ZLIB_LIBRARY_ABS:\=/%"
REM --- End path conversion ---

cmake .. ^
  -DUSE_IPHYS=1 ^
  -DCMAKE_CXX_FLAGS="/DCRYPTOPP_DISABLE_ASM /DCRYPTOPP_DISABLE_SSE2" ^
  -DCMAKE_CONFIGURATION_TYPES="Release;Debug" ^
  -DZLIB_LIBRARY="%ZLIB_LIBRARY_CMAKE%" ^
  -DZLIB_INCLUDE_DIR="../thirdparty/zlib-1.2.8" ^
  -DCMAKE_POLICY_VERSION_MINIMUM=3.5 ^
  -G "Visual Studio 17 2022" ^
  -T v140 -DCMAKE_GENERATOR_PLATFORM=x64 > logs\cmake_generate_%NOW%.txt 2>&1

cmake --build . --config Release --verbose > logs\build_client_client_%NOW%.txt 2>&1

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
powershell -NoProfile -ExecutionPolicy Bypass -File "..\build_fixes\scripts\extract_errors.ps1" ^
   -InputFile "logs\build_client_client_%NOW%.txt" ^
   -OutputFile "logs\build_errors_cleaned_%NOW%.txt"

REM 3) report back
if exist "logs\build_errors_cleaned_%NOW%.txt" (
  echo [ERROR DETAILS] cleaned output in logs\build_errors_cleaned_%NOW%.txt
) else (
  echo [ERROR DETAILS] parsing failed; check logs\build_client_client_%NOW%.txt and ..\build_fixes\scripts\extract_errors.ps1
)

REM Report on mm_loadu_si64-specific issues
if exist "logs\mm_loadu_si64_issues.txt" (
  echo [INTRINSIC ERRORS] details in logs\mm_loadu_si64_issues.txt
) else (
  echo [INTRINSIC ERRORS] none found or parsing failed
)


set NOW=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%
set NOW=%NOW: =0%

echo [INFO] Build finished at %NOW%

REM return to the original directory
cd %PROJECT_ROOT_DIR%
REM pause