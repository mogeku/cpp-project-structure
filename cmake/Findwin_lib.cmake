# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindFoo
-------

Finds the Foo library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``Foo::Foo``
  The Foo library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``Foo_FOUND``
  True if the system has the Foo library.
``Foo_VERSION``
  The version of the Foo library which was found.
``Foo_INCLUDE_DIRS``
  Include directories needed to use Foo.
``Foo_LIBRARIES``
  Libraries needed to link to Foo.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``Foo_INCLUDE_DIR``
  The directory containing ``foo.h``.
``Foo_LIBRARY``
  The path to the Foo library.

#]=======================================================================]

set(PROJECT_ROOT_DIR ${CMAKE_SOURCE_DIR})

if(CMAKE_CL_64)
    set(arch x86_64)
else()
    set(arch x86)
endif()

find_path(win_lib_INCLUDE_DIR
    NAMES win_lib.h
    PATHS ${PROJECT_ROOT_DIR}/3rdparty/win_lib/include/win_lib
)
message(STATUS "win_lib_INCLUDE_DIR: ${win_lib_INCLUDE_DIR}")

find_library(win_lib_LIBRARY_RELEASE
    NAMES win_lib
    PATHS ${PROJECT_ROOT_DIR}/3rdparty/win_lib/lib/${CMAKE_SYSTEM_NAME}/${arch}/Release
)
find_library(win_lib_LIBRARY_DEBUG
    NAMES win_lib
    PATHS ${PROJECT_ROOT_DIR}/3rdparty/win_lib/lib/${CMAKE_SYSTEM_NAME}/${arch}/Debug
)

include(SelectLibraryConfigurations)
select_library_configurations(win_lib)
message(STATUS "win_lib_LIBRARY: ${win_lib_LIBRARY}")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(win_lib
    FOUND_VAR win_lib_FOUND
    REQUIRED_VARS
    win_lib_LIBRARY
    win_lib_INCLUDE_DIR
)

if(win_lib_FOUND)
    if(NOT TARGET win_lib::win_lib)
        add_library(win_lib::win_lib UNKNOWN IMPORTED)
    endif()

    if(win_lib_LIBRARY_RELEASE)
        set_property(TARGET win_lib::win_lib APPEND PROPERTY
            IMPORTED_CONFIGURATIONS RELEASE
        )
        set_target_properties(win_lib::win_lib PROPERTIES
            IMPORTED_LOCATION_RELEASE "${win_lib_LIBRARY_RELEASE}"
        )
    endif()

    if(win_lib_LIBRARY_DEBUG)
        set_property(TARGET win_lib::win_lib APPEND PROPERTY
            IMPORTED_CONFIGURATIONS DEBUG
        )
        set_target_properties(win_lib::win_lib PROPERTIES
            IMPORTED_LOCATION_DEBUG "${win_lib_LIBRARY_DEBUG}"
        )
    endif()

    set_target_properties(win_lib::win_lib PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${win_lib_INCLUDE_DIR}/.."
    )
endif()

mark_as_advanced(
    win_lib_INCLUDE_DIR
    win_lib_LIBRARY
)


if(win_lib_FOUND)
    set(win_lib_LIBRARIES ${win_lib_LIBRARY})
    set(win_lib_INCLUDE_DIRS ${win_lib_INCLUDE_DIR})
    set(win_lib_LIB_TARGET win_lib::win_lib)
endif()
