# Copyright 2013 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Don't install the built-in D-Bus config file.
neard_mask="/etc/dbus-1/system.d/org.neard.conf"
PKG_INSTALL_MASK+=" ${neard_mask}"
INSTALL_MASK+=" ${neard_mask}"
unset neard_mask
