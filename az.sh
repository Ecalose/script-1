#!/bin/bash

#========================================================
#   Description: az检查订阅存活脚本
#   Github: https://github.com/zkysimon
#========================================================

azure=($(cat az.txt))
echo ${#azure[@]}

for account in ${azure[@]};do
username=$(cut -d ',' -f 1 $account)
password=$(cut -d ',' -f 2 $account)
echo $username
echo $password
