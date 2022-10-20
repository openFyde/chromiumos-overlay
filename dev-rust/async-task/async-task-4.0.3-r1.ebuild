# Copyright 2021 The Chromium OS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7


# Migrated crate. See b/240953811 for more about this migration.
DESCRIPTION="Replaced by third-party-crates-src."

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"
DEPEND="dev-rust/third-party-crates-src:="
RDEPEND="${DEPEND}"
