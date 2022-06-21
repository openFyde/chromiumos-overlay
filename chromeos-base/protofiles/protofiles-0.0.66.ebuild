# Copyright (c) 2009 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This project checks out the proto files from the read only repositories
# linked to the following directories of the Chromium project:

#   - src/components/policy

# This project is not cros-work-able: if changes to the protobufs are needed
# then they should be done in the Chromium repository, and the commits below
# should be updated.

EAPI="7"

CROS_WORKON_PROJECT=(
	"chromium/src/components/policy"

	# private_membership and shell-encryption are not used in Chrome OS at
	# the moment. They are just required to compile the proto files. An
	# uprev will only be necessary if the respective proto files change.
	"chromium/src/third_party/private_membership"
	"chromium/src/third_party/shell-encryption"
)

CROS_WORKON_LOCALNAME=(
	"chromium/src/components/policy"
	"chromium/src/third_party/private_membership"
	"chromium/src/third_party/shell-encryption"
)

CROS_WORKON_DESTDIR=(
	"${S}/cloud/policy"
	"${S}/private_membership"
	"${S}/shell-encryption"
)

CROS_WORKON_EGIT_BRANCH=(
	"main"
	"main"
	"main"
)

CROS_WORKON_MANUAL_UPREV=1

# If you uprev these repos, please also:
# - Update files/VERSION to the corresponding revision of
#   chromium/src/chrome/VERSION in the Chromium code base.
#   Only the MAJOR version matters, really. This is necessary so policy
#   code builders have the right set of policies.
# - Update authpolicy/policy/device_policy_encoder[_unittest].cc to
#   include new device policies. The unit test tells you missing ones:
#     FEATURES=test emerge-$BOARD authpolicy
#   If you see unrelated test failures, make sure to rebuild the
#   authpolicy package and its dependencies (in particular, libbrillo
#   which provides libpolicy for accessing device policy) against the
#   updated protofiles package.
#   User policy is generated and doesn't have to be updated manually.
# - Bump the package version:
#     git mv protofiles-0.0.N.ebuild protofiles-0.0.N+1.ebuild
# - Bump the DEPEND version number for protofiles in all ebuilds for
#   packages that rely on the new policies. If you added new device
#   policy encodings above that will at least be authpolicy.
CROS_WORKON_COMMIT=(
	"5c9f177345f4518851cd222f83a0cdebff173e75" # policy
	"acb07d8034884b0f5e6d3b4379f6032fdb733e44" # private_membership
	"04a46b48f70713db831b32da1581437d587f4081" # shell-encryption
)
# git rev-parse $HASH:./
CROS_WORKON_TREE=(
	"f5bb39f2dec0b59f7d606a389049db07750a22ef" # policy
	"b8d20bc0d11609ffe2bc40bb4b3613cf94b6bd6d" # private_membership
	"f684c7405b47af0d6f74e4bc062845fca1359fe4" # shell-encryption
)

PYTHON_COMPAT=( python{3_6,3_7} )

inherit cros-constants cros-workon eutils python-any-r1

DESCRIPTION="Protobuf installer for the device policy proto definitions."
HOMEPAGE="https://chromium.googlesource.com/chromium/src/components/policy"

LICENSE="BSD-Google"
SLOT="0/${PV}"
KEYWORDS="*"
IUSE=""

POLICY_DIR="${S}/cloud/policy"

PRIVATE_MEMBERSHIP_DIR="${S}/private_membership/src"
SHELL_ENCRYPTION_DIR="${S}/shell-encryption/src"

# A list of the static protobuf files that exist in Chromium.
POLICY_DIR_PROTO_FILES=(
	"chrome_device_policy.proto"
	"chrome_extension_policy.proto"
	"device_management_backend.proto"
	"install_attributes.proto"
	"policy_common_definitions.proto"
	"policy_signing_key.proto"
	"secure_connect.proto"
)

RDEPEND="!<chromeos-base/chromeos-chrome-82.0.4056.0_rc-r1"

src_compile() {
	# Generate cloud_policy.proto.
	"${POLICY_DIR}/tools/generate_policy_source.py" \
		--cloud-policy-protobuf="${WORKDIR}/cloud_policy.proto" \
		--chrome-version-file="${FILESDIR}/VERSION" \
		--policy-templates-file="${POLICY_DIR}/resources/policy_templates.json" \
		--target-platform="chrome_os" \
		|| die "Failed to generate cloud_policy.proto"
}

src_install() {
	insinto /usr/include/proto
	doins "${POLICY_DIR}"/proto/chrome_device_policy.proto
	doins "${POLICY_DIR}"/proto/chrome_extension_policy.proto
	doins "${POLICY_DIR}"/proto/install_attributes.proto
	doins "${POLICY_DIR}"/proto/policy_signing_key.proto
	doins "${POLICY_DIR}"/proto/device_management_backend.proto
	doins "${PRIVATE_MEMBERSHIP_DIR}"/private_membership_rlwe.proto
	doins "${PRIVATE_MEMBERSHIP_DIR}"/private_membership.proto
	doins "${SHELL_ENCRYPTION_DIR}"/serialization.proto
	insinto /usr/share/protofiles
	doins "${POLICY_DIR}"/proto/chrome_device_policy.proto
	doins "${POLICY_DIR}"/proto/policy_common_definitions.proto
	doins "${POLICY_DIR}"/proto/device_management_backend.proto
	doins "${POLICY_DIR}"/proto/chrome_extension_policy.proto
	doins "${PRIVATE_MEMBERSHIP_DIR}"/private_membership_rlwe.proto
	doins "${PRIVATE_MEMBERSHIP_DIR}"/private_membership.proto
	doins "${SHELL_ENCRYPTION_DIR}"/serialization.proto
	doins "${WORKDIR}"/cloud_policy.proto
	insinto /usr/share/policy_resources
	doins "${POLICY_DIR}"/resources/policy_templates.json
	doins "${FILESDIR}"/VERSION
	exeinto /usr/share/policy_tools
	doexe "${POLICY_DIR}"/tools/generate_policy_source.py

	# Retrieve the proto files which exist in that path, with their full paths.
	local policy_dir_proto_files=( "${POLICY_DIR}"/proto/*.proto )

	# Convert policy_dir_proto_files into an array, and retrieving the files names, instead of their full path.
	policy_dir_proto_files=( "${policy_dir_proto_files[@]##*/}" )

	# Check whether all protobuf files that exist in Chromium side has already been installed in protofiles package or
	# not. And to verify that the list in autotests package, which is using these protobuf files are up-to-date.
	sorter() {
		printf '%s\n' "$@" | LC_ALL=C sort
	}
	if [[ "$(sorter "${policy_dir_proto_files[@]}")" != "$(sorter "${POLICY_DIR_PROTO_FILES[@]}")" ]]; then
		die "Add all new protobuf files into the sorted list of chromium protobuf files, which exist in protofiles package.
			Please update all the imported protobuf files in autotest package in policy_protos.py file."
	fi
}
