# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="ChromeOS auth virtual package. This package will RDEPEND
on the actual package that installs the ChromeOS PAM configs."
HOMEPAGE="http://src.chromium.org"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="*"

RDEPEND="chromeos-base/chromeos-auth-config"
