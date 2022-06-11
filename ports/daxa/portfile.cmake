vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/Ipotrick/Daxa
    REF 43d7d64adbdbc2f676dbf506ff039ea7c231cce6
)
vcpkg_configure_cmake(
    SOURCE_PATH "${SOURCE_PATH}"
    PREFER_NINJA
)
vcpkg_install_cmake()
vcpkg_fixup_cmake_targets()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${SOURCE_PATH}/LICENSE"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
    RENAME copyright
)
