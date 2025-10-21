set(VCPKG_BUILD_TYPE release)  # tools
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
set(VCPKG_POLICY_MISMATCHED_NUMBER_OF_BINARIES enabled)

set(SHORT_VERSION 9.4)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Kitware/VTK
    REF 13acb1a5dd0ad7f7635f2511f44e599733643d06
    SHA512 46e22b5f21cba95f75d89f2cea3a2157437fd06bacc07e1fb35575894c35099d35b629f3caf8ebed7fa872dfa2282a59d976ec56a9dcfbbf0162806c30a9df2e
    HEAD_REF master
    PATCHES
        name-suffix.diff
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCMAKE_INSTALL_INCLUDEDIR=install/${PORT}
        -DVTK_BUILD_COMPILE_TOOLS_ONLY=ON
        -DVTK_ENABLE_LOGGING=OFF
)
vcpkg_cmake_install()
vcpkg_copy_pdbs()

# Not adjusting the directory name: The package is meant to be
# selected either explicitly, or transitively via package vtk.
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/vtkcompiletools-${SHORT_VERSION})
vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/${PORT}/vtkcompiletools-config-version.cmake" "set(PACKAGE_VERSION_UNSUITABLE TRUE)" "# allow host tools on any arch")

vcpkg_copy_tools(AUTO_CLEAN TOOL_NAMES vtkParseJava-${SHORT_VERSION} vtkWrapHierarchy-${SHORT_VERSION} vtkWrapJava-${SHORT_VERSION} vtkWrapPython-${SHORT_VERSION} vtkWrapPythonInit-${SHORT_VERSION} vtkWrapSerDes-${SHORT_VERSION})

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/doc")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/Copyright.txt")
