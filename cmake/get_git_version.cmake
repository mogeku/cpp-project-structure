find_package(Git)
# 生成版本描述字符串类似 TAG-X-gHASH
execute_process(COMMAND ${GIT_EXECUTABLE} symbolic-ref --short -q HEAD
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_BRANCH
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )
string(SUBSTRING ${GIT_BRANCH} 0 1 GIT_BRANCH)

# 获取最新 commit 日期，YYYY-MM-DD
execute_process(COMMAND ${GIT_EXECUTABLE} rev-list HEAD -n 1
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_COMMIT
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )
string(SUBSTRING ${GIT_COMMIT} 0 7 GIT_COMMIT)

# 获取最新 commit Hash
execute_process(COMMAND ${GIT_EXECUTABLE} rev-list HEAD --count
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_COMMIT_COUNT
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )

set(GIT_VERSION "${GIT_COMMIT_COUNT}-${GIT_BRANCH}-${GIT_COMMIT}")
file(WRITE ${PROJECT_BINARY_DIR}/version
        "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}.${GIT_VERSION}"
        )
MESSAGE(STATUS "Write git version info to: ${PROJECT_BINARY_DIR}/version")

# set(PROJECT_VERSION_PATCH ${GIT_COMMIT_COUNT})

# 包含引用目录，源文件可以直接用 #include "repo_version.h" 包含
#include_directories(${PROJECT_BINARY_DIR})
