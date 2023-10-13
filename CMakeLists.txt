# SPDX-License-Identifier: MIT
cmake_minimum_required(VERSION 3.21)
include(cmake/ConfigureLibrary.cmake)
include(cmake/project.cmake) # redefining OUR cmake project functions
project(cmocka_mocks LANGUAGES C VERSION ${CMOCKA_MOCKS_VERSION})
project_set_environment()
project_set_version_variables()
project_add_documentation_target(
  TITLE
    "BaseOS Cmocka_mocks Documentation"
  MARKDOWN
    ${CMAKE_SOURCE_DIR}/documentation/documentation.md
)

list(APPEND CMAKE_PREFIX_PATH "${INSTALL_DIR}/usr/local/lib/cmake")

configureLibrary(cmocka_extensions "${CMOCKA_EXTENSIONS_URI}" "${CMOCKA_EXTENSIONS_REF}")

add_subdirectory(src)

if(PACKAGING)
  include(cmake/Packing.cmake)
endif(PACKAGING)
