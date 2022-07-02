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

# ########################### Global macros #############################
add_definitions(-DDEBUG -DYES_IS_ME)

# ---------------------------------------------------------------------------------------
# Add 3rdparty library
# ---------------------------------------------------------------------------------------
add_subdirectory(${PROJECT_ROOT_DIR}/3rdparty/build_from_source)

# ---------------------------------------------------------------------------------------
# Build target
# ---------------------------------------------------------------------------------------
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")

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

if(BUILD_SHARED_LIBS)
target_compile_definitions(project_name
    PRIVATE
    SHARED_LIB
    DLL_EXPORT
)
endif()

if(WIN32)
    set_target_properties(project_name PROPERTIES
        MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>"
    )
endif()

# ############################ Complile option #############################
target_compile_features(project_name
    PUBLIC
    cxx_std_17
)
message(STATUS "Compile options for c++: ${CMAKE_CXX_FLAGS}")

# ############################ Link library #############################
target_link_libraries(project_name
    PRIVATE
    build_from_source
)

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
