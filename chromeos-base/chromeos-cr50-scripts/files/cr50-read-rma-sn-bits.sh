#!/bin/sh
# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# This script reads S/N vNVRAM data from cr50 as a part of the factory process.
# The data is printed as vvvvvv:rr:ss..ss, where
#   vvvvvv is the hex representation of the 3 version bytes,
#   rr is the hex representation of the RMA status byte,
#   ss..SS is the hex representation of SN bits (12 bytes).

# Choose a tool for sending raw TPM commands
if pidof trunksd > /dev/null; then
  # trunksd is running
  send_util="trunks_send --raw"
else
  # trunksd is stopped
  send_util="tpmc raw"
fi

# Send NV_Read command to read 12 bytes from SNbits vNVRAM:
# index=0x013fff01, size=0x0010, offset=0, auth=NULL password
TPM_CMD="80 02 00 00 00 23 00 00 01 4e 01 3f ff 01 01 3f ff 01 \
         00 00 00 09 40 00 00 09 00 00 00 00 00 00 10 00 00"
output="$(${send_util} ${TPM_CMD})" || exit 1
response="$(echo ${output} | sed -e 's/0x//g' | \
            tr -d ' \n' | tr '[:upper:]' '[:lower:]')"

# The successful response consists of
#  - Header (16 bytes = 32 hex digits):
#    -- Standard TPM header (10 bytes): tag, size, response code
#    -- Param size (4 bytes): should be 0x00000012
#    -- TPM2B size for read data (2 bytes), should be 0x0010
#  - Data (16 requested bytes = 32 hex digits):
#    -- Version (3 bytes = 6 hex digits)
#    -- RMA status (1 byte = 2 hex digits)
#    -- S/N bits (12 bytes = 24 hex digits)
#  - Auth area.

# Check response header.
hdr="$(echo ${response} | cut -b 1-32)"
EXPECTED_HDR="80020000002500000000000000120010"
if [ "${hdr}" != "${EXPECTED_HDR}" ]; then
  >&2 echo "Unexpected response: ${response}"
  exit 1
fi

# Extract and print RMA and SNbits data.
sn_data_version="$(echo ${response} | cut -b 33-38)"
rma_status="$(echo ${response} | cut -b 39-40)"
sn_bits="$(echo ${response} | cut -b 41-64)"
echo "${sn_data_version}:${rma_status}:${sn_bits}"
