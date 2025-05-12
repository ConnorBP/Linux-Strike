#//-----------------------------------------------------------------------------
#//	VIDEOCFG.VPC
#//
#//	Project Script
#//-----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.16)
project(videocfg_client)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
if(WINDOWS)
    set(OUTLIBNAME "videocfg")
else()
    set(OUTLIBNAME "videocfg_client")
endif()
include(${CMAKE_MODULE_PATH}/source_lib_base.cmake)

include_directories(${SRCDIR}/public/videocfg)

if( LINUXALL )
    target_compile_options(${OUTLIBNAME} PRIVATE -fpic -fno-semantic-interposition)
endif()

target_sources(${OUTLIBNAME} PRIVATE "videocfg.cpp")