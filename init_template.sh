#!/bin/bash -e
 
# @Author: momo <1209816754@qq.com>
# @Date: 2022-12-15 13:45:03
# @Last Modified by: momo <1209816754@qq.com>
# @Last Modified time: 2022-12-15 13:45:03

script_dir=$(cd `dirname $0`;pwd)
cd $script_dir

project_name=$1
upper_project_name=$2

default_project_name=my_project
default_upper_project_name=MY_PROJECT

if [ "$project_name" == "" -o "$upper_project_name" == "" ];then
    echo "usage:    $0 {project_name} {upper_project_name}"
    echo "example:  $0 MyProject MY_PROJECT"
    exit 1
fi

find . -type f \
    -name "*.in" -or -name "*.h" -or -name "*.cpp" -or -name "*.txt" -or -name "*.md" \
    -not -path './.git/*' -not -path './build/*' \
    | xargs sed -i "s/${default_project_name}/${project_name}/g"
find . -type f \
    -name "*.in" -or -name "*.h" -or -name "*.cpp" -or -name "*.txt" -or -name "*.md" \
    -not -path './.git/*' -not -path './build/*' \
    | xargs sed -i "s/${default_upper_project_name}/${upper_project_name}/g"

mv -f ./include/$default_project_name/$default_project_name.h ./include/$default_project_name/$project_name.h
mv -f ./include/$default_project_name ./include/$project_name

