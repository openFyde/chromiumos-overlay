# Copyright (c) 2009 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This project checks out the proto files from the read only repositories
# linked to the following directories of the Chromium project:

#   - src/components/policy

# This project is not cros-work-able: if changes to the protobufs are needed
# then they should be done in the Chromium repository, and the commits below
# should be updated.

EAPI="5"

# We don't need the history at all.
EGIT_CLONE_TYPE="shallow"

# TODO(crbug.com/984182): We force Python 2 because depot_tools doesn't support Python 3.
PYTHON_COMPAT=( python2_7 )

inherit cros-constants eutils git-r3 python-any-r1

# Every 3 strings in this array indicates a repository to checkout:
#   - A unique name (to avoid checkout conflits)
#   - The repository URL
#   - The commit to checkout
EGIT_REPO_URIS=(
	"cloud/policy"
	"${CROS_GIT_HOST_URL}/chromium/src/components/policy.git"
	"72e354e16600a8999c85528147dcf762f31a4b78"

	# If you uprev these repos, please also:
	# - Update files/VERSION to the corresponding revision of
	#   chromium/src/chrome/VERSION in the Chromium code base.
	#   Only the MAJOR version matters, really. This is necessary so policy
	#   code builders have the right set of policies.
	# - Update authpolicy/policy/device_policy_encoder[_unittest].cc to
	#   include new device policies. The unit test tells you missing ones:
	#     cros_run_unit_tests --board=$BOARD --packages authpolicy
	#   If you see unrelated test failures, make sure to rebuild the
	#   authpolicy package and its dependencies (in particular, libbrillo
	#   which provides libpolicy for accessing device policy) against the
	#   updated protofiles package.
	#   User policy is generated and doesn't have to be updated manually.
	# - Bump the package version:
	#     git mv protofiles-0.0.N.ebuild protofiles-0.0.N+1.ebuild
)

DESCRIPTION="Protobuf installer for the device policy proto definitions."
HOMEPAGE="https://chromium.googlesource.com/chromium/src/components/policy"

LICENSE="BSD-Google"
SLOT="0/${PV}"
KEYWORDS="*"
IUSE=""

POLICY_DIR="${S}/cloud/policy"

RDEPEND="!<chromeos-base/chromeos-chrome-82.0.4056.0_rc-r1"

src_unpack() {
	set -- "${EGIT_REPO_URIS[@]}"
	while [[ $# -gt 0 ]]; do
		EGIT_CHECKOUT_DIR="${S}/$1" \
		EGIT_REPO_URI=$2 \
		EGIT_COMMIT=$3 \
		git-r3_src_unpack
		shift 3
	done
}

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
	insinto /usr/share/protofiles
	doins "${POLICY_DIR}"/proto/chrome_device_policy.proto
	doins "${POLICY_DIR}"/proto/policy_common_definitions.proto
	doins "${POLICY_DIR}"/proto/device_management_backend.proto
	doins "${POLICY_DIR}"/proto/chrome_extension_policy.proto
	doins "${WORKDIR}"/cloud_policy.proto
	dobin "${FILESDIR}"/policy_reader
	insinto /usr/share/policy_resources
	doins "${POLICY_DIR}"/resources/policy_templates.json
	doins "${FILESDIR}"/VERSION
	exeinto /usr/share/policy_tools
	doexe "${POLICY_DIR}"/tools/generate_policy_source.py
	sed -i -E '1{ /^#!/ s:(env )?python$:python2: }' \
		"${D}/usr/share/policy_tools/generate_policy_source.py" || die
}
