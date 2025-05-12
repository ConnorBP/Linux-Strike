#//-----------------------------------------------------------------------------
#//	RAYTRACE.VPC
#//
#//	Project Script
#//-----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.16)
project(raytrace_client)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)

if(WINDOWS)
    set(OUTLIBNAME "raytrace")
else()
    set(OUTLIBNAME "raytrace_client")   
endif()

include(${CMAKE_MODULE_PATH}/source_lib_base.cmake)

include_directories(${SRCDIR}/utils/common)

if( LINUXALL )
    target_compile_options(${OUTLIBNAME} PRIVATE -Wno-narrowing -fpic -fno-semantic-interposition)
endif()

target_sources(${OUTLIBNAME} PRIVATE "raytrace.cpp")
target_sources(${OUTLIBNAME} PRIVATE "trace2.cpp")
target_sources(${OUTLIBNAME} PRIVATE "trace3.cpp")