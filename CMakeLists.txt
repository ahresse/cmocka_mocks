# SPDX-License-Identifier: MIT
cmake_minimum_required(VERSION 3.21)
include(cmake/project.cmake)

project(cmocka_mocks LANGUAGES C VERSION ${CMOCKA_MOCKS_VERSION})

set(CMAKE_PREFIX_PATH "${CMAKE_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/dist/usr/local/lib/cmake")

if(DEFINED SOURCING)
  include(FetchContent)
  set(FETCHCONTENT_QUIET OFF)
  message("Fetching cmocka-extensions")


  FetchContent_Declare(
    cmocka_extensions
    GIT_REPOSITORY ${SOURCING}/cmocka-extensions.git
    GIT_TAG "de3a275dbf8b70b9eeeff21df16d77989f1fa403"
  )
  FetchContent_MakeAvailable(cmocka_extensions)

  while(NOT EXISTS ${CMAKE_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/cmake/_deps/cmocka_extensions-src/ci/build.sh)
    execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 0.5)
  endwhile()
  message("Done fetching")
  message("Building cmocka-extensions")

  set(ENV{LOCAL_INSTALL_DIR} ${CMAKE_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/dist)

  execute_process(
   COMMAND ${CMAKE_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/cmake/_deps/cmocka_extensions-src/ci/build.sh ${CMAKE_BUILD_TYPE}
   WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/cmake/_deps/cmocka_extensions-src/"
   COMMAND_ECHO STDOUT
  )

  message("Done building")

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
