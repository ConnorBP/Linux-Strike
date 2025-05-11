cmake_minimum_required(VERSION 3.16)
project(vstdlib_client)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
set(OUTBINNAME "vstdlib_client")
set(OUTBINDIR ${SRCDIR}/../game/bin)
set(NOSKELETONBASE "1")

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
include(${CMAKE_MODULE_PATH}/source_dll_base.cmake)

if(MSVC AND (CMAKE_GENERATOR_PLATFORM STREQUAL "x64" OR CMAKE_GENERATOR_PLATFORM STREQUAL "WIN64" OR CMAKE_SIZEOF_VOID_P EQUAL 8))
	ENABLE_LANGUAGE(ASM_MASM)
endif()

add_definitions(-DVSTDLIB_DLL_EXPORT)

if( LINUXALL )
    target_compile_options(${OUTBINNAME} PRIVATE -U_FORTIFY_SOURCE -fno-stack-protector -fpic -fno-semantic-interposition)
endif()

target_sources(${OUTBINNAME} PRIVATE "concommandhash.h")
if( NOT X360 )
    target_sources(${OUTBINNAME} PRIVATE "coroutine.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "cvar.cpp")
target_sources(${OUTBINNAME} PRIVATE "jobthread.cpp")
target_sources(${OUTBINNAME} PRIVATE "keyvaluessystem.cpp")
if( WIN32 OR WIN64 )
	target_sources(${OUTBINNAME} PRIVATE "processutils.cpp")
endif()

# if(MSVC AND (CMAKE_GENERATOR_PLATFORM STREQUAL "x64" OR CMAKE_GENERATOR_PLATFORM STREQUAL "WIN64" OR CMAKE_SIZEOF_VOID_P EQUAL 8))
#     message(STATUS "Enabling MASM for vstdlib_client (64-bit MSVC)")
#     enable_language(ASM_MASM)
#     target_sources(${OUTBINNAME} PRIVATE "getstackptr64.asm")
# 	set_source_files_properties("getstackptr64.asm" PROPERTIES COMPILE_FLAGS "/D_M_X64")
# else()
#     if(MSVC)
#         message(STATUS "MASM not enabled for vstdlib_client: CMAKE_GENERATOR_PLATFORM=${CMAKE_GENERATOR_PLATFORM}, CMAKE_SIZEOF_VOID_P=${CMAKE_SIZEOF_VOID_P}")
#     else()
#         message(STATUS "MASM not enabled on non MSVC compiler.")
#     endif()
# endif()

if(MSVC AND (CMAKE_GENERATOR_PLATFORM STREQUAL "x64" OR CMAKE_GENERATOR_PLATFORM STREQUAL "WIN64" OR CMAKE_SIZEOF_VOID_P EQUAL 8))
    message(STATUS "Configuring ASM support for vstdlib_client (64-bit MSVC)")
    enable_language(ASM_MASM) # Still enable it globally for the project if other .asm might appear

    # Create a separate static library for the .asm file
    add_library(vstdlib_asm_utils STATIC "getstackptr64.asm")
    set_source_files_properties("getstackptr64.asm" PROPERTIES LANGUAGE ASM_MASM)
    set_target_properties(vstdlib_asm_utils PROPERTIES ASM_MASM_COMPILE_FLAGS "/D_M_X64") # MASM specific flags
    # If set_source_files_properties was used before, ensure it's compatible or use target_compile_options
    # For MASM, often flags are set via ASM_MASM_COMPILE_FLAGS property or directly in add_library if simple

    # Link vstdlib_client against this new library
    target_link_libraries(${OUTBINNAME} PRIVATE vstdlib_asm_utils)
else()
    if(MSVC)
        message(STATUS "MASM not enabled for vstdlib_client: CMAKE_GENERATOR_PLATFORM=${CMAKE_GENERATOR_PLATFORM}, CMAKE_SIZEOF_VOID_P=${CMAKE_SIZEOF_VOID_P}")
    endif()
endif()

target_sources(${OUTBINNAME} PRIVATE "random.cpp")
target_sources(${OUTBINNAME} PRIVATE "vcover.cpp")
target_sources(${OUTBINNAME} PRIVATE "eventsystem.cpp")
target_sources(${OUTBINNAME} PRIVATE "vstrtools.cpp")
target_sources(${OUTBINNAME} PRIVATE "vstdlib_strtools.cpp")
#target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/tier0/memoverride.cpp")