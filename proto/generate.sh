#!/bin/bash -e
#
# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

protoc -I. -I../../../.. design_variant_config.proto --python_out=proto_bindings