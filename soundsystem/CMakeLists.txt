#//-----------------------------------------------------------------------------
#//	SOUNDSYSTEM.VPC
#//
#//	Project Script
#//-----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.16)
project(soundsystem_client)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
set(OUTBINNAME "soundsystem_client")
set(OUTBINDIR ${SRCDIR}/../game/bin)

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
include(${CMAKE_MODULE_PATH}/source_dll_base.cmake)


if( MSVC AND WINDOWS )

	# discover direct x sdk
	include(${CMAKE_MODULE_PATH}/FindDirectX.cmake)

	# link direct x sdk
	if(DIRECTX_FOUND) # This now also implies DIRECTX_DSOUND_LIBRARY and DIRECTX_DXGUID_LIBRARY are found by the module
		message(STATUS "System DirectX SDK found. Using identified components.")
		# Use the system directx sdk include directories
		include_directories(${DIRECTX_INCLUDE_DIRS})
		message(STATUS "  Include directories: ${DIRECTX_INCLUDE_DIRS}")
		message(STATUS "  D3D9 Library: ${DIRECTX_D3D9_LIBRARY}")
		message(STATUS "  D3DX9 Libraries: ${DIRECTX_D3DX9_LIBRARIES}")
		message(STATUS "  DSound Library: ${DIRECTX_DSOUND_LIBRARY}")
		message(STATUS "  DXGuid Library: ${DIRECTX_DXGUID_LIBRARY}")

		target_link_libraries(${OUTBINNAME}
			# ${DIRECTX_D3D9_LIBRARY}
			# ${DIRECTX_D3DX9_LIBRARIES}
			${DIRECTX_DSOUND_LIBRARY}
			${DIRECTX_DXGUID_LIBRARY}
		)
	else()
		message(WARNING "System DirectX SDK not fully found or some components are missing. Falling back to third-party DXSDK from source tree.")
		# Try to use the dxsdk from the source tree
		set(DXSDK_FALLBACK_INCLUDE_DIR ${SRCDIR}/thirdparty/dxsdk/include)
		set(DXSDK_FALLBACK_LIB_DIR_X64 ${SRCDIR}/thirdparty/dxsdk/lib/x64)
		set(DXSDK_FALLBACK_LIB_DIR_X86 ${SRCDIR}/thirdparty/dxsdk/lib/x86)

		include_directories(${DXSDK_FALLBACK_INCLUDE_DIR})
		message(STATUS "  Using third-party DirectX SDK include: ${DXSDK_FALLBACK_INCLUDE_DIR}")

		if(CMAKE_SIZEOF_VOID_P EQUAL 8)
			message(STATUS "  Linking with third-party x64 libraries.")
			target_link_libraries(${OUTBINNAME}
				${DXSDK_FALLBACK_LIB_DIR_X64}/d3d9.lib
				${DXSDK_FALLBACK_LIB_DIR_X64}/d3dx9.lib
				${DXSDK_FALLBACK_LIB_DIR_X64}/dsound.lib
				${DXSDK_FALLBACK_LIB_DIR_X64}/dxguid.lib
			)
		else()
			message(STATUS "  Linking with third-party x86 libraries.")
			target_link_libraries(${OUTBINNAME}
				${DXSDK_FALLBACK_LIB_DIR_X86}/d3d9.lib
				${DXSDK_FALLBACK_LIB_DIR_X86}/d3dx9.lib
				${DXSDK_FALLBACK_LIB_DIR_X86}/dsound.lib
				${DXSDK_FALLBACK_LIB_DIR_X86}/dxguid.lib
			)
		endif()
	endif()
	target_link_libraries(${OUTBINNAME} winmm.lib)
endif()

add_definitions(-DSOUNDSYSTEM_EXPORTS)

target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/sentence.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/phonemeconverter.cpp")
target_sources(${OUTBINNAME} PRIVATE "snd_audio_source.cpp")
target_sources(${OUTBINNAME} PRIVATE "snd_dev_wave.cpp")
target_sources(${OUTBINNAME} PRIVATE "snd_io.cpp")
target_sources(${OUTBINNAME} PRIVATE "snd_wave_mixer.cpp")
target_sources(${OUTBINNAME} PRIVATE "snd_wave_mixer_adpcm.cpp")
target_sources(${OUTBINNAME} PRIVATE "snd_wave_source.cpp")
target_sources(${OUTBINNAME} PRIVATE "soundsystem.cpp")

target_link_libraries(${OUTBINNAME} soundsystem_lowlevel vstdlib_client mathlib_client tier2_client)