vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/Ipotrick/Daxa
    REF 19529305c618b3a24e262de19f1fdcb3a1056523
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
    utils WITH_UTILS
    tests WITH_TESTS
)
set(DAXA_DEFINES)
if(WITH_UTILS)
    list(APPEND DAXA_DEFINES "-DDAXA_ENABLE_UTILS=true")
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
