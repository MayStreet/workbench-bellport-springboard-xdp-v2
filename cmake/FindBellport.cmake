INCLUDE (FindPackageHandleStandardArgs)

FIND_PATH (BELLPORT_INCLUDE_DIR
  NAMES bp/config.hpp
  HINTS ${BELLPORT_ROOT_DIR}/include
  DOC "Bellport include directory")

macro(bellport_find_library OUT_VAR BELLPORT_BASE_NAME)
  find_library (BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY_RELEASE
    NAMES ${BELLPORT_BASE_NAME} lib${BELLPORT_BASE_NAME}
    PATHS ${BELLPORT_ROOT_DIR}/lib
          ${BELLPORT_ROOT_DIR}/bin
          NO_DEFAULT_PATH
          NO_SYSTEM_ENVIRONMENT_PATH
    )
  find_library (BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY_DEBUG
    NAMES ${BELLPORT_BASE_NAME}d lib${BELLPORT_BASE_NAME}d
    PATHS ${BELLPORT_ROOT_DIR}/lib
          ${BELLPORT_ROOT_DIR}/bin
          NO_DEFAULT_PATH
          NO_SYSTEM_ENVIRONMENT_PATH
    )
  find_library (BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY_DEBUG
    NAMES ${BELLPORT_BASE_NAME}_debug lib${BELLPORT_BASE_NAME}_debug
    PATHS ${BELLPORT_ROOT_DIR}/lib
          ${BELLPORT_ROOT_DIR}/bin
          NO_DEFAULT_PATH
          NO_SYSTEM_ENVIRONMENT_PATH
    )

  mark_as_advanced(BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY_RELEASE
    BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY_DEBUG
    BELLPORT_${BELLPORT_BASE_NAME})

  #message("BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY_RELEASE ${BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY_RELEASE}")
  #message("BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY_DEBUG ${BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY_DEBUG}")

  if (BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY_RELEASE AND
      BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY_DEBUG)
    set(BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY
      optimized ${BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY_RELEASE}
      debug ${BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY_DEBUG})
  elseif(BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY_RELEASE)
    set(BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY
      ${BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY_RELEASE})
  elseif(BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY_DEBUG)
    set(BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY
      ${BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY_DEBUG})
  endif()
  set (${OUT_VAR} ${${OUT_VAR}} ${BELLPORT_${BELLPORT_BASE_NAME}_LIBRARY})
endmacro()

set (BELLPORT_LIBRARIES "")
set (BELLPORT_THIRDPARTY_LIBRARIES "")

#find_library (BELLPORT_IDN_LIBRARY
#NAMES libidn idn
#)

#if (BELLPORT_IDN_LIBRARY)
#  set (BELLPORT_LIBRARIES ${BELLPORT_LIBRARIES} ${BELLPORT_IDN_LIBRARY})
#endif(BELLPORT_IDN_LIBRARY)

bellport_find_library(BELLPORT_LIBRARIES bellport)

bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES bz2)
bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES ciul1)
bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES curl)
if (WIN32)
  set (BELLPORT_THIRDPARTY_LIBRARIES
    ${BELLPORT_THIRDPARTY_LIBRARIES}
    shlwapi
    ws2_32
    wininet
    netapi32
    comctl32
    Wbemuuid
    crypt32)
elseif(APPLE)
else()
  find_package(OpenSSL)
  if (OPENSSL_FOUND)
     set (BELLPORT_THIRDPARTY_LIBRARIES ${BELLPORT_THIRDPARTY_LIBRARIES} ${OPENSSL_LIBRARIES})
  endif()
endif()
bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES onload_zf_static)
bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES flexnetmd)
bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES flexnetall)
bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES lz4)
if (WIN32)
  bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES zstd_static)
else()
  bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES rssl) # elektron
  bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES zstd)
endif()
bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES lzma)
bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES pcap)
bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES xl)
bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES zlib)
bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES z)
bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES omd)
bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES xz)
if (WIN32)
  bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES cryptoMD)
else()
  bellport_find_library(BELLPORT_THIRDPARTY_LIBRARIES archive)
endif()

set(BELLPORT_LIBRARIES ${BELLPORT_LIBRARIES} ${CMAKE_DL_LIBS})

find_package_handle_standard_args (Bellport DEFAULT_MSG
  BELLPORT_ROOT_DIR
  BELLPORT_INCLUDE_DIR
  BELLPORT_LIBRARIES
  BELLPORT_THIRDPARTY_LIBRARIES
  )
