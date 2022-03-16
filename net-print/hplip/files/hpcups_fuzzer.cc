// Copyright 2022 The Chromium OS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include <errno.h>
#include <stdlib.h>
#include <unistd.h>

#include <iostream>
#include <cstddef>
#include <cstdint>

#include "stdin_util.h"
#include "prnt/hpcups/HPCupsFilter.h"

// This PPD file has *hpPrinterLanguage set to pcl3gui.
// The file can be randomly selected from a bucket of PPD files which
// use the hpcups filter but have different *hpPrinterLanguage
// values to increase code coverage.
constexpr char ppdFile[] = "/usr/share/cups/model/hpcups.ppd";

extern "C" int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
  static cups_page_header2_t header;
  static bool once = true;
  if (once) {
    ppd_file_t* file = ppdOpenFile(ppdFile);
    if (!file) {
      std::cerr << "ppdOpenFile() failed";
      abort();
    }
    if (cupsRasterInterpretPPD(&header, file, 0, nullptr, NULL) < 0) {
      std::cerr << "cupsRasterInterpretPPD() failed";
      ppdClose(file);
      abort();
    }
    ppdClose(file);
    header.HWResolution[0] = 300;
    header.HWResolution[1] = 300;
    int len = sizeof(header.cupsString[0]) - 1;
    strncpy(header.cupsString[0], "PlainNormalColor", len);
    header.cupsString[0][len] = NULL;
    once = false;
  }

  if (setenv("PPD", ppdFile, true)) {
    std::cerr << "setenv failed: error code " << errno << std::endl;
    abort();
  }

  // Sets stdin to a memory-backed file.
  int error = fuzzer_set_stdin(nullptr, 0);
  if (error) {
    std::cerr << "set_stdin() failed: error code " << error << std::endl;
    abort();
  }

  // Writes the raster content to stdin for HPCupsFilter to consume.
  // Stdin is a memory-backed file.
  cups_raster_t* raster = cupsRasterOpen(STDIN_FILENO, CUPS_RASTER_WRITE);
  cupsRasterWriteHeader2(raster, &header);
  cupsRasterWritePixels(raster, const_cast<uint8_t*>(data), size);
  cupsRasterClose(raster);
  fuzzer_rewind_stdin();

  HPCupsFilter filter;
  const char* argv[] = {/*uri*/ "",         /*job id*/ "1",
                        /*user*/ "chronos", /*title*/ "Untitled",
                        /*copies*/ "1",     /*options*/ ""};
  // This command may fail and return a non-zero error code
  // if the input raster header is malformed.
  filter.StartPrintJob(sizeof(argv) / sizeof(argv[0]),
                       const_cast<char**>(argv));

  return 0;
}
