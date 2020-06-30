# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cros-bazel.eclass
# @MAINTAINER:
# Michael Martis <martis@chromium.org>
# @DESCRIPTION:
# A utility eclass for Chromium OS-specific additions to the Bazel eclass. In
# particular, functions supporting cross-compilation are provided.

if [[ ! ${_CROS_BAZEL_ECLASS} ]]; then

inherit bazel toolchain-funcs

# @ECLASS-VARIABLE: BAZEL_BAZELRC
# @DESCRIPTION:
# The location of the resource file used to provide Portage's build
# configuration details to Bazel. Must be kept in sync with the Bazel eclass.
BAZEL_BAZELRC="${T}/bazelrc"

# @ECLASS-VARIABLE: BAZEL_CC_BAZELRC
# @INTERNAL
# @DESCRIPTION:
# The location of the resource file specifying build configuration details for
# cross compilation (if setup). Is 'sourced' by BAZEL_BAZELRC.
BAZEL_CC_BAZELRC="${T}/cc_bazelrc"

# @ECLASS-VARIABLE: BAZEL_PORTAGE_PACKAGE_DIR
# @INTERNAL
# @DESCRIPTION:
# The directory used to store generated configuration targets (e.g. toolchain
# targets for cross compilation).
BAZEL_PORTAGE_PACKAGE_DIR="${T}/portage_packages/"

# @ECLASS-VARIABLE: BAZEL_CC_CONFIG_DIR
# @INTERNAL
# @DESCRIPTION:
# The directory (relative to BAZEL_PORTAGE_PACKAGE_DIR) in which "host" and
# "target" toolchain targets are generated for cross compilation.
BAZEL_CC_CONFIG_DIR="ebazel_cc_config"

# @ECLASS-VARIABLE: BAZEL_CC_BUILD
# @INTERNAL
# @DESCRIPTION:
# A template (with Bash-style variable placeholders) used to populate build
# files for both the "host" and "target" toolchain targets.
# shellcheck disable=SC2016
BAZEL_CC_BUILD='package(default_visibility = ["//visibility:public"])

filegroup(name = "empty")

# We should really be using @platforms//cpu:x86_64 and friends, but
# to keep this compatible with Bazel 0.24.1, we need to use the legacy
# definitions.
# TODO(crbug/1102798): Once Bazel is uprevved, change these to the @platforms defs.
amd64_constraints = [
	"@bazel_tools//platforms:x86_64",
	"@bazel_tools//platforms:linux",
]

k8_constraints = amd64_constraints

arm_constraints = [
	"@bazel_tools//platforms:arm",
	"@bazel_tools//platforms:linux",
]

platform(
	name = "amd64_platform",
	constraint_values = amd64_constraints,
)

platform(
	name = "k8_platform",
	constraint_values = k8_constraints,
)

platform(
	name = "arm_platform",
	constraint_values = arm_constraints,
)

cc_toolchain_suite(
	name = "toolchain",
	toolchains = {
		"amd64|local": "portage_toolchain",
		"arm|local": "portage_toolchain",
		"arm64|local": "portage_toolchain",
		"k8|local": "portage_toolchain",
	},
)

cc_toolchain(
	name = "portage_toolchain",
	toolchain_identifier = "portage-toolchain",
	toolchain_config = ":portage_toolchain_config",
	all_files = ":empty",
	compiler_files = ":empty",
	dwp_files = ":empty",
	linker_files = ":empty",
	objcopy_files = ":empty",
	strip_files = ":empty",
	supports_param_files = 0,
)

toolchain(
	name = "cc-toolchain-${cpu_str}",
	# compilation execution is always on the host, hence amd64
	exec_compatible_with = amd64_constraints,
	target_compatible_with = ${cpu_str}_constraints,
	toolchain = ":portage_toolchain",
	toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

load(":cc_toolchain_config.bzl", "cc_toolchain_config")
cc_toolchain_config(name = "portage_toolchain_config")
'

# @ECLASS-VARIABLE: BAZEL_CC_TOOLCHAIN_CONFIG
# @INTERNAL
# @DESCRIPTION:
# Skylark implementation of the cc toolchain, using Bash-style variables
# to populate the build file.
# The original CROSSTOOL had many features that weren't enabled.
# PIC should be the only thing we need.
BAZEL_CC_TOOLCHAIN_CONFIG='
load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load(
  "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
  "feature",
  "flag_group",
  "flag_set",
  "tool_path",
)

features = [
	feature(name="supports_pic", enabled=True),
]

def _impl(ctx):
  tool_paths = [
    tool_path(name = "gcc", path = "${env_cc}"),
    tool_path(name = "ar", path = "${env_ar}"),
    tool_path(name = "compat-ld", path = "${env_ld}"),
    tool_path(name = "cpp", path = "${env_cpp}"),
    tool_path(name = "dwp", path = "${env_dwp}"),
    tool_path(name = "gcov", path = "${env_gcov}"),
    tool_path(name = "ld", path = "${env_ld}"),
    tool_path(name = "nm", path = "${env_nm}"),
    tool_path(name = "objcopy", path = "${env_objcopy}"),
    tool_path(name = "objdump", path = "${env_objdump}"),
    tool_path(name = "strip", path = "${env_strip}"),
  ]

  return cc_common.create_cc_toolchain_config_info(
    ctx = ctx,
    features = features,
    cxx_builtin_include_directories = [
      ${builtin_include_dirs}
    ],
    toolchain_identifier = "portage-toolchain",
    host_system_name = "local",
    target_system_name = "local",
    target_cpu = "${cpu_str}",
    target_libc = "local",
    compiler = "local",
    abi_version = "local",
    abi_libc_version = "local",
    tool_paths = tool_paths,
  )

cc_toolchain_config = rule(
  implementation = _impl,
  attrs = {},
  provides = [CcToolchainConfigInfo],
)
'

# @FUNCTION: bazel_get_builtin_include_dirs
# @USAGE: <compiler binary>
# @RETURN:
# A list of the directories that are searched by default on invocation of the
# given compiler's preprocessor. These directories are normalized (e.g.
# parsing "..") and formatted as a python list of strings.
# @MAINTAINER:
# Michael Martis <martis@chromium.org>
# @INTERNAL
bazel_get_builtin_include_dirs() {
	# Constants that demarcate default include dir information.
	local match_head="#include <...> search starts here:"
	local match_foot="End of search list."

	local comp="${1}"

	# Get preprocessor output (which contains searched include dirs).
	local preproc_output
	preproc_output="$("${comp}" -E -xc++ -Wp,-v - 2>&1 <<< "int main() { return 0; }" || die)"

	# Keep only the include dirs (which are between two known markers).
	local include_dirs
	include_dirs="$(sed "1,/${match_head}/d;/${match_foot}/,\$d" <<< "${preproc_output}" || die)"

	# For each include dir...
	while read -r include_dir; do
		# Normalize (e.g. process '..' sequences in) the path.
		local norm_dir
		# shellcheck disable=SC2015
		norm_dir="$(cd "${include_dir}" && pwd || die)"

		# Print the normalized path as a proto field.
		echo "\"${norm_dir}\","
	done <<< "${include_dirs}"
}

# @FUNCTION: bazel_populate_crosstool_target
# @USAGE: <sysroot> <prefix> <cpu string> <output directory>
# @MAINTAINER:
# Michael Martis <martis@chromium.org>
# @INTERNAL
# @DESCRIPTION:
# Accepts an environment sysroot, environment prefix (used to locate correct
# binaries for the environment) and environment CPU string (either '' or
# 'BUILD_'), and populates Bazel toolchain targets for the specified
# environment in the given output directory.
bazel_populate_crosstool_target() {
	local env_sysroot="${1}"
	local env_prefix="${2}"
	local cpu_str="${3}"
	local output_dir="${4}"

	# Query compiler type (gcc / clang) from environment variables.
	local comp_type
	comp_type="$("tc-get-${env_prefix}compiler-type" || die)"

	# Get actual compiler binary.
	local comp
	comp="$("tc-get${env_prefix}CC" || die)"

	# Write out the BUILD file for this configuration.
	cpu_str="${cpu_str}" \
	envsubst <<< "${BAZEL_CC_BUILD}" > "${output_dir}/BUILD" || die

	# Write out the toolchain_config file for this configuration.
	cpu_str="${cpu_str}" \
	builtin_include_dirs="$(bazel_get_builtin_include_dirs "${comp}" || die)" \
	env_sysroot="${env_sysroot}" \
	env_cc="$(command -v "${comp}" || die)" \
	env_ar="$(command -v "$("tc-get${env_prefix}AR")" || die)" \
	env_ld="$(command -v "$("tc-get${env_prefix}LD")" || die)" \
	env_cpp="$(command -v "$("tc-get${env_prefix}PROG" CPP cpp)" || die)" \
	env_dwp="$(command -v "$("tc-get${env_prefix}DWP")" || die)" \
	env_gcov="$(command -v "$("tc-get${env_prefix}GCOV")" || die)" \
	env_nm="$(command -v "$("tc-get${env_prefix}NM")" || die)" \
	env_objcopy="$(command -v "$("tc-get${env_prefix}OBJCOPY")" || die)" \
	env_objdump="$(command -v "$("tc-get${env_prefix}OBJDUMP")" || die)" \
	env_strip="$(command -v "$("tc-get${env_prefix}STRIP")" || die)" \
	envsubst <<< "${BAZEL_CC_TOOLCHAIN_CONFIG}" > \
	"${output_dir}/cc_toolchain_config.bzl" || die
}

# @FUNCTION: bazel_get_stdlib_linkflag
# @USAGE: <compiler type>
# @RETURN: The correct stdlib linking flag for the given compiler type.
# @MAINTAINER:
# Michael Martis <martis@chromium.org>
# @INTERNAL
bazel_get_stdlib_linkflag() {
	case "${1}" in
	clang) echo "-lc++";;
	gcc) echo "-lstdc++";;
	*) die "Unsupported compiler type '${comp_type}'."
	esac
}

# @FUNCTION: bazel_setup_crosstool
# @USAGE: <host cpu string> <target cpu string>
# @MAINTAINER:
# Michael Martis <martis@chromium.org>
# @DESCRIPTION:
# Accepts Bazel "host" and "target" CPU strings, and creates Bazel targets
# (under ${T}) that can be used to configure Bazel C++ compilation based on
# Portage environment variables.
#
# Also updates the bazelrc to specify the new crosstool targets by default.
#
# Should only be called once; subsequent calls will have no effect.
bazel_setup_crosstool() {
	if [[ -f "${BAZEL_CC_BAZELRC}" ]]; then
		return
	fi

	bazel_setup_bazelrc

	local host_cpu_str="${1}"
	if [[ -z "${host_cpu_str}" ]]; then
		die "Must specify host CPU string when generating Bazel CROSSTOOL targets."
	fi

	local target_cpu_str="${2}"
	if [[ -z "${target_cpu_str}" ]]; then
		die "Must specify target CPU string when generating Bazel CROSSTOOL targets."
	fi

	# Populate host toolchain targets.
	local host_crosstool_dir="${BAZEL_PORTAGE_PACKAGE_DIR}/${BAZEL_CC_CONFIG_DIR}/host"
	mkdir -p "${host_crosstool_dir}" || die
	bazel_populate_crosstool_target / BUILD_ "${host_cpu_str}" "${host_crosstool_dir}"

	# Populate target toolchain targets.
	local target_crosstool_dir="${BAZEL_PORTAGE_PACKAGE_DIR}/${BAZEL_CC_CONFIG_DIR}/target"
	mkdir -p "${target_crosstool_dir}" || die
	bazel_populate_crosstool_target "${PORTAGE_CONFIGROOT}" "" "${target_cpu_str}" "${target_crosstool_dir}"

	# Create a bazelrc specifying the new toolchain targets by default.
	cat > "${BAZEL_CC_BAZELRC}" <<-EOF || die
	# Make Bazel respect Portage C/C++ configuration.
	build --package_path="%workspace%:${BAZEL_PORTAGE_PACKAGE_DIR}"
	build --host_crosstool_top="//${BAZEL_CC_CONFIG_DIR}/host:toolchain" --crosstool_top="//${BAZEL_CC_CONFIG_DIR}/target:toolchain"
	build --host_cpu="${host_cpu_str}" --cpu="${target_cpu_str}" --compiler=local --host_compiler=local
	build --host_platform="//${BAZEL_CC_CONFIG_DIR}/host:${host_cpu_str}_platform"
	build --platforms="//${BAZEL_CC_CONFIG_DIR}/target:${target_cpu_str}_platform"
	build --extra_toolchains="//${BAZEL_CC_CONFIG_DIR}/target:cc-toolchain-${target_cpu_str}"

	# This is super helpful for figuring out how the toolchain is determined
	# build --toolchain_resolution_debug

	# Add correct standard library link flags.
	build --linkopt="$(bazel_get_stdlib_linkflag "$(tc-get-compiler-type)" || die)"
	build --host_linkopt="$(bazel_get_stdlib_linkflag "$(tc-get-BUILD_compiler-type)" || die)"

	# Some compiler scripts require SYSROOT defined.
	build --action_env SYSROOT="${PORTAGE_CONFIGROOT}"

	# In case another config has disabled cross-compilation, re-enable it here.
	build --distinct_host_configuration
	EOF

	echo "import ${BAZEL_CC_BAZELRC}" >> "${BAZEL_BAZELRC}" || die
}


_CROS_BAZEL_ECLASS=1
fi
