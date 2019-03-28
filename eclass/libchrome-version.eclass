# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: libchrome-version.eclass
# @MAINTAINER:
# ChromiumOS Build Team
# @BUGREPORTS:
# Please report bugs via http://crbug.com/new (with label Build)
# @VCSURL: https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/master/eclass/@ECLASS@
# @BLURB: helper eclass for managing libchrome version
# @DESCRIPTION:
# This eclass manages the libchrome version.

[[ -z ${LIBCHROME_VERS} ]] && LIBCHROME_VERS=( 576279 )
export BASE_VER="${LIBCHROME_VERS[0]}"
