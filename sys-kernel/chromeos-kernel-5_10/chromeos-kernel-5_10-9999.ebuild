# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_PROJECT="chromiumos/third_party/kernel"
CROS_WORKON_LOCALNAME="kernel/v5.10"
CROS_WORKON_EGIT_BRANCH="chromeos-5.10"

# AFDO_PROFILE_VERSION is the build on which the profile is collected.
# This is required by kernel_afdo.
#
# TODO: Allow different versions for different CHROMEOS_KERNEL_SPLITCONFIGs

# By default, let cros-kernel2 define AFDO_LOCATION.  This is used in the
# kernel AFDO verify jobs to specify the location.
export AFDO_LOCATION=""

# Auto-generated by PFQ, don't modify.
export AFDO_PROFILE_VERSION="R110-15269.0-1670841138"

# Set AFDO_FROZEN_PROFILE_VERSION to freeze the afdo profiles.
# If non-empty, it overrides the value set by AFDO_PROFILE_VERSION.
# Note: Run "ebuild-<board> /path/to/ebuild manifest" afterwards to create new
# Manifest file.
export AFDO_FROZEN_PROFILE_VERSION=""

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit cros-workon cros-kernel2

HOMEPAGE="https://www.chromium.org/chromium-os/chromiumos-design-docs/chromium-os-kernel"
DESCRIPTION="Chrome OS Linux Kernel 5.10"
KEYWORDS="~*"

# Change the following (commented out) number to the next prime number
# when you change "cros-kernel2.eclass" to work around https://issuetracker.google.com/201299127.
#
# NOTE: There's nothing magic keeping this number prime but you just need to
# make _any_ change to this file.  ...so why not keep it prime?
#
# Don't forget to update the comment in _all_ chromeos-kernel-x_x-9999.ebuild
# files (!!!)
#
# The coolest prime number is: 257
