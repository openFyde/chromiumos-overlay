# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_PROJECT="chromiumos/third_party/kernel"
CROS_WORKON_LOCALNAME="kernel/v4.19"
CROS_WORKON_EGIT_BRANCH="chromeos-4.19"

# AFDO_PROFILE_VERSION is the build on which the profile is collected.
# This is required by kernel_afdo.
#
# TODO: Allow different versions for different CHROMEOS_KERNEL_SPLITCONFIGs

# By default, let cros-kernel2 define AFDO_LOCATION.  This is used in the
# kernel AFDO verify jobs to specify the location.
AFDO_LOCATION=""

# Auto-generated by PFQ, don't modify.
AFDO_PROFILE_VERSION="R114-15393.12-1681724128"

# Set AFDO_FROZEN_PROFILE_VERSION to freeze the afdo profiles.
# If non-empty, it overrides the value set by AFDO_PROFILE_VERSION.
# Note: Run "ebuild-<board> /path/to/ebuild manifest" afterwards to create new
# Manifest file.
AFDO_FROZEN_PROFILE_VERSION=""

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit cros-workon cros-kernel2

HOMEPAGE="https://www.chromium.org/chromium-os/chromiumos-design-docs/chromium-os-kernel"
DESCRIPTION="Chrome OS Linux Kernel 4.19"
KEYWORDS="~*"

# Update files/revision_bump file when you change "cros-kernel2.eclass" to work
# around https://issuetracker.google.com/201299127.
#
# NB: The exact file content does not matter.  It just needs to be different
# from whatever is in there currently.
#
# Don't forget to update the file for _all_ chromeos-kernel cros-workon packages.
