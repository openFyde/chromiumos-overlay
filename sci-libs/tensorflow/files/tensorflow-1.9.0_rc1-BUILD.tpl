package(default_visibility = ["//visibility:public"])

cc_toolchain_suite(
  name = 'toolchain',
  toolchains = {
    'local|local': ':${env}_${comp_type}_compiler',
  },
)

filegroup(name = "empty")

cc_toolchain(
    name = "${env}_${comp_type}_compiler",
    all_files = ":empty",
    compiler_files = ":empty",
    cpu = "local",
    dwp_files = ":empty",
    dynamic_runtime_libs = [":empty"],
    linker_files = ":empty",
    objcopy_files = ":empty",
    static_runtime_libs = [":empty"],
    strip_files = ":empty",
    supports_param_files = 0,
)
