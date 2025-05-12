project(shadercompile)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
set(OUTBINDIR ${SRCDIR}/../game/bin)

# Define the executable target
# add_executable(shadercompile shadercompile_launcher.cpp)

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
# set(NOSTINKYLINKIES "1")
# set(NOSKELETONBASE "1")

# output name to match the VPC's $Macro OUTBINNAME "shadercompile"
set(OUTBINNAME "shadercompile")

include(${CMAKE_MODULE_PATH}/source_exe_base.cmake)

target_sources(${OUTBINNAME} PRIVATE
    shadercompile_launcher.cpp
    # "${SRCDIR}/public/tier0/platform.h"
    # "${SRCDIR}/public/tier0/valve_minidump.h"
    # "${SRCDIR}/public/tier0/valve_minidump.cpp"
    # "${SRCDIR}/public/tier0/valve_minidump_win32.cpp"
)

# Ensure this is built as a console application if shadercompile_launcher.cpp has a main() entry point.
if( WINDOWS )
    set_target_properties(${OUTBINNAME} PROPERTIES
        LINK_FLAGS /SUBSYSTEM:CONSOLE
        WIN32_EXECUTABLE OFF
    )
endif()


target_include_directories(${OUTBINNAME} PRIVATE
    "${CMAKE_SOURCE_DIR}/public"
)

# Link against required libraries (e.g., tier0, vstdlib)
# This needs to match what source_exe_con_win32_base.vpc would link
if( WINDOWS )
    target_link_libraries(${OUTBINNAME} PRIVATE libtier0 vstdlib)

else()
    target_link_libraries(${OUTBINNAME} PRIVATE libtier0_client vstdlib_client)
endif()