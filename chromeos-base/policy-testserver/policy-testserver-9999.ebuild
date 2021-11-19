# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python{3_6,3_7} )

CROS_WORKON_PROJECT=(
	"chromium/src/third_party/tlslite"
	"chromium/src/net/tools/testserver"
	"chromium/src/components/policy"

	# private_membership and shell-encryption are not used in Chrome OS at
	# the moment. They are just required to compile the proto files. An
	# uprev will only be necessary if the respective proto files change.
	"chromium/src/third_party/private_membership"
	"chromium/src/third_party/shell-encryption"
)
CROS_WORKON_LOCALNAME=(
	"chromium/src/third_party/tlslite"
	"chromium/src/net/tools/testserver"
	"chromium/src/components/policy"
	"chromium/src/third_party/private_membership"
	"chromium/src/third_party/shell-encryption"
)
CROS_WORKON_DESTDIR=(
	"${S}/third_party/tlslite"
	"${S}/net/tools/testserver"
	"${S}/components/policy"
	"${S}/private_membership"
	"${S}/shell-encryption"
)
CROS_WORKON_MANUAL_UPREV="1"

# Must define CROS_WORKON_* variables before inheriting cros-workon.
inherit cros-constants cros-workon python-any-r1

DESCRIPTION="Dependencies needed by the policy_testserver"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="~*"

POLICY_DIR="${S}/components/policy"

PRIVATE_MEMBERSHIP_DIR="${S}/private_membership/src"
SHELL_ENCRYPTION_DIR="${S}/shell-encryption/src"

# Destination on DUT is /usr/local/share/policy_testserver.
TESTSERVER_DIR="/usr/share/policy_testserver"

DEPEND="
	dev-libs/protobuf:=
"

RDEPEND="
	dev-python/protobuf-python
"
src_compile() {
	# Generate cloud_policy.proto with --all-chrome-versions option.
	"${POLICY_DIR}/tools/generate_policy_source.py" \
		--cloud-policy-protobuf="${WORKDIR}/cloud_policy.proto" \
		--all-chrome-versions \
		--target-platform="chrome_os" \
		--policy-templates-file="${POLICY_DIR}/resources/policy_templates.json" \
		|| die

	# Create Python bindings needed for policy_testserver.py.
	protoc --proto_path="${POLICY_DIR}/proto" \
		--proto_path="${PRIVATE_MEMBERSHIP_DIR}"\
		--proto_path="${SHELL_ENCRYPTION_DIR}"\
		--python_out="${WORKDIR}" \
		"${POLICY_DIR}/proto/chrome_device_policy.proto" \
		"${POLICY_DIR}/proto/device_management_backend.proto" \
		"${POLICY_DIR}/proto/chrome_extension_policy.proto" \
		"${POLICY_DIR}/proto/policy_common_definitions.proto" \
		"${PRIVATE_MEMBERSHIP_DIR}/private_membership_rlwe.proto" \
		"${PRIVATE_MEMBERSHIP_DIR}/private_membership.proto" \
		"${SHELL_ENCRYPTION_DIR}/serialization.proto" \
		|| die
	protoc --proto_path="${WORKDIR}" --proto_path="${POLICY_DIR}/proto" \
		--python_out="${WORKDIR}" \
		"${WORKDIR}/cloud_policy.proto" \
		|| die
}

src_install() {
	insinto "${TESTSERVER_DIR}"
	doins -r "${S}"/third_party/tlslite
	doins -r "${S}"/net/tools/testserver
	doins -r "${S}"/components/policy/test_support/asn1der.py
	doins -r "${S}"/components/policy/test_support/policy_testserver.py

	insinto "${TESTSERVER_DIR}/proto_bindings"
	doins "${WORKDIR}/chrome_device_policy_pb2.py"
	doins "${WORKDIR}/device_management_backend_pb2.py"
	doins "${WORKDIR}/chrome_extension_policy_pb2.py"
	doins "${WORKDIR}/policy_common_definitions_pb2.py"
	doins "${WORKDIR}/cloud_policy_pb2.py"
	doins "${WORKDIR}/private_membership_rlwe_pb2.py"
	doins "${WORKDIR}/private_membership_pb2.py"
	doins "${WORKDIR}/serialization_pb2.py"
}
