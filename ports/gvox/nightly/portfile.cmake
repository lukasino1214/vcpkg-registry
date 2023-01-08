vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/GabeRundlett/gvox
    REF 26429d7594571a90bdd4b827b19b0df4ac6b073e
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
    file-io WITH_FILE_IO
    zlib WITH_ZLIB
    gzip WITH_GZIP
    tests WITH_TESTS
)

set(GVOX_DEFINES)
if(WITH_FILE_IO)
    list(APPEND GVOX_DEFINES "-DGVOX_ENABLE_FILE_IO=true")
endif()
if(WITH_ZLIB)
    list(APPEND GVOX_DEFINES "-DGVOX_ENABLE_ZLIB=true")
endif()
if(WITH_GZIP)
    list(APPEND GVOX_DEFINES "-DGVOX_ENABLE_GZIP=true")
endif()
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
