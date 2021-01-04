#!/bin/bash

security -v unlock-keychain -p "123456" "/Users/jenkins/Library/Keychains/login.keychain"

cd ..
__PROJECT_DIR=`pwd`
echo "__PROJECT_DIR: ${__PROJECT_DIR}"  

# 获取工程名，根据*.xcworkspace格式判断
for file in $(ls ./)
do 
    if [ "${file##*.}" = "xcworkspace" ]; then
        __THIS_PROJECT_NAME=${file%.*}
        break
    fi
done

echo "__THIS_PROJECT_NAME:${__THIS_PROJECT_NAME}"

__FORMATTED_TIME_TO_FILE=`date +%Y%m%d_%H%M%S`
__WORK_SPACE="${__THIS_PROJECT_NAME}.xcworkspace"
__SCHEME_NAME="PackagingDemo_DEV"
__BUILD_CONF="Release_DEV"
__USER_NAME="`whoami`"
__USER_DIR="/Users/`whoami`"
__EXPORT_DIR="${__USER_DIR}/iOSPackagingOutput"
__EXPORT_ARCHIVE_PATH="${__EXPORT_DIR}/${__THIS_PROJECT_NAME}_${__FORMATTED_TIME_TO_FILE}/${__THIS_PROJECT_NAME}.xcarchive"
__EXPORT_IPA_PATH="${__EXPORT_DIR}/${__THIS_PROJECT_NAME}_${__FORMATTED_TIME_TO_FILE}"
__EXPORT_OPTION_PLIST_PATH="./AutoSh/ExportOptions.plist"

echo "__FORMATTED_TIME_TO_FILE: ${__FORMATTED_TIME_TO_FILE}"
echo "__WORK_SPACE: ${__WORK_SPACE}"
echo "__SCHEME_NAME: ${__SCHEME_NAME}"
echo "__BUILD_CONF: ${__BUILD_CONF}"
echo "__USER_NAME: ${__USER_NAME}"
echo "__USER_DIR: ${__USER_DIR}"
echo "__EXPORT_ARCHIVE_PATH: ${__EXPORT_ARCHIVE_PATH}"
echo "__EXPORT_IPA_PATH: ${__EXPORT_IPA_PATH}"
echo "__EXPORT_OPTION_PLIST_PATH: ${__EXPORT_OPTION_PLIST_PATH}"

echo "\n开始安装CocoaPods依赖库"
pod cache clean --all
pod install

# clean
echo "\n清理工作空间"
xcodebuild clean \
    -workspace ${__WORK_SPACE} \
    -scheme ${__SCHEME_NAME} \
    -configuration ${__BUILD_CONF}

# archive
echo "\n开始归档工程"
xcodebuild archive \
    -workspace ${__WORK_SPACE} \
    -scheme ${__SCHEME_NAME} \
    -configuration ${__BUILD_CONF} \
    -archivePath ${__EXPORT_ARCHIVE_PATH}
    
# export
echo "\n开始导出项目"
xcodebuild \
    -exportArchive \
    -archivePath ${__EXPORT_ARCHIVE_PATH} \
    -exportPath ${__EXPORT_IPA_PATH} \
    -exportOptionsPlist ${__EXPORT_OPTION_PLIST_PATH} \
    -allowProvisioningUpdates \
    -allowProvisioningDeviceRegistration

# 检查ipa文件是否已经成功创建
echo "${__EXPORT_IPA_PATH}/${__THIS_PROJECT_NAME}.ipa"
if [[ -f "${__EXPORT_IPA_PATH}/${__THIS_PROJECT_NAME}.ipa" ]]; then
    echo "导出 ${__EXPORT_IPA_PATH}/${__THIS_PROJECT_NAME}.ipa包成功"
else
    echo "导出 ${__EXPORT_IPA_PATH}/${__THIS_PROJECT_NAME}.ipa包失败"
    exit
fi

# 提取符号表（友盟暂不支持自动上传）
# PackagingDemo.xcarchive/dSYMs/PackagingDemo.app.dSYM
# __D_SYMBOL_PATH="${__EXPORT_ARCHIVE_PATH}/dSYMs/${__THIS_PROJECT_NAME}.app.dSYM"
# echo "${__D_SYMBOL_PATH}"
# if [[ -e "${__D_SYMBOL_PATH}" ]]; then
#     echo "符号表存在"
# else
#     echo "符号表不存在"
# fi




