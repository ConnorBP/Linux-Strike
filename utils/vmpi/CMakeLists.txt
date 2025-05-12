cmake_minimum_required(VERSION 3.10)
project(vmpi)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH "${SRCDIR}/cmake" ${CMAKE_MODULE_PATH})
set(OUTBINDIR ${SRCDIR}/../game/bin)

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
set(OUTBINNAME "vmpi")
include(${CMAKE_MODULE_PATH}/source_dll_base.cmake)

find_package(CURL REQUIRED)
target_link_libraries(${OUTBINNAME} PRIVATE CURL::libcurl)

# Source Files
target_sources(${OUTBINNAME} PRIVATE
    "${SRCDIR}/public/filesystem_init.cpp"
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
)

target_include_directories(${OUTBINNAME} PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/../common"
    "${CMAKE_CURRENT_SOURCE_DIR}/ZLib"
    # "${SRCDIR}/thirdparty/zlib/include"
    "${SRCDIR}/thirdparty/libcurl/include"
    "${SRCDIR}/public" # Provides access to tier0, tier1, etc.
)

# Preprocessor Definitions
target_compile_definitions(${OUTBINNAME} PRIVATE
    PROTECTED_THINGS_DISABLE
    MPI
    # Add any definitions from source_lib_base.cmake or common settings
)

# Handle Zlib dependency
# Option 1: Find ZLIB using CMake's built-in module (preferred if Zlib is installed system-wide or findable)
# find_package(ZLIB QUIET)
# if(NOT ZLIB_FOUND)
    # Option 2: Define an IMPORTED target for a prebuilt Zlib.lib
    # Adjust the path to your actual Zlib.lib location.
    # This assumes Zlib.lib is in a common lib directory, possibly configuration-specific.
    if(NOT TARGET ZLIB::ZLIB) # Check if find_package already defined it or if defined globally
        if(NOT TARGET zlib_imported)
            add_library(zlib_imported STATIC IMPORTED GLOBAL)
            set_target_properties(zlib_imported PROPERTIES
                IMPORTED_LOCATION "${CMAKE_CURRENT_SOURCE_DIR}/ZLib/zlib.lib"
                INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}/ZLib"
            )
            message(STATUS "Defined imported target zlib_imported for VMPI.")
        endif()
        set(ZLIB_LIBRARIES zlib_imported) # Use our imported target
        # Ensure ZLIB_INCLUDE_DIRS is set if target_link_libraries doesn't propagate it from INTERFACE_INCLUDE_DIRECTORIES
        # list(APPEND ZLIB_INCLUDE_DIRS "${SRCDIR}/thirdparty/zlib/include")
    else()
        message(STATUS "ZLIB found via find_package or already defined for VMPI.")
    endif()
# endif()

# Link Libraries
# For a static library, these are more like usage requirements for consumers,
# or dependencies for its own compilation if Zlib headers are needed.
if(ZLIB_LIBRARIES)
    target_link_libraries(${PROJECT_NAME} INTERFACE ${ZLIB_LIBRARIES})
endif()
# If ZLIB_INCLUDE_DIRS was set and not handled by target_link_libraries(ZLIB::ZLIB) or INTERFACE_INCLUDE_DIRECTORIES:
# if(ZLIB_INCLUDE_DIRS)
# target_include_directories(${PROJECT_NAME} PRIVATE ${ZLIB_INCLUDE_DIRS}) # PRIVATE if only vmpi sources need it
# endif()


#force include
if( WINDOWS OR POSIX )
    target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/tier0/platform.h")
endif()

message(STATUS "Configuring VMPI SDK target: ${PROJECT_NAME}")
