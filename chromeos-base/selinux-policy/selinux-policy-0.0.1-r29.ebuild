# Copyright 2018 The Chromium Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

CROS_WORKON_COMMIT="674483a481fcf5a77dd3e3d485e86e457892bd74"
CROS_WORKON_TREE="705b9cf8c9b1dbe58bda66881260e07424b0c56d"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="sepolicy"

inherit cros-workon

DESCRIPTION="Chrome OS SELinux Policy Package"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="android-container-pi android-container-master-arc-dev android-container-nyc +combine_chromeos_policy selinux_audit_all"
# When developers are doing something not Android. This required use is to let
# the developer know, disabling combine_chromeos_policy flag doesn't change
# anything.
REQUIRED_USE="
	!combine_chromeos_policy? ( ^^ ( android-container-pi android-container-master-arc-dev android-container-nyc ) )
"

DEPEND="
	android-container-pi? ( chromeos-base/android-container-pi:0= )
	android-container-master-arc-dev? ( chromeos-base/android-container-master-arc-dev:0= )
	android-container-nyc? ( chromeos-base/android-container-nyc:0= )
"

RDEPEND="
	${DEPEND}
"

SELINUX_VERSION="30"
SEPOLICY_FILENAME="policy.${SELINUX_VERSION}"

MLS_NUM_SENS=1
MLS_NUM_CATS=1024
CHROME_POLICY_FILES_PATTERN=(
	security_classes
	initial_sids
	access_vectors
	global_macros
	chromeos_macros
	neverallow_macros
	mls_macros
	mls_decl
	mls
	te_macros
	attributes
	ioctl_defines
	ioctl_macros
	"*.te"
	roles_decl
	roles
	users
	initial_sid_contexts
	fs_use
	genfs_contexts
)

# Files under $SEPATH are built by android-container-* in DEPEND.
SEPATH="${SYSROOT}/etc/selinux/intermediates/"

# -M Build MLS policy.
# -G expand and remove auto-generated attributes.
# -N ignore neverallow rules (checked during Android build)
# -m allow multiple declaration (combination of rules of multiple source)
SECILC_ARGS=(
	-M true -G -N -m
	-c "${SELINUX_VERSION}"
	-o "${SEPOLICY_FILENAME}"
	-f /dev/null
)

# Common flags for m4
M4_COMMON_FLAGS=(
)

# Remove all lines existed in $1 from /dev/stdin.
# and remove all lines begin with "^;" (cil comment)
# remove cil comment is necessary for clearing unmatched line marker
# after base policy definitions are removed.
filter_file_line_by_line() {
	grep -F -x -v -f "$1" | grep -v "^;"
}

# Quick hack for conflicting generated base_typeattr_XX with
# non-versioned Android cil.
# A better solution could be to use libsepol to parse and process
# cil to modify it.
version_cil() {
	sed -e 's/base_typeattr_\([0-9]*\)/base_typeattr_cros_\1/g'
}

has_arc() {
	use android-container-pi || use android-container-master-arc-dev || use android-container-nyc
}

gen_m4_flags() {
	M4_COMMON_FLAGS=()
	local arc_version="none"
	if use android-container-pi; then
		arc_version="p"
	elif use android-container-master-arc-dev; then
		arc_version="master"
	elif use android-container-nyc; then
		arc_version="n"
	fi
	M4_COMMON_FLAGS+=("-Darc_version=${arc_version}")
	einfo "m4 flags: ${M4_COMMON_FLAGS}"
}

# Build SELinux intermediate language files.
# Look into SELinux policies in given directories, and
# pre-compile with m4 macro preprocessor, and merge them into
# a monothilic SELinux policy, and then compile it into
# intermediate files using checkpolicy compiler.
build_cil() {
	local policy_files=()
	local output="$1"
	shift
	local pattern
	for pattern in "${CHROME_POLICY_FILES_PATTERN[@]}"; do
		local path
		for path in "$@"; do
			local file
			while read -r -d $'\0' file; do
				policy_files+=("${file}")
			done < <(find "${path}" -xtype f -name "${pattern}" -print0)
		done
	done
	m4 "-Dmls_num_sens=${MLS_NUM_SENS}" "-Dmls_num_cats=${MLS_NUM_CATS}" \
		"${M4_COMMON_FLAGS[@]}" \
		-s "${policy_files[@]}" > "${output}.conf" \
		|| die "failed to generate ${output}.conf"
	checkpolicy -M -C -c "${SELINUX_VERSION}" "${output}.conf" \
		-o "${output}" || die "failed to build $output"
}

build_android_reqd_cil() {
	build_cil "android_reqd.cil" "sepolicy/policy/base/" "sepolicy/policy/mask_only/"
}

build_chromeos_policy() {
	build_android_reqd_cil

	build_cil "chromeos.raw.cil" "sepolicy/policy/base/" "sepolicy/policy/chromeos/"
	version_cil < chromeos.raw.cil > chromeos.raw.versioned.cil
	filter_file_line_by_line android_reqd.cil < chromeos.raw.versioned.cil > chromeos.cil ||
		die "failed to convert raw cil to filtered cil"
}

build_file_contexts() {
	einfo "Compiling chromeos_file_contexts"
	m4 "${M4_COMMON_FLAGS[@]}" "sepolicy/file_contexts/macros" \
		"sepolicy/file_contexts/chromeos_file_contexts" > chromeos_file_contexts ||
		die "failed to build chromeos file contexts"
}

src_compile() {
	gen_m4_flags

	build_chromeos_policy
	build_file_contexts

	cp -r "${SEPATH}" intermediate_policy

	if use selinux_audit_all; then
		find intermediate_policy/ -xtype f -name '*.cil' -exec \
			sed -i 's/^(dontaudit .*//g' {} \;
		sed -i 's/^(dontaudit .*//g' chromeos.cil
		sed -i 's/^(dontaudit .*//g' chromeos.raw.cil
	fi

	local cilpath="$(pwd)/intermediate_policy"

	if has_arc; then
		if use combine_chromeos_policy; then
			einfo "combining Chrome OS and Android SELinux policy"

			if use android-container-nyc; then
				secilc "${SECILC_ARGS[@]}" "${cilpath}/sepolicy.cil" \
					chromeos.cil || die "fail to build sepolicy"
			else
				secilc "${SECILC_ARGS[@]}" "${cilpath}/plat_sepolicy.cil" \
					"${cilpath}/mapping.cil" \
					"${cilpath}/plat_pub_versioned.cil" \
					"${cilpath}/vendor_sepolicy.cil" \
					chromeos.cil || die "fail to build sepolicy"
			fi
		else
			einfo "use ARC++ policy"

			if use android-container-nyc; then
				secilc "${SECILC_ARGS[@]}" "${cilpath}/sepolicy.cil" \
					|| die "fail to build sepolicy"
			else
				secilc "${SECILC_ARGS[@]}" "${cilpath}/plat_sepolicy.cil" \
					"${cilpath}/mapping.cil" \
					"${cilpath}/plat_pub_versioned.cil" \
					"${cilpath}/vendor_sepolicy.cil" || die "fail to build sepolicy"
			fi
		fi

		cat "chromeos_file_contexts" \
			"${SYSROOT}/etc/selinux/intermediates/arc_file_contexts" \
			> file_contexts \
			|| die "failed to combine *_file_contexts files"

	else
		# Chrome OS without ARC++ only. Chrome OS with Android N doesn't
		# fall here. Chrome OS with Android N currently has Android
		# policy only.
		einfo "Use Chrome OS-only SELinux policy."

		secilc "${SECILC_ARGS[@]}" chromeos.raw.cil || die "fail to build sepolicy"
		cp "chromeos_file_contexts" file_contexts \
			|| die "didn't find chromeos_file_contexts for file_contexts"
	fi
}

src_install() {
	insinto /etc/selinux/arc/contexts/files
	doins file_contexts

	insinto /etc/selinux
	newins "${FILESDIR}/selinux_config" config

	insinto /etc/selinux/arc/policy
	doins "${SEPOLICY_FILENAME}"

	if has_arc; then
		# Install ChromeOS cil so push_to_device.py can compile a new
		# version of SELinux policy.
		insinto /etc/selinux/intermediates.raw/
		doins chromeos.cil
	fi
}
