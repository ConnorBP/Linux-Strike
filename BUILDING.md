# Building

## Windows

### Prerequisites

- [DirectX9 June2010 SDK](https://www.microsoft.com/en-ca/download/details.aspx?id=6812) (not just the runtimes)
- [Cmake](https://cmake.org/download/) >= 3.15 && < 4 (recommended 3.29+)
- Visual Studio Community 2022
- Visual Studio 2015 Build Tools extension from visual studio installer for VS2022

### Build
```batch
REM first, change to the build directory
if not exist cmake-build mkdir cmake-build
cd cmake-build

REM configure the project
cmake .. ^
-DCMAKE_CXX_FLAGS="/DCRYPTOPP_DISABLE_ASM /DCRYPTOPP_DISABLE_SSE2" ^
-DCMAKE_CONFIGURATION_TYPES="Release;Debug" ^
-DZLIB_LIBRARY="./thirdparty/zlib-1.2.8/Release/zlib.lib" ^
-DZLIB_INCLUDE_DIR="../thirdparty/zlib-1.2.8" ^
-DCMAKE_POLICY_VERSION_MINIMUM=3.5 ^
-G "Visual Studio 17 2022" ^
-T v140 -DCMAKE_GENERATOR_PLATFORM=x64

REM and then build it
cmake --build . --config Release --verbose
```