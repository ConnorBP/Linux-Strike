#//-----------------------------------------------------------------------------
#//	worldrenderer.VPC
#//
#//	Project Script
#//-----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.16)
project(interfaces_client)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)

if(WINDOWS)
set(OUTLIBNAME "interfaces")
else()
set(OUTLIBNAME "interfaces_client")
endif()

include(${CMAKE_MODULE_PATH}/source_lib_base.cmake)

if( LINUXALL )
    target_compile_options(${OUTLIBNAME} PRIVATE -fpic -fno-semantic-interposition)
endif()

target_sources(${OUTLIBNAME} PRIVATE interfaces.cpp)