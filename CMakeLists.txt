cmake_minimum_required(VERSION 3.20)
project(project_name
    VERSION 1.0.0
    LANGUAGES C CXX
    DESCRIPTION "A cmake template project"
)

# version file
configure_file(src/version.h.in "${CMAKE_BINARY_DIR}/version.h")

# ---------------------------------------------------------------------------------------
# Set global variable
# ---------------------------------------------------------------------------------------

# ############################ User defined variable #############################
set(PROJECT_ROOT_DIR ${CMAKE_CURRENT_LIST_DIR})
set(platform ${CMAKE_SYSTEM_NAME})

set(arch ${CMAKE_SYSTEM_PROCESSOR})

if(WIN32)
    if(CMAKE_CL_64)
        set(arch x86_64)
    else()
        set(arch x86)
    endif()
elseif(APPLE)
elseif(ANDROID)
endif()

message(STATUS "system platform: ${platform}")
message(STATUS "system arch: ${arch}")

# set output path
set(PROJECT_OUTPUT_DIR ${PROJECT_BINARY_DIR}/${arch})

message(STATUS "output path: ${PROJECT_OUTPUT_DIR} ")

# set the target path
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_OUTPUT_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_OUTPUT_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_OUTPUT_DIR}/lib)

# load cmake script
set(CMAKE_MODULE_PATH ${PROJECT_ROOT_DIR}/cmake)

# ---------------------------------------------------------------------------------------
# Add 3rdparty library
# ---------------------------------------------------------------------------------------
add_subdirectory(${PROJECT_ROOT_DIR}/3rdparty/build_from_source)

find_package(win_lib REQUIRED)

if(win_lib_FOUND)
    message(STATUS "win_lib found!!!")
    message(STATUS "win_lib_LIBRARIES: ${win_lib_LIBRARIES}")
    message(STATUS "win_lib_INCLUDE_DIRS: ${win_lib_INCLUDE_DIRS}")
else()
    message(STATUS "win_lib not found!!!")
endif()

# ---------------------------------------------------------------------------------------
# Build target
# ---------------------------------------------------------------------------------------
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")

# ############################ Add source code #############################

# get source files
file(GLOB_RECURSE source_files
    ${PROJECT_ROOT_DIR}/src/*.c
    ${PROJECT_ROOT_DIR}/src/*.cpp
)

# get header files
file(GLOB_RECURSE header_files
    ${PROJECT_ROOT_DIR}/src/*.h
    ${PROJECT_ROOT_DIR}/src/*.hpp
)

# get interface header files
list(APPEND interface_files
    ${PROJECT_ROOT_DIR}/include/project_name/project_name.h
    ${PROJECT_ROOT_DIR}/include/project_name/error_code.h
)

# ############################ Config library target #############################

# not add STATIC or SHARED, control by BUILD_SHARED_LIBS
message(STATUS "Is build shared library: ${BUILD_SHARED_LIBS}")
add_library(project_name)
target_sources(project_name
    PUBLIC
    ${interface_files}
    PRIVATE
    ${source_files}
    ${header_files}
)

target_include_directories(project_name
    PUBLIC
    ${PROJECT_ROOT_DIR}/include
    PRIVATE
    ${PROJECT_ROOT_DIR}/src
    ${CMAKE_BINARY_DIR}
)

# Link library
target_link_libraries(project_name
    PRIVATE
    build_from_source
    ${win_lib_LIB_TARGET}
)

if(BUILD_SHARED_LIBS)
    # Add marco for shared library
    target_compile_definitions(project_name
        PRIVATE
        SHARED_LIB
        DLL_EXPORT
    )
endif()

if(WIN32)
    # Avoid error: 'MD_DynamicRelease' doesn't match value 'MT_StaticRelease'
    set_target_properties(project_name PROPERTIES
        MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>"
    )
endif()

# Complile option
# List of cxx feature: https://cmake.org/cmake/help/latest/prop_gbl/CMAKE_CXX_KNOWN_FEATURES.html?highlight=cmake_cxx_known_features
target_compile_features(project_name
    PUBLIC
    cxx_std_17

    # cxx_lambdas
    # ...
)
message(STATUS "Compile options for c++: ${CMAKE_CXX_FLAGS}")

# ############################ Build example #############################
add_executable(example)
target_sources(example
    PRIVATE
    ${PROJECT_ROOT_DIR}/example/example.cpp
)

if(WIN32)
    set_target_properties(example PROPERTIES
        MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>"
    )
endif()

target_link_libraries(example
    PRIVATE
    project_name
)

# ---------------------------------------------------------------------------------------
# Some cmake operator sample
# ---------------------------------------------------------------------------------------

# Debugging generator expressions (https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html#manual:cmake-generator-expressions(7))
add_custom_target(genexdebug ALL
    COMMAND ${CMAKE_COMMAND} -E echo
    "***************************** Debug for generator expression *****************************"
    COMMAND ${CMAKE_COMMAND} -E echo
    "+++++$<IF:$<CONFIG:release>,is_release,not_release>"
    COMMAND ${CMAKE_COMMAND} -E echo
    "+++++$<TARGET_FILE:project_name>"
)

# list
message(STATUS "***************************** Debug for list *****************************")
LIST(APPEND my_list a b c)
LIST(LENGTH my_list list_len)
message(STATUS "+++my_list:${my_list}, list_len:${list_len}")

foreach(value ${my_list})
    LIST(FIND my_list ${value} idx)
    message(STATUS "my_list[${idx}]: ${value}")
endforeach()
