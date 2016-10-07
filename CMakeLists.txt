# Project name
project (vala-lint)

# Minimum requirements of build-system
cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.6)

# Installation directories
include (GNUInstallDirs)

# Global configuration
set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/${CMAKE_PROJECT_NAME}")
set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}")
set (RELEASE_NAME "${CMAKE_PROJECT_NAME}")
set (VERSION "0.1")
set (VERSION_INFO "Release")
set (PREFIX ${CMAKE_INSTALL_PREFIX})
set (DOLLAR "$")

# Library configuration
set (LIB_VERSION 1.0)
set (LIB_SOVERSION 0)
set (LIB_NAME ${CMAKE_PROJECT_NAME}-${LIB_VERSION})

# Cmake-files
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Configuration files
configure_file (${CMAKE_SOURCE_DIR}/vala-lint/config.vala.cmake ${CMAKE_SOURCE_DIR}/vala-lint/config.vala)
configure_file (${CMAKE_SOURCE_DIR}/lib/vala-lint.pc.cmake ${CMAKE_CURRENT_BINARY_DIR}/lib/${LIB_NAME}.pc)

# Check for vala
find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.18" MINIMUM)
include (ValaPrecompile)

# Disable C compiler warnings
add_definitions (-w)

# Option to build only the library
option (LIBRARY_ONLY "Build only the library")

# Set gettext-package
add_definitions (-DGETTEXT_PACKAGE="${CMAKE_PROJECT_NAME}")

# Check for required dependencies
find_package (PkgConfig)
pkg_check_modules (DEPS REQUIRED gio-2.0 gee-0.8)

# Link dependencies
add_definitions (${DEPS_CFLAGS})
add_definitions (${LIB_CFLAGS})
link_libraries (${DEPS_LIBRARIES})
link_directories (${DEPS_LIBRARY_DIRS})
link_directories (${LIB_LIBRARY_DIRS})

# Load base-directories
add_subdirectory (lib)
add_subdirectory (po)

if (NOT LIBRARY_ONLY)
    # The following directories are depending on our own library
    include_directories (${CMAKE_BINARY_DIR}/lib)
    set (DEPS_LIBRARIES ${DEPS_LIBRARIES} ${LIB_NAME})

    # Check additional modules
    pkg_check_modules (DEPS REQUIRED vala-lint-1.0)

    # Link additional dependencies
    link_libraries (${DEPS_LIBRARIES})

    # Load directories
    add_subdirectory (vala-lint)
endif ()
