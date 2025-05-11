# Building


## Requirements
- Latest CMAKE 3 `cmake-3.31.7-windows-x86_64.msi` is required. CMAKE `4` causes issues, and so does `3.28`.
- Visual Studio 2017 Build Tools
- VS2015 Build Tools extension for VS2017 through `Visual Studio Installer`


# Building With CMAKE

```bash
cd cmake-build
cmake .. ^
-DCMAKE_CXX_FLAGS="/DCRYPTOPP_DISABLE_ASM /DCRYPTOPP_DISABLE_SSE2" ^
-DCMAKE_CONFIGURATION_TYPES="Release;Debug" ^
-DZLIB_LIBRARY="../thirdparty/zlib-1.2.8/zlib.lib" ^
-DZLIB_INCLUDE_DIR="../thirdparty/zlib-1.2.8" ^
-DCMAKE_POLICY_VERSION_MINIMUM=3.5 ^
-G "Visual Studio 17 2022" ^
-T v140 -DCMAKE_GENERATOR_PLATFORM=x64

cmake --build .
```