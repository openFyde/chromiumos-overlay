# Copyright 2018 The Chromium Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

CROS_WORKON_COMMIT="89844538a356effd043c81394f8e0b2bc80b8d65"
CROS_WORKON_TREE="6fef7b27eac60bc732fb1056412196039ecfa4a0"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="sepolicy"

inherit cros-workon

DESCRIPTION="Chrome OS SELinux Policy Package"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="android-container-pi android-container-master-arc-dev +combine_chromeos_policy"
# When developers are doing something not Android. This required use is to let
# the developer know, disabling combine_chromeos_policy flag doesn't change
# anything.
REQUIRED_USE="
	!combine_chromeos_policy? ( ^^ ( android-container-pi android-container-master-arc-dev ) )
"

DEPEND="
	android-container-pi? ( chromeos-base/android-container-pi:0= )
	android-container-master-arc-dev? ( chromeos-base/android-container-master-arc-dev:0= )
"

RDEPEND="
	${DEPEND}
	!!chromeos-base/android-container-nyc
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

# Remove all lines existed in $1 from /dev/stdin.
# and remove all lines begin with "^;" (cil comment)
# remove cil comment is necessary for clearing unmatched line marker
# after base policy definitions are removed.
filter_file_line_by_line() {
	grep -F -x -v -f "$1" | grep -v "^;"
}

has_arc() {
	use android-container-pi || use android-container-master-arc-dev;
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
	local arc_version="none"
	if use android-container-pi; then
		arc_version="p"
	elif use android-container-master-arc-dev; then
		arc_version="master"
	fi
	m4 "-Dmls_num_sens=${MLS_NUM_SENS}" "-Dmls_num_cats=${MLS_NUM_CATS}" \
		"-Darc_version=${arc_version}" \
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
	filter_file_line_by_line android_reqd.cil < chromeos.raw.cil > chromeos.cil ||
		die "failed to convert raw cil to filtered cil"
}

src_compile() {
	build_chromeos_policy

	if has_arc; then
		if use combine_chromeos_policy; then
			einfo "combining Chrome OS and Android SELinux policy"

			secilc "${SECILC_ARGS[@]}" "${SEPATH}/plat_sepolicy.cil" \
				"${SEPATH}/mapping.cil" \
				"${SEPATH}/plat_pub_versioned.cil" \
				"${SEPATH}/vendor_sepolicy.cil" \
				chromeos.cil || die "fail to build sepolicy"
		else
			einfo "use ARC++ policy"

			secilc "${SECILC_ARGS[@]}" "${SEPATH}/plat_sepolicy.cil" \
				"${SEPATH}/mapping.cil" \
				"${SEPATH}/plat_pub_versioned.cil" \
				"${SEPATH}/vendor_sepolicy.cil" || die "fail to build sepolicy"
		fi

		cat "sepolicy/file_contexts/chromeos_file_contexts" \
			"${SYSROOT}/etc/selinux/intermediates/arc_file_contexts" \
			> file_contexts \
			|| die "failed to combine *_file_contexts files"

	else
		# Chrome OS without ARC++ only. Chrome OS with Android N doesn't
		# fall here. Chrome OS with Android N currently has Android
		# policy only.
		einfo "Use Chrome OS-only SELinux policy."

		secilc "${SECILC_ARGS[@]}" chromeos.raw.cil || die "fail to build sepolicy"
		cp "sepolicy/file_contexts/chromeos_file_contexts" file_contexts \
			|| die "didn't find chromeos_file_contexts for file_contexts"
	fi
}

src_install() {
	insinto /etc/selinux/arc/contexts/files/
	doins file_contexts

	insinto /etc/selinux/
	newins "${FILESDIR}"/selinux_config config

	insinto /etc/selinux/arc/policy
	doins "${SEPOLICY_FILENAME}"

	if has_arc; then
		# Install ChromeOS cil so push_to_device.py can compile a new
		# version of SELinux policy.
		insinto /etc/selinux/intermediates.raw/
		doins chromeos.cil
	fi
}
