# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ad9241033cc0fd7e904df28e424935235087370f"
CROS_WORKON_TREE="1d2b77214e013688d322e421db9536fe7c816fc1"
CROS_WORKON_PROJECT="chromiumos/third_party/kernel"
CROS_WORKON_LOCALNAME="kernel/upstream"

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit cros-workon cros-kernel2

HOMEPAGE="https://www.chromium.org/chromium-os/chromiumos-design-docs/chromium-os-kernel"
DESCRIPTION="Chrome OS Linux Kernel latest upstream rc"
KEYWORDS="*"

# Update files/revision_bump file when you change "cros-kernel2.eclass" to work
# around https://issuetracker.google.com/201299127.
#
# NB: The exact file content does not matter.  It just needs to be different
# from whatever is in there currently.
#
# Don't forget to update the file for _all_ chromeos-kernel cros-workon packages.
