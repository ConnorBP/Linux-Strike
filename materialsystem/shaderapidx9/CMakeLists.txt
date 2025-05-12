#//-----------------------------------------------------------------------------
#//	SHADERDX8.VPC
#//
#//	Project Script
#//-----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.16)
project(shaderapidx9_client)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
set(OUTBINNAME "shaderapidx9_client")
set(OUTBINDIR ${SRCDIR}/../game/bin)

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
if( WINDOWS )
	set(OUTBINNAME "shaderapidx9")
else()
include(${CMAKE_MODULE_PATH}/source_dll_base.cmake)

if( WINDOWS AND NOT GL )

	include_directories(${SRCDIR}/thirdparty/nvidia/nvapi)

	# discover direct x sdk
	include(${CMAKE_MODULE_PATH}/FindDirectX.cmake)

	# link direct x sdk
	if(DIRECTX_FOUND)
		# use the system directx sdk
		include_directories(${DIRECTX_INCLUDE_DIRS})
		message(STATUS "DirectX SDK found: ${DIRECTX_INCLUDE_DIR}")
		target_link_libraries(${OUTBINNAME} ${DIRECTX_D3D9_LIBRARY} ${DIRECTX_D3DX9_LIBRARIES})
	else()
		# try to use the dxsdk from the source tree
		include_directories(${SRCDIR}/thirdparty/dxsdk/include)
		if(CMAKE_SIZEOF_VOID_P EQUAL 8)
			target_link_libraries(${OUTBINNAME} ${SRCDIR}/thirdparty/dxsdk/lib/x64/d3d9.lib ${SRCDIR}/thirdparty/dxsdk/lib/x64/d3dx9.lib)
		else()
			target_link_libraries(${OUTBINNAME} ${SRCDIR}/thirdparty/dxsdk/lib/x86/d3d9.lib ${SRCDIR}/thirdparty/dxsdk/lib/x86/d3dx9.lib)
		endif()
	endif()

	# link nvapi
	if(CMAKE_SIZEOF_VOID_P EQUAL 8)
		target_link_libraries(${OUTBINNAME} ${SRCDIR}/thirdparty/nvidia/nvapi/lib/nvapi64.lib)
	else()
		target_link_libraries(${OUTBINNAME} ${SRCDIR}/thirdparty/nvidia/nvapi/lib/nvapi.lib)
	endif()

	target_link_libraries(${OUTBINNAME} ws2_32.lib)
	add_definitions(-DUSE_ACTUAL_DX)
endif()

include_directories(../)
add_definitions(-DSHADERAPIDX9 -DSHADER_DLL_EXPORT -DPROTECTED_THINGS_ENABLE -Dstrncpy=use_Q_strncpy_instead -D_snprintf=use_Q_snprintf_instead)

if( GL )
    add_definitions(-DGL_GLEXT_PROTOTYPES -DDX_TO_GL_ABSTRACTION)
endif()

#Source files
target_sources(${OUTBINNAME} PRIVATE "colorformatdx8.cpp")
target_sources(${OUTBINNAME} PRIVATE "d3d_async.cpp")
if( NOT OSXALL )
    target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/filesystem_helpers.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "hardwareconfig.cpp")
target_sources(${OUTBINNAME} PRIVATE "meshbase.cpp")
target_sources(${OUTBINNAME} PRIVATE "meshdx8.cpp")
if( WINDOWS AND NOT GL )
    target_sources(${OUTBINNAME} PRIVATE "recording.cpp")
    target_sources(${OUTBINNAME} PRIVATE "wmi.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "shaderapidx8.cpp")
target_sources(${OUTBINNAME} PRIVATE "shaderdevicebase.cpp")
target_sources(${OUTBINNAME} PRIVATE "shaderapibase.cpp")
target_sources(${OUTBINNAME} PRIVATE "shaderdevicedx8.cpp")
target_sources(${OUTBINNAME} PRIVATE "shadershadowdx8.cpp")
target_sources(${OUTBINNAME} PRIVATE "texturedx8.cpp")
target_sources(${OUTBINNAME} PRIVATE "TransitionTable.cpp")
target_sources(${OUTBINNAME} PRIVATE "cvballoctracker.cpp")
target_sources(${OUTBINNAME} PRIVATE "vertexdecl.cpp")
target_sources(${OUTBINNAME} PRIVATE "vertexshaderdx8.cpp")
#$File	"$SHADERAPIDX9DIR\textureheap.cpp"							[$X360]
#$File	"$SRCDIR\common\ps3\vjobutils.cpp"							[$PS3]
#$File	"$SRCDIR\common\ps3\spu_job_shared.cpp"						[$PS3]
if( NOT WINDOWS )
    target_sources(${OUTBINNAME} PRIVATE "winutils.cpp")
endif()


if( WINDOWS )

	# Linker
	target_link_libraries(${OUTBINNAME} mathlib vstdlib bitmap tier1 tier2 vtf bzip2 )

	if( POSIX )
		target_link_libraries(${OUTBINNAME} dl )
	endif()
	if( WINDOWS OR POSIX )
		target_link_libraries(${OUTBINNAME} videocfg)
	endif()
	if( GL )
		target_link_libraries(${OUTBINNAME} libtogl)
	endif()

else()

	# Linker
	target_link_libraries(${OUTBINNAME} mathlib_client vstdlib_client bitmap_client tier1_client tier2_client vtf_client bzip2_client )

	if( POSIX )
		target_link_libraries(${OUTBINNAME} dl )
	endif()
	if( WINDOWS OR POSIX )
		target_link_libraries(${OUTBINNAME} videocfg_client)
	endif()
	if( GL )
		target_link_libraries(${OUTBINNAME} libtogl_client)
	endif()

endif()