#!/bin/bash -e
#
# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# proto_path is set to the project root, so all protos must be specified as
# src/third_party/chromiumos-overlay/...
protos=(
    brand_config.proto
    build_target_config.proto
    build_target_config_id.proto
    design_variant_config.proto
    firmware_config.proto
)
for proto in "${protos[@]}"; do
    protoc -I../../../.. "src/third_party/chromiumos-overlay/proto/${proto}" \
        --python_out=proto_bindings
done

