vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/GabeRundlett/gvox
    REF 51397f434859c3c780dc733bad91d0f26a1a6287
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
    tests WITH_TESTS
)

set(GVOX_DEFINES)
if(WITH_TESTS)
    list(APPEND GVOX_DEFINES "-DGVOX_ENABLE_TESTS=true")
endif()

vcpkg_configure_cmake(
    SOURCE_PATH "${SOURCE_PATH}"
    PREFER_NINJA
    OPTIONS ${GVOX_DEFINES}
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${SOURCE_PATH}/LICENSE"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
    RENAME copyright
)
