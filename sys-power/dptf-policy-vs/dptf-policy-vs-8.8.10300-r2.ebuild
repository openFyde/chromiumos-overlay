# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit cros-binary

DESCRIPTION="Virtual Sensor Policy for Intel(R) Dynamic Platform & Thermal Framework"

LICENSE="LICENSE.intel-dptf-private"
SLOT="0"
KEYWORDS="*"
S="${WORKDIR}"

CROS_BINARY_URI="dptf/DptfPolicyVirtualSensor-${PV}.tbz2"

# Need dependency blockers because DPTF binaries moved from dptf-private ebuild.
RDEPEND="
	!sys-power/dptf-dedede-private
	!sys-power/dptf-volteer-private"

# chipset-kbl binary can be used for all Intel platform.
cros-binary_add_gs_uri bcs-chipset-kbl-private chipset-kbl-private \
	"${CROS_BINARY_URI}"

src_install() {
	# Install DPTF policy add-on library.
	dolib.so DptfPolicyVirtualSensor.so
}
