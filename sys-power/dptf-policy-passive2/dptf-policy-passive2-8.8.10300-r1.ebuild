# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit cros-binary

DESCRIPTION="Passive2 Policy for Intel(R) Dynamic Platform & Thermal Framework"

LICENSE="LICENSE.intel-dptf-private"
SLOT="0"
KEYWORDS="*"
S="${WORKDIR}"

CROS_BINARY_URI="dptf/DptfPolicyPassive2-${PV}.tbz2"

# chipset-kbl binary can be used for all Intel platform.
cros-binary_add_gs_uri bcs-chipset-kbl-private chipset-kbl-private \
	"${CROS_BINARY_URI}"

src_install() {
	# Install DPTF policy add-on library.
	dolib.so DptfPolicyPassive2.so
}
