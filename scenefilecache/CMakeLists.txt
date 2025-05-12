#//-----------------------------------------------------------------------------
#//	SCENEFILECACHE.VPC
#//
#//	Project Script
#//-----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.16)
project(scenefilecache_client)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
set(OUTBINDIR ${SRCDIR}/../game/bin)

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
if(WINDOWS)
    set(OUTBINNAME "scenefilecache")
else()
    set(OUTBINNAME "scenefilecache_client")
endif()
include(${CMAKE_MODULE_PATH}/source_dll_base.cmake)

include_directories(${SRCDIR}/game/shared)
add_definitions(-D_WINDOWS -DPROTECTED_THINGS_ENABLE)

target_sources(${OUTBINNAME} PRIVATE "SceneFileCache.cpp")