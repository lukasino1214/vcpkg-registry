vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/Nelarius/imnodes
    REF xxx
)

file(WRITE "${SOURCE_PATH}/CMakeLists.txt" [==[
cmake_minimum_required(VERSION 3.15)
project(imnodes VERSION 0.5.0)
add_library(${PROJECT_NAME} "imnodes.cpp")
add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

target_include_directories(${PROJECT_NAME}
    PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

find_package(imgui CONFIG REQUIRED)
target_link_libraries(imnodes PUBLIC imgui::imgui)

# Packaging
include(CMakePackageConfigHelpers)
include(GNUInstallDirs)
file(WRITE ${CMAKE_BINARY_DIR}/config.cmake.in [=[
@PACKAGE_INIT@
include(${CMAKE_CURRENT_LIST_DIR}/imnodes-targets.cmake)
check_required_components(imnodes)
find_package(imgui CONFIG REQUIRED)
]=])

configure_package_config_file(${CMAKE_BINARY_DIR}/config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/imnodes-config.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_DATADIR}/imnodes
    NO_SET_AND_CHECK_MACRO)
write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/imnodes-config-version.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion)
install(
    FILES
    ${CMAKE_CURRENT_BINARY_DIR}/imnodes-config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/imnodes-config-version.cmake
    DESTINATION
    ${CMAKE_INSTALL_DATADIR}/imnodes)
install(TARGETS imnodes EXPORT imnodes-targets)
install(EXPORT imnodes-targets DESTINATION ${CMAKE_INSTALL_DATADIR}/imnodes NAMESPACE imnodes::)
install(FILES ${PROJECT_SOURCE_DIR}/imnodes.h TYPE INCLUDE)
]==])

vcpkg_configure_cmake(
    SOURCE_PATH "${SOURCE_PATH}"
    PREFER_NINJA
)
vcpkg_install_cmake()
vcpkg_fixup_cmake_targets()
file(INSTALL "${SOURCE_PATH}/LICENSE.md"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
    RENAME copyright
)
