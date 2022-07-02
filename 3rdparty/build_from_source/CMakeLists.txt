cmake_minimum_required(VERSION 3.10)

add_library(build_from_source STATIC build_from_source.cpp)
target_include_directories(build_from_source
    PUBLIC
    .
)

if(WIN32)
    set_target_properties(build_from_source PROPERTIES
        MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>"
    )
endif()
