project(shadercompile_dll)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
set(OUTBINDIR ${SRCDIR}/../game/bin)

set(SRCDIR "${CMAKE_SOURCE_DIR}")

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
set(OUTBINNAME "shadercompile_dll")

# make a dll target
include(${CMAKE_MODULE_PATH}/source_dll_base.cmake)

# if(NOT TARGET vmpi_external_lib) # Define only if it doesn't exist yet
#     add_library(vmpi_external_lib STATIC IMPORTED)
#     set_target_properties(vmpi_external_lib PROPERTIES
#         IMPORTED_LOCATION "${SRCDIR}/lib/public/vmpi.lib"  # Full path to vmpi.lib
#     )
#     # If VMPI has public headers that shadercompile_dll needs, and they are not already covered
#     # by other include_directories, you can specify them here for the imported target:
#     # target_include_directories(vmpi_external_lib INTERFACE "${SRCDIR}/utils/vmpi") # Assuming vmpi.h is in utils/vmpi
# endif()
target_sources(${OUTBINNAME} PRIVATE
    ../common/cmdlib.cpp
    cmdsink.cpp
    d3dxfxc.cpp
    "${SRCDIR}/public/filesystem_helpers.cpp"
    "${SRCDIR}/public/filesystem_init.cpp"
    ../common/pacifier.cpp
    shadercompile.cpp
    shadercompile_ps3_helpers.cpp
    subprocess.cpp
    cfgprocessor.cpp
    ../common/threads.cpp
    ../common/vmpi_tools_shared.cpp
    ../common/tools_minidump.cpp
)

# Optional: Force include platform.h if not handled by other includes
# if( WINDOWS OR POSIX )
#     target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/tier0/platform.h")
# endif()


# Add include directories
target_include_directories(${OUTBINNAME} PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}"        # For headers in the current directory (shadercompile.h, etc.)
    "${CMAKE_CURRENT_SOURCE_DIR}/../common" # From $AdditionalIncludeDirectories
    "${CMAKE_CURRENT_SOURCE_DIR}/../vmpi"   # From $AdditionalIncludeDirectories
    "${SRCDIR}/dx9sdk/include"           # From $AdditionalIncludeDirectories
    "${SRCDIR}/public"                   # Common public headers
    "${SRCDIR}/common"                   # Common headers
)

# Add preprocessor definitions
target_compile_definitions(${OUTBINNAME} PRIVATE
    SHADERCOMPILE_EXPORTS # From $PreprocessorDefinitions
    MPI                   # From $PreprocessorDefinitions
    # Add definitions from source_dll_win32_base.vpc (e.g., DLL_EXPORT if this lib exports symbols)
    # For a DLL that exports symbols, you'd typically have a define like PROJECTNAME_EXPORTS
    # and use __declspec(dllexport/dllimport) in headers.
    # If SHADERCOMPILE_EXPORTS is used for that, it's covered.
)

# --- LZMA Handling ---
if(NOT TARGET lzma_imported)
    add_library(lzma_imported STATIC IMPORTED GLOBAL) # Or SHARED if it's a DLL
    set_target_properties(lzma_imported PROPERTIES
        IMPORTED_LOCATION "${SRCDIR}/lib/common/vc8/lzma.lib"
        # INTERFACE_INCLUDE_DIRECTORIES "${SRCDIR}/path/to/lzma/includes" # If needed
    )
endif()
# --- End LZMA Handling ---

if( WINDOWS )
    set(SHADERCOMPILE_ENGINE_LIBS
        libtier0
        tier1
        tier2
        vstdlib
    )
else()
set(SHADERCOMPILE_ENGINE_LIBS
    libtier0_client
    tier1_client
    tier2_client
    vstdlib_client
)
endif()

target_link_libraries(${OUTBINNAME} PRIVATE
    vmpi
    ${SHADERCOMPILE_ENGINE_LIBS}
    lzma_imported
    ws2_32
    odbc32
    odbccp32
)


# if(MSVC)
#     target_compile_options(${OUTBINNAME} PRIVATE "/arch:SSE2")
# endif()