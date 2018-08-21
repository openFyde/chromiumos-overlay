# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python2_7 python3_{5,6} )
MY_PV=${PV/_rc/-rc}
MY_P=${PN}-${MY_PV}

inherit distutils-r1 multiprocessing toolchain-funcs

DESCRIPTION="Computation framework using data flow graphs for scalable machine learning"
HOMEPAGE="https://www.tensorflow.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="cuda jemalloc mpi minimal +python"
CPU_USE_FLAGS_X86="sse sse2 sse3 sse4_1 sse4_2 avx avx2 fma3 fma4"
for i in $CPU_USE_FLAGS_X86; do
	IUSE+=" cpu_flags_x86_$i"
done

# distfiles that bazel uses for the workspace, will be copied to basel-distdir
bazel_external_uris="
	https://github.com/google/flatbuffers/archive/971a68110e4fc1bace10fcb6deeb189e7e1a34ce.tar.gz -> flatbuffers-971a68110e4fc1bace10fcb6deeb189e7e1a34ce.tar.gz
	https://github.com/intel/ARM_NEON_2_x86_SSE/archive/0f77d9d182265259b135dad949230ecbf1a2633d.tar.gz -> ARM_NEON_2_x86_SSE-0f77d9d182265259b135dad949230ecbf1a2633d.tar.gz
	https://github.com/bazelbuild/rules_closure/archive/dbb96841cc0a5fb2664c37822803b06dab20c7d1.tar.gz -> bazelbuild-rules_closure-dbb96841cc0a5fb2664c37822803b06dab20c7d1.tar.gz
	https://github.com/google/protobuf/archive/396336eb961b75f03b25824fe86cf6490fb75e3a.tar.gz -> protobuf-396336eb961b75f03b25824fe86cf6490fb75e3a.tar.gz
	https://github.com/google/gemmlowp/archive/38ebac7b059e84692f53e5938f97a9943c120d98.zip -> gemmlowp-38ebac7b059e84692f53e5938f97a9943c120d98.zip
	https://bitbucket.org/eigen/eigen/get/6913f0cf7d06.tar.gz -> eigen-6913f0cf7d06.tar.gz
	https://github.com/google/farmhash/archive/816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz -> farmhash-816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz
	http://www.kurims.kyoto-u.ac.jp/~ooura/fft.tgz -> oourafft-20061228.tgz
	!minimal? (
		http://pilotfiber.dl.sourceforge.net/project/giflib/giflib-5.1.4.tar.gz
		http://pkgs.fedoraproject.org/repo/pkgs/nasm/nasm-2.12.02.tar.bz2/d15843c3fb7db39af80571ee27ec6fad/nasm-2.12.02.tar.bz2
		https://github.com/LMDB/lmdb/archive/LMDB_0.9.19.tar.gz
		https://github.com/abseil/abseil-cpp/archive/9613678332c976568272c8f4a78631a29159271d.tar.gz -> abseil-cpp-9613678332c976568272c8f4a78631a29159271d.tar.gz
		https://github.com/glennrp/libpng/archive/v1.6.34.tar.gz -> libpng-v1.6.34.tar.gz
		https://github.com/google/double-conversion/archive/3992066a95b823efc8ccc1baf82a1cfc73f6e9b8.zip -> double-conversion-3992066a95b823efc8ccc1baf82a1cfc73f6e9b8.zip
		https://github.com/google/highwayhash/archive/fd3d9af80465e4383162e4a7c5e2f406e82dd968.tar.gz -> highwayhash-fd3d9af80465e4383162e4a7c5e2f406e82dd968.tar.gz
		https://github.com/google/nsync/archive/0559ce013feac8db639ee1bf776aca0325d28777.tar.gz -> nsync-0559ce013feac8db639ee1bf776aca0325d28777.tar.gz
		https://github.com/google/re2/archive/26cd968b735e227361c9703683266f01e5df7857.tar.gz -> re2-26cd968b735e227361c9703683266f01e5df7857.tar.gz
		https://github.com/google/snappy/archive/1.1.7.tar.gz -> snappy-1.1.7.tar.gz
		https://github.com/grpc/grpc/archive/d184fa229d75d336aedea0041bd59cb93e7e267f.tar.gz -> grpc-d184fa229d75d336aedea0041bd59cb93e7e267f.tar.gz
		https://github.com/libjpeg-turbo/libjpeg-turbo/archive/1.5.3.tar.gz -> libjpeg_turbo-1.5.3.tar.gz
		https://github.com/open-source-parsers/jsoncpp/archive/11086dd6a7eba04289944367ca82cea71299ed70.tar.gz -> jsoncpp-11086dd6a7eba04289944367ca82cea71299ed70.tar.gz
		https://www.sqlite.org/2018/sqlite-amalgamation-3230100.zip
		https://zlib.net/zlib-1.2.11.tar.gz
		https://github.com/jemalloc/jemalloc/archive/4.4.0.tar.gz -> jemalloc-4.4.0.tar.gz
	)
	python? (
		http://ftp.exim.org/pub/pcre/pcre-8.39.tar.gz
		http://ufpr.dl.sourceforge.net/project/swig/swig/swig-3.0.8/swig-3.0.8.tar.gz
		https://curl.haxx.se/download/curl-7.49.1.tar.gz
		https://github.com/NVlabs/cub/archive/1.8.0.zip -> cub-1.8.0.zip
		https://github.com/abseil/abseil-py/archive/ea8c4d2ddbf3fba610c4d613260561699b776db8.tar.gz -> abseil-py-ea8c4d2ddbf3fba610c4d613260561699b776db8.tar.gz
		https://github.com/aws/aws-sdk-cpp/archive/1.3.15.tar.gz -> aws_sdk_cpp-1.3.15.tar.gz
		https://github.com/cython/cython/archive/3732784c45cfb040a5b0936951d196f83a12ea17.tar.gz -> cython-3732784c45cfb040a5b0936951d196f83a12ea17.tar.gz
		https://github.com/edenhill/librdkafka/archive/v0.11.1.tar.gz -> librdkafka-v0.11.1.tar.gz
		https://github.com/google/boringssl/archive/a0fb951d2a26a8ee746b52f3ba81ab011a0af778.tar.gz -> boringssl-a0fb951d2a26a8ee746b52f3ba81ab011a0af778.tar.gz
		https://github.com/hfp/libxsmm/archive/1.8.1.tar.gz -> libxsmm-1.8.1.tar.gz
		https://github.com/intel/mkl-dnn/archive/v0.12.tar.gz -> mkl_dnn-v0.12.tar.gz
		https://github.com/llvm-mirror/llvm/archive/7e78daafdd22f3f17720a103d29d89590534004e.tar.gz -> llvm-7e78daafdd22f3f17720a103d29d89590534004e.tar.gz
		https://mirror.bazel.build/docs.python.org/2.7/_sources/license.txt -> tensorflow-python-license.txt
		https://pypi.python.org/packages/5c/78/ff794fcae2ce8aa6323e789d1f8b3b7765f601e7702726f430e814822b96/gast-0.2.0.tar.gz
		https://pypi.python.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz
		https://pypi.python.org/packages/bc/cc/3cdb0a02e7e96f6c70bd971bc8a90b8463fda83e264fa9c5c1c98ceabd81/backports.weakref-1.0rc1.tar.gz
		https://pypi.python.org/packages/d8/be/c4276b3199ec3feee2a88bc64810fbea8f26d961e0a4cd9c68387a9f35de/astor-0.6.2.tar.gz
		https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz
	)"

SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
		${bazel_external_uris}"

RDEPEND="python? (
		${PYTHON_DEPS}
	)"
DEPEND="${RDEPEND}
	!python? ( dev-lang/python )
	app-arch/unzip
	dev-python/mock
	"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} !minimal )"

S="${WORKDIR}/${MY_P}"
BUILD_DIR="${S}"

DOCS=( AUTHORS CONTRIBUTING.md ISSUE_TEMPLATE.md README.md RELEASE.md )

PATCHES=( "${FILESDIR}/tensorflow-1.9.0_rc1-lite-lib.patch" )

bazel_cc_config_dir="ebazel_cc_config"

# Accepts a compiler, and returns the directories that are searched by default
# on invocation of its preprocessor.
# These directories are normalized (e.g. parsing "..") and formatted as
# cxx_builtin_include_directory fields of the CToolchain proto message.
bazel-get-builtin-include-dirs() {
	# Constants that demarcate default include dir information.
	local match_head="#include <...> search starts here:"
	local match_foot="End of search list."

	local comp="${1}"

	# Get preprocessor output (which contains searched include dirs).
	local preproc_output
	preproc_output=$("${comp}" -E -xc++ -Wp,-v - 2>&1 <<< "int main() { return 0; }") || die

	# Keep only the include dirs (which are between two known markers).
	local include_dirs
	include_dirs=$(sed "1,/${match_head}/d;/${match_foot}/,\$d" <<< "${preproc_output}") || die

	# For each include dir...
	while read -r include_dir; do
		# Normalize (e.g. process '..' sequences in) the path.
		local norm_dir
		norm_dir=$(cd "${include_dir}" && pwd) || die

		# Print the normalized path as a proto field.
		echo "  cxx_builtin_include_directory: \"${norm_dir}\""
	done <<< "${include_dirs}"
}

bazel-get-cpu-flags() {
	local i f=()
	# Keep this list in sync with tensorflow/core/platform/cpu_feature_guard.cc.
	for i in sse sse2 sse3 sse4_1 sse4_2 avx avx2 fma4; do
		use cpu_flags_x86_${i} && f+=( -m${i/_/.} )
	done
	use cpu_flags_x86_fma3 && f+=( -mfma )
	echo "${f[*]}"
}

# Echos the correct stdlib linking flag for the given compiler type.
bazel-get-stdlib-linkflag() {
	case "${1}" in
	clang) echo "-lc++";;
	gcc) echo "-lstdc++";;
	*) die "Unsupported compiler type '${comp_type}'."
	esac
}

bazel-get-flags() {
	local i fs=()

	# Add CPU flags for C and C++.
	for i in $(bazel-get-cpu-flags); do
		fs+=( "--copt=${i}" "--cxxopt=${i}" )
	done

	# Add C flags (also for the build environment).
	for i in ${CFLAGS}; do
		fs+=( "--copt=${i}" )
	done

	for i in ${BUILD_CFLAGS}; do
		fs+=( "--host_copt=${i}" )
	done

	# Add C++ flags (also for the build environment).
	for i in ${CXXFLAGS}; do
		fs+=( "--cxxopt=${i}" )
	done

	for i in ${BUILD_CXXFLAGS}; do
		fs+=( "--host_cxxopt=${i}" )
	done

	# Add linker flags (also for the build environment).
	for i in ${LDFLAGS}; do
		fs+=( "--linkopt=${i}" )
	done

	for i in ${BUILD_LDFLAGS}; do
		fs+=( "--host_linkopt=${i}" )
	done

	# Add preprocessor flags for C/C++ (also for the build environment).
	for i in ${CPPFLAGS}; do
		fs+=( "--copt=${i}" "--cxxcopt=${i}" )
	done

	for i in ${BUILD_CPPFLAGS}; do
		fs+=( "--host_copt=${i}" "--host_cxxopt=${i}" )
	done

	# Add correct C++ standard lib (also for the build environment).
	fs+=( "--linkopt=$(bazel-get-stdlib-linkflag $(tc-get-compiler-type))" )
	fs+=( "--host_linkopt=$(bazel-get-stdlib-linkflag $(tc-get-BUILD_compiler-type))" )

	echo "${fs[*]}"
}

# Accepts an environment sysroot, environment prefix (used to locate correct
# binaries for the environment) and environment CPU string, and populates Bazel
# toolchain targets for the specified environment in the given output
# directory.
populate_crosstool_target() {
	local env_sysroot="${1}"
	local env_prefix="${2}"
	local cpu_str="${3}"
	local output_dir="${4}"

	# Query compiler type (gcc / clang) from environment variables.
	local comp_type
	comp_type="$(tc-get-${env_prefix}compiler-type)" || die

	# Get actual compiler binary.
	local comp
	comp="$(tc-get${env_prefix}CC)" || die

	# Write out the BUILD file for this configuration.
	cpu_str="${cpu_str}" \
	envsubst < "${FILESDIR}/tensorflow-1.9.0_rc1-BUILD.tpl" > "${output_dir}/BUILD" || die

	# Write out the CROSSTOOL file for this configuration, including formatted
	# include directories and compiler / linker flags from the environment.
	#
	# We call tc-getPROG directly for cpp, since we require a program that directly
	# performs preprocessing (i.e. takes no flags), whereas tc-getCPP returns an
	# invocation of the compiler for preprocessing (which uses flags).
	cpu_str="${cpu_str}" \
	builtin_include_dirs="$(bazel-get-builtin-include-dirs ${comp})" \
	env_sysroot="${env_sysroot}" \
	env_cc="$(command -v ${comp})" \
	env_ar="$(command -v $(tc-get${env_prefix}AR))" \
	env_ld="$(command -v $(tc-get${env_prefix}LD))" \
	env_cpp="$(command -v $(tc-get${env_prefix}PROG CPP cpp))" \
	env_dwp="$(command -v $(tc-get${env_prefix}DWP))" \
	env_gcov="$(command -v $(tc-get${env_prefix}GCOV))" \
	env_nm="$(command -v $(tc-get${env_prefix}NM))" \
	env_objcopy="$(command -v $(tc-get${env_prefix}OBJCOPY))" \
	env_objdump="$(command -v $(tc-get${env_prefix}OBJDUMP))" \
	env_strip="$(command -v $(tc-get${env_prefix}STRIP))" \
	envsubst < "${FILESDIR}/tensorflow-1.9.0_rc1-CROSSTOOL.tpl" > "${output_dir}/CROSSTOOL" || die
}

# Accepts Bazel "host" and "target" CPU strings and a Bazel project
# directory, and creates Bazel targets:
#   <project_dir>/ebazel_cc_config/{host,target}:toolchain
# which can be used to configure Bazel C++ compilation based on Portage
# environment variables.
#
# Also creates <project_dir>/ebazel_cc_config/bazelrc which specifies
# the new crosstool targets by default.
setup_bazel_crosstool() {
	local host_cpu_str="${1}"
	if [[ -z "${host_cpu_str}" ]]; then
		die "Must specify host CPU string when generating Bazel CROSSTOOL targets."
	fi

	local target_cpu_str="${2}"
	if [[ -z "${target_cpu_str}" ]]; then
		die "Must specify target CPU string when generating Bazel CROSSTOOL targets."
	fi

	# Check that the project dir exists.
	local project_dir="${3}"
	if [[ ! -d "${project_dir}" ]]; then
		die "Bazel project dir '${project_dir}' does not exist."
	fi

	# Populate host toolchain targets.
	local host_crosstool_dir="${project_dir}/${bazel_cc_config_dir}/host"
	mkdir -p "${host_crosstool_dir}" || die
	populate_crosstool_target / BUILD_ "${host_cpu_str}" "${host_crosstool_dir}"

	# Populate target toolchain targets.
	local target_crosstool_dir="${project_dir}/${bazel_cc_config_dir}/target"
	mkdir -p "${target_crosstool_dir}" || die
	populate_crosstool_target "${PORTAGE_CONFIGROOT}" "" "${target_cpu_str}" "${target_crosstool_dir}"

	# Create a bazelrc specifying the new toolchain targets by default.
	cat > "${project_dir}/${bazel_cc_config_dir}/bazelrc" <<-EOF
	# Make Bazel respect Portage C/C++ configuration.
	build --host_crosstool_top="//${bazel_cc_config_dir}/host:toolchain" --crosstool_top="//${bazel_cc_config_dir}/target:toolchain"
	build --host_cpu="${host_cpu_str}" --cpu="${target_cpu_str}"

	# Some compiler scripts require SYSROOT defined.
	build --action_env SYSROOT="${PORTAGE_CONFIGROOT}"
	EOF
}

setup_bazelrc() {
	# F: fopen_wr
	# P: /proc/self/setgroups
	# Even with standalone enabled, the Bazel sandbox binary is run for feature test:
	# https://github.com/bazelbuild/bazel/blob/7b091c1397a82258e26ab5336df6c8dae1d97384/src/main/java/com/google/devtools/build/lib/sandbox/LinuxSandboxedSpawnRunner.java#L61
	# https://github.com/bazelbuild/bazel/blob/76555482873ffcf1d32fb40106f89231b37f850a/src/main/tools/linux-sandbox-pid1.cc#L113
	addpredict /proc

	mkdir -p "${T}/bazel-cache" || die
	mkdir -p "${T}/bazel-distdir" || die

	cat > "${T}/bazelrc" <<-EOF
	startup --batch

	# dont strip HOME, portage sets a temp per-package dir
	build --action_env HOME

	# make bazel respect MAKEOPTS
	build --jobs=$(makeopts_jobs) $(bazel-get-flags)
	build --compilation_mode=opt --host_compilation_mode=opt

	# Use standalone strategy to deactivate the bazel sandbox, since it
	# conflicts with FEATURES=sandbox.
	build --spawn_strategy=standalone --genrule_strategy=standalone
	test --spawn_strategy=standalone --genrule_strategy=standalone

	build --strip=never
	build --verbose_failures --noshow_loading_progress
	test --verbose_test_summary --verbose_failures --noshow_loading_progress

	# make bazel only fetch distfiles from the cache
	fetch --repository_cache=${T}/bazel-cache/ --experimental_distdir=${T}/bazel-distdir/
	build --repository_cache=${T}/bazel-cache/ --experimental_distdir=${T}/bazel-distdir/
	EOF
}

ebazel() {
	# Use different build folders for each multibuild variant.
	local base_suffix="${MULTIBUILD_VARIANT+-}${MULTIBUILD_VARIANT}"
	local output_base="${WORKDIR}/bazel-base${base_suffix}"
	mkdir -p "${output_base}" || die

	einfo Running: bazel --output_base="${output_base}" "$@"
	bazel --output_base="${output_base}" $@ || die
}

load_distfiles() {
	# Populate the bazel distdir to fetch from since it cannot use the network
	# Bazel looks in distdir but will only look for the original filename, not
	# the possibly renamed one that portage downloaded. If the line has -> we
	# need to rename it back, otherwise a simple copy is fine.

	local src dst uri rename

	while read uri rename dst; do
		src="${uri##*/}"
		[[ -z $src ]] && continue
		if [[ "$rename" != "->" ]]; then
			dst="${src}"
		fi

		[[ ${A} =~ ${dst} ]] || continue

		if [[ "$dst" == "$src" ]]; then
			einfo "Copying $dst to bazel distdir $src ..."
		else
			einfo "Copying $dst to bazel distdir ..."
		fi
		cp "${DISTDIR}/${dst}" "${T}/bazel-distdir/${src}" || die
	done <<< "$(sed -re 's/!?[A-Za-z]+\?\s+\(\s*//g; s/\s+\)//' <<< "${bazel_external_uris}")"
}

# Echos the CPU string that TensorFlow uses to refer to the given architecture.
get-tf-cpu-str() {
	local arch
	arch="$(tc-arch "${1}")"

	case "${arch}" in
	amd64) echo "k8";;
	arm) echo "arm";;
	*) die "Unsupported architecture '${arch}'."
	esac
}

pkg_setup() {
	JAVA_HOME=/etc/java-config-2/current-system-vm/
}

src_unpack() {
	# Only unpack the main distfile
	unpack "${P}.tar.gz"
}

src_prepare() {
	setup_bazel_crosstool "$(get-tf-cpu-str "${CBUILD}")" "$(get-tf-cpu-str "${CHOST}")" "${BUILD_DIR}"
	setup_bazelrc
	load_distfiles

	default
	use python && python_copy_sources
}

src_configure() {
	do_configure() {
		export CC_OPT_FLAGS=""
		export GCC_HOST_COMPILER_PATH="$(which $(tc-getBUILD_CC))"
		export TF_NEED_JEMALLOC=$(usex jemalloc 1 0)
		export TF_NEED_GCP=0
		export TF_NEED_HDFS=0
		export TF_NEED_S3=0
		export TF_NEED_KAFKA=0
		export TF_ENABLE_XLA=0
		export TF_NEED_GDR=0
		export TF_NEED_VERBS=0
		export TF_NEED_OPENCL_SYCL=0
		export TF_NEED_OPENCL=0
		export TF_NEED_COMPUTECPP=0
		export TF_NEED_MKL=0
		export TF_NEED_MPI=$(usex mpi 1 0)
		export TF_DOWNLOAD_CLANG=0
		export TF_NEED_CUDA=$(usex cuda 1 0)
		export TF_SET_ANDROID_WORKSPACE=0

		if use python; then
			python_export PYTHON_SITEDIR
			export PYTHON_BIN_PATH="${PYTHON}"
			export PYTHON_LIB_PATH="${PYTHON_SITEDIR}"
		else
			export PYTHON_BIN_PATH="$(which python)"
			export PYTHON_LIB_PATH="$(python -c 'from distutils.sysconfig import *; print(get_python_lib())')"
		fi

		# Only one bazelrc is read, import ours before configure sets its options
		echo "import ${T}/bazelrc" >> ./.bazelrc
		echo "import ${BUILD_DIR}/${bazel_cc_config_dir}/bazelrc" >> ./.bazelrc

		# This is not autoconf
		./configure || die

		sed -i '/strip=always/d' .tf_configure.bazelrc || die
	}
	if use python; then
		python_foreach_impl run_in_build_dir do_configure
	else
		do_configure
	fi
}

src_compile() {
	if use python; then
		python_setup
		local MULTIBUILD_VARIANT="${EPYTHON/./_}"
		cd "${S}-${MULTIBUILD_VARIANT}" || die
	fi

	ebazel build \
		$(usex cuda --config=cuda '') \
		$(usex minimal '' '//tensorflow:libtensorflow_framework.so //tensorflow:libtensorflow.so //tensorflow:libtensorflow_cc.so') \
		//tensorflow/contrib/lite:libtensorflow_lite.so

	do_compile() {
		ebazel build \
			$(usex cuda --config=cuda '') \
			//tensorflow/tools/pip_package:build_pip_package
	}
	use python && python_foreach_impl run_in_build_dir do_compile
}

src_install() {
	do_install() {
		einfo "Installing ${EPYTHON} files"
		local srcdir="${T}/src-${EPYTHON/./_}"
		mkdir -p "${srcdir}" || die
		bazel-bin/tensorflow/tools/pip_package/build_pip_package --src "${srcdir}" || die
		cd "${srcdir}" || die
		esetup.py install

		# It installs site-packages/external but shouldnt
		python_export PYTHON_SITEDIR
		rm -rf "${D}/${PYTHON_SITEDIR}/external" || die
		sed -i '/^external/d' "${D}/${PYTHON_SITEDIR}"/${P/_rc/rc}-*.egg-info/{SOURCES,top_level}.txt || die

		# Symlink to the main .so file
		rm -rf "${D}/${PYTHON_SITEDIR}/${PN}/lib${PN}_framework.so" || die
		dosym "../../../lib${PN}_framework.so" "${PYTHON_SITEDIR}/${PN}/lib${PN}_framework.so" || die

		python_optimize
	}

	if use python; then
		python_foreach_impl run_in_build_dir do_install

		# Symlink to python-exec scripts
		for i in "${D}"/usr/lib/python-exec/*/*; do
			n="${i##*/}"
			[[ -e "${D}/usr/bin/${n}" ]] || dosym ../lib/python-exec/python-exec2 "/usr/bin/$n"
		done

		python_setup
		local MULTIBUILD_VARIANT="${EPYTHON/./_}"
		cd "${S}-${MULTIBUILD_VARIANT}" || die
	fi

	local base_suffix="${MULTIBUILD_VARIANT+-}${MULTIBUILD_VARIANT}"
	local output_base="${WORKDIR}/bazel-base${base_suffix}"

	if ! use minimal; then
		einfo "Installing TF headers"

		for i in $(find ${PN}/{c,cc,core} -name "*.h"); do
			insinto /usr/include/${PN}/${i%/*}
			doins ${i}
		done

		# Eigen headers
		insinto /usr/include/${PN}/third_party/eigen3/Eigen/
		doins third_party/eigen3/Eigen/*

		einfo "Installing TF libraries"

		${PN}/c/generate-pc.sh --prefix=/usr --libdir=$(get_libdir) --version=${MY_PV} || die
		insinto /usr/$(get_libdir)/pkgconfig
		doins ${PN}.pc

		dolib.so bazel-bin/tensorflow/lib${PN}_framework.so
		dolib.so bazel-bin/tensorflow/lib${PN}.so
		dolib.so bazel-bin/tensorflow/lib${PN}_cc.so
	fi

	einfo "Installing TF lite headers"

	for i in $(find ${PN}/contrib/lite/{,kernels,nnapi,profiling,schema,testing} -maxdepth 1 -name "*.h"); do
		insinto /usr/include/${PN}/${i%/*}
		doins ${i}
	done

	# TODO(crbug.com/836100): remove this once we unbundle distfiles (i.e. use the system
	#                         flatbuffers library and includes).
	insinto /usr/include/${PN}/third_party/flatbuffers/
	doins -r "${output_base}/external/flatbuffers/include/flatbuffers"

	einfo "Installing TF lite libraries"
	dolib.so bazel-bin/tensorflow/contrib/lite/lib${PN}_lite.so

	einstalldocs
}
