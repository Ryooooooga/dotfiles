ExternalProject_Add(fmt
    GIT_REPOSITORY  "https://github.com/fmtlib/fmt.git"
    GIT_TAG         "master"
    PREFIX          "${CMAKE_CURRENT_BINARY_DIR}/fmt"
    SOURCE_DIR      "${CMAKE_CURRENT_BINARY_DIR}/fmt/src"
    BINARY_DIR      "${CMAKE_CURRENT_BINARY_DIR}/fmt/build"
    STAMP_DIR       "${CMAKE_CURRENT_BINARY_DIR}/fmt/stamp"
    UPDATE_COMMAND  ""
    INSTALL_COMMAND ""
    TEST_COMMAND    ""
    CMAKE_ARGS
        -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_BUILD_TYPE=Release
        -DFMT_DOC=OFF
        -DFMT_TEST=OFF
)

ExternalProject_Get_Property(fmt source_dir)
ExternalProject_Get_Property(fmt binary_dir)

add_library(fmtlib::fmt STATIC IMPORTED)

make_directory("${source_dir}/include") # To suppress non-exist directory warnings

set_target_properties(fmtlib::fmt PROPERTIES
    IMPORTED_LOCATION "${binary_dir}/libfmt.a"
    INTERFACE_INCLUDE_DIRECTORIES "${source_dir}/include"
)

add_dependencies(fmtlib::fmt fmt)
