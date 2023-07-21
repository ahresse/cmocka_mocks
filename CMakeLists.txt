# SPDX-License-Identifier: MIT
cmake_minimum_required(VERSION 3.21)
include(cmake/project.cmake)
include(cmake/FetchLibrary.cmake)

project(cmocka_mocks LANGUAGES C VERSION ${CMOCKA_MOCKS_VERSION})

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/dist/usr/local/lib/cmake")

if(DEFINED SOURCING)
  fetchLibrary(cmocka-extensions ${SOURCING}/cmocka-extensions.git  "de3a275dbf8b70b9eeeff21df16d77989f1fa403")

endif(DEFINED SOURCING)

project_set_environment()
project_set_version_variables()
project_add_documentation_target(
  TITLE
    "BaseOS Cmocka_mocks Documentation"
  MARKDOWN
    ${CMAKE_SOURCE_DIR}/documentation/documentation.md
)

add_subdirectory(src)

if(PACKAGING)
  include(cmake/Packing.cmake)
endif(PACKAGING)
