find_package(LLVM REQUIRED CONFIG)

llvm_map_components_to_libnames(llvm_libs
    core
    support
    analysis
    executionengine
    interpreter
    native
)

add_library(llvm INTERFACE)
target_include_directories(llvm INTERFACE ${LLVM_INCLUDE_DIRS})
target_link_libraries(llvm INTERFACE ${llvm_libs})
target_compile_definitions(llvm INTERFACE ${LLVM_DEFINITIONS})
