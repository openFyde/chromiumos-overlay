major_version: "local"
minor_version: ""
default_target_cpu: "same_as_host"

default_toolchain {
  cpu: "k8"
  toolchain_identifier: "${env}_${comp_type}"
}
default_toolchain {
  cpu: "piii"
  toolchain_identifier: "${env}_${comp_type}"
}
default_toolchain {
  cpu: "armeabi-v7a"
  toolchain_identifier: "${env}_${comp_type}"
}
default_toolchain {
  cpu: "arm"
  toolchain_identifier: "${env}_${comp_type}"
}

toolchain {
  abi_version: "local"
  abi_libc_version: "local"
  compiler: "local"
  host_system_name: "local"
  needsPic: true
  target_libc: "local"
  target_cpu: "local"
  target_system_name: "local"
  toolchain_identifier: "${env}_${comp_type}"

  feature {
    name: "determinism"
    flag_set {
      action: "c-compile"
      action: "c++-compile"
      flag_group {
        # Make C++ compilation deterministic. Use linkstamping instead of these
        # compiler symbols.
        flag: "-Wno-builtin-macro-redefined"
        flag: "-D__DATE__=\"redacted\""
        flag: "-D__TIMESTAMP__=\"redacted\""
        flag: "-D__TIME__=\"redacted\""
      }
    }
  }

  feature {
    name: "pic"
    flag_set {
      action: "c-compile"
      action: "c++-compile"
      flag_group {
        expand_if_all_available: "pic"
        flag: "-fPIC"
      }
      flag_group {
        expand_if_none_available: "pic"
        flag: "-fPIE"
      }
    }
  }

  # Security hardening on by default.
  feature {
    name: "hardening"
    flag_set {
      action: "c-compile"
      action: "c++-compile"
      flag_group {
        # Conservative choice; -D_FORTIFY_SOURCE=2 may be unsafe in some cases.
        # We need to undef it before redefining it as some distributions now
        # have it enabled by default.
        flag: "-U_FORTIFY_SOURCE"
        flag: "-D_FORTIFY_SOURCE=1"
        flag: "-fstack-protector"
      }
    }
    flag_set {
      action: "c++-link-dynamic-library"
      action: "c++-link-nodeps-dynamic-library"
      flag_group {
        flag: "-Wl,-z,relro,-z,now"
      }
    }
    flag_set {
      action: "c++-link-executable"
      flag_group {
        flag: "-pie"
        flag: "-Wl,-z,relro,-z,now"
      }
    }
  }

  feature {
    name: "warnings"
    flag_set {
      action: "c-compile"
      action: "c++-compile"
      flag_group {
        # All warnings are enabled. Maybe enable -Werror as well?
        flag: "-Wall"
        # Add another warning that is not part of -Wall.
        flag: "-Wunused-but-set-parameter"
        # But disable some that are problematic.
        flag: "-Wno-free-nonheap-object" # has false positives
      }
    }
  }

  # Anticipated future default.
  feature {
    name: "no-canonical-prefixes"
    flag_set {
      action: "c-compile"
      action: "c++-compile"
      action: "c++-link-executable"
      action: "c++-link-dynamic-library"
      action: "c++-link-nodeps-dynamic-library"
      flag_group {
        flag: "-no-canonical-prefixes"
      }
    }
  }

  feature {
    name: "disable-assertions"
    flag_set {
      action: "c-compile"
      action: "c++-compile"
      flag_group {
        flag: "-DNDEBUG"
      }
    }
  }

  feature {
    name: "linker-bin-path"

    flag_set {
      action: "c++-link-executable"
      action: "c++-link-dynamic-library"
      action: "c++-link-nodeps-dynamic-library"
      flag_group {
        flag: "-B/usr/bin/"
      }
    }
  }

  feature {
    name: "common"
    implies: "determinism"
    implies: "pic"
    implies: "hardening"
    implies: "warnings"
    implies: "no-canonical-prefixes"
    implies: "linker-bin-path"
  }

  feature {
    name: "opt"
    implies: "common"
    implies: "disable-assertions"

    flag_set {
      action: "c-compile"
      action: "c++-compile"
      flag_group {
        # No debug symbols.
        # Maybe we should enable https://gcc.gnu.org/wiki/DebugFission for opt
        # or even generally? However, that can't happen here, as it requires
        # special handling in Bazel.
        flag: "-g0"

        # Conservative choice for -O
        # -O3 can increase binary size and even slow down the resulting binaries.
        # Profile first and / or use FDO if you need better performance than this.
        flag: "-O2"

        # Removal of unused code and data at link time (can this increase binary size in some cases?).
        flag: "-ffunction-sections"
        flag: "-fdata-sections"
      }
    }
    flag_set {
      action: "c++-link-dynamic-library"
      action: "c++-link-nodeps-dynamic-library"
      action: "c++-link-executable"
      flag_group {
        flag: "-Wl,--gc-sections"
      }
    }
  }

  feature {
    name: "fastbuild"
    implies: "common"
  }

  feature {
    name: "dbg"
    implies: "common"
    flag_set {
      action: "c-compile"
      action: "c++-compile"
      flag_group {
        flag: "-g"
      }
    }
  }

  tool_path { name: "gcc" path: "${env_cc}" }

  tool_path { name: "ar" path: "${env_ar}" }
  tool_path { name: "compat-ld" path: "${env_ld}" }
  tool_path { name: "cpp" path: "${env_cpp}" }
  tool_path { name: "dwp" path: "${env_dwp}" }
  tool_path { name: "gcov" path: "${env_gcov}" }
  tool_path { name: "ld" path: "${env_ld}" }
  tool_path { name: "nm" path: "${env_nm}" }
  tool_path { name: "objcopy" path: "${env_objcopy}" }
  tool_path { name: "objdump" path: "${env_objdump}" }
  tool_path { name: "strip" path: "${env_strip}" }

  # Enabled dynamic linking.
  linking_mode_flags { mode: DYNAMIC }

${builtin_include_dirs}

  builtin_sysroot: "${env_sysroot}"
}
