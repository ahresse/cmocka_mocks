# SPDX-License-Identifier: MIT
cmake_minimum_required(VERSION 3.21)
include(cmake/project.cmake)

project(cmocka_mocks LANGUAGES C VERSION ${CMOCKA_MOCKS_VERSION})

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
