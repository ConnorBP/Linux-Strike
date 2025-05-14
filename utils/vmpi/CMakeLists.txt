cmake_minimum_required(VERSION 3.10)
project(vmpi_project)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH "${SRCDIR}/cmake" ${CMAKE_MODULE_PATH})
set(OUTBINDIR ${SRCDIR}/../game/bin)

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)

set(OUTLIBNAME "vmpi") # Used by source_lib_base.cmake
set(OUTBINNAME "vmpi") # This will be the actual target name for the library

include(${CMAKE_MODULE_PATH}/source_lib_base.cmake)

# Source Files
target_sources(${OUTBINNAME} PRIVATE
    "${SRCDIR}/public/filesystem_init.cpp"
    "${SRCDIR}/public/filesystem_helpers.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../common/filesystem_tools.cpp" 
    "${CMAKE_CURRENT_SOURCE_DIR}/iphelpers.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/loopback_channel.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/messbuf.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/ThreadedTCPSocket.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/ThreadedTCPSocketEmu.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/threadhelpers.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/vmpi.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/vmpi_distribute_tracker.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/vmpi_distribute_work.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/vmpi_distribute_work_sdk.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/vmpi_distribute_work_default.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/vmpi_filesystem.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/vmpi_filesystem_master.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/vmpi_filesystem_worker.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/vmpi_logfile.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../common/pacifier.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../common/cmdlib.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../common/vmpi_tools_shared.cpp" # Often defines VMPI_HandleCrash
    "${CMAKE_CURRENT_SOURCE_DIR}/../common/threads.cpp"
)

target_include_directories(${OUTBINNAME} PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/../common"
    "${CMAKE_CURRENT_SOURCE_DIR}/ZLib"
    # "${SRCDIR}/thirdparty/zlib-1.2.8/include"
    # "${SRCDIR}/thirdparty/libcurl/include"
    "${SRCDIR}/public" # Provides access to tier0, tier1, etc.
)

# Preprocessor Definitions
target_compile_definitions(${OUTBINNAME} PUBLIC
    PROTECTED_THINGS_DISABLE
    MPI
)


find_package(CURL REQUIRED)

# Handle Zlib dependency
find_package(ZLIB)
if (ZLIB_FOUND)
    set(HAVE_ZLIB 1)
    # FindZLIB module define ZLIB_INCLUDE_DIRS variable
    # Set ZLIB_INCLUDE_DIRECTORIES for compatible
    set(ZLIB_INCLUDE_DIRECTORIES ${ZLIB_INCLUDE_DIRECTORIES} ${ZLIB_INCLUDE_DIRS})
    if(ZLIB_INCLUDE_DIRECTORIES)
        target_include_directories(${OUTBINNAME} PRIVATE ${ZLIB_INCLUDE_DIRECTORIES})
    endif()
    set(ZLIB_LIBRARIES ZLIB::ZLIB)
else (ZLIB_FOUND)
    set(HAVE_ZLIB 0)
    message(WARNING "ZLIB not found for VMPI. Zlib-dependent features may fail to link or run.")

    # Explicitly set these to empty (override NOT_FOUND) so cmake doesn't
    # complain when we use them later.
    set(ZLIB_INCLUDE_DIRECTORIES)
    set(ZLIB_LIBRARIES)
endif (ZLIB_FOUND)

if( WINDOWS )
    set(ENGINE_LIBS
        libtier0            # For RandomSeed, RandomInt, platform specifics
        tier1            # For KeyValuesSystem, other tier1 utilities
        vstdlib          # For general utilities, CUtl*, etc.
        filesystem_stdio # For filesystem operations if not fully self-contained
    )
else()
    set(ENGINE_LIBS
        libtier0_client            # For RandomSeed, RandomInt, platform specifics
        tier1_client            # For KeyValuesSystem, other tier1 utilities
        vstdlib_client          # For general utilities, CUtl*, etc.
        filesystem_stdio_client # For filesystem operations if not fully self-contained
    )
endif()

target_link_libraries(${OUTBINNAME} PRIVATE
    ${ENGINE_LIBS}
    CURL::libcurl
    ${ZLIB_LIBRARIES}
    ws2_32
)

# #force include
# if( WINDOWS OR POSIX )
#     target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/tier0/platform.h")
# endif()

message(STATUS "Configuring VMPI SDK target: ${PROJECT_NAME}")
