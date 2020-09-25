ExternalProject_Add(googletest
    GIT_REPOSITORY  "https://github.com/google/googletest.git"
    GIT_TAG         "master"
    PREFIX          "${CMAKE_CURRENT_BINARY_DIR}/googletest"
    SOURCE_DIR      "${CMAKE_CURRENT_BINARY_DIR}/googletest/src"
    BINARY_DIR      "${CMAKE_CURRENT_BINARY_DIR}/googletest/build"
    STAMP_DIR       "${CMAKE_CURRENT_BINARY_DIR}/googletest/stamp"
    UPDATE_COMMAND  ""
    INSTALL_COMMAND ""
    TEST_COMMAND    ""
    CMAKE_ARGS
        -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_BUILD_TYPE=Release
)

ExternalProject_Get_Property(googletest source_dir)
ExternalProject_Get_Property(googletest binary_dir)

add_library(googletest::gtest STATIC IMPORTED)

make_directory("${source_dir}/googletest/include") # To suppress non-exist directory warnings

set_target_properties(googletest::gtest PROPERTIES
    IMPORTED_LOCATION "${binary_dir}/lib/libgtest.a"
    INTERFACE_INCLUDE_DIRECTORIES "${source_dir}/googletest/include"
)

add_library(googletest::gtest_main STATIC IMPORTED)

set_target_properties(googletest::gtest_main PROPERTIES
    IMPORTED_LOCATION "${binary_dir}/lib/libgtest_main.a"
)

add_dependencies(googletest::gtest googletest)
add_dependencies(googletest::gtest_main googletest)
