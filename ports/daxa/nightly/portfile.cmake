vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/Ipotrick/Daxa
    REF 4eb74859ac54a49b0cfd4d710dab22d132d8737e
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
    utils WITH_UTILS
    dxc WITH_DXC
    glslang WITH_GLSLANG
    tests WITH_TESTS
)
set(DAXA_DEFINES)
if(WITH_UTILS)
    list(APPEND DAXA_DEFINES "-DDAXA_ENABLE_UTILS=true")
endif()
if(WITH_DXC)
    list(APPEND DAXA_DEFINES "-DDAXA_ENABLE_DXC=true")
endif()
if(WITH_GLSLANG)
    list(APPEND DAXA_DEFINES "-DDAXA_ENABLE_GLSLANG=true")
endif()
if(WITH_TESTS)
    list(APPEND DAXA_DEFINES "-DDAXA_ENABLE_TESTS=true")
endif()

vcpkg_configure_cmake(
    SOURCE_PATH "${SOURCE_PATH}"
    PREFER_NINJA
    OPTIONS ${DAXA_DEFINES}
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${SOURCE_PATH}/LICENSE"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
    RENAME copyright
)
