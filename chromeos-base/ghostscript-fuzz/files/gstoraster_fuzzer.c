// Copyright 2018 The ChromiumOS Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include <ghostscript/gserrors.h>
#include <ghostscript/iapi.h>

#include <limits.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>

static const unsigned char *g_data;
static size_t g_size;

#define min(x, y) ((x) < (y) ? (x) : (y))

static int gs_stdin(void *inst, char *buf, int len)
{
	size_t to_copy = min(len, g_size);
	to_copy = min(INT_MAX, to_copy);

	memcpy(buf, g_data, to_copy);

	g_data += to_copy;
	g_size -= to_copy;

	return to_copy;
}

static int gs_stdout(void *inst, const char *buf, int len)
{
	/* Just discard everything. */
	return len;
}

static int gs_to_raster_fuzz(const unsigned char *buf, size_t size)
{
	int ret;
	void *gs = NULL;

	/* Mostly stolen from cups-filters gstoraster. */
	char *args[] = {
		"-r200x200",
		"-dMediaPosition=1",
		"-dcupsColorSpace=1", /* RGB */
		"-dQUIET",
		"-dPARANOIDSAFER",
		"-dNOPAUSE",
		"-dBATCH",
		"-dNOINTERPOLATE",
		"-dNOMEDIAATTRS",
		"-sstdout=%stderr",
		"-sOutputFile=%stdout",
		"-sDEVICE=cups",
		"-_",
	};
	int argc = sizeof(args) / sizeof(args[0]);

	/* Stash buffers globally, for gs_stdin(). */
	g_data = buf;
	g_size = size;

	ret = gsapi_new_instance(&gs, NULL);
	if (ret < 0) {
		fprintf(stderr, "gsapi_new_instance: error %d\n", ret);
		return ret;
	}

	gsapi_set_stdio(gs, gs_stdin, gs_stdout, NULL /* stderr */);
	ret = gsapi_set_arg_encoding(gs, GS_ARG_ENCODING_UTF8);
	if (ret < 0) {
		fprintf(stderr, "gsapi_set_arg_encoding: error %d\n", ret);
		gsapi_delete_instance(gs);
		return ret;
	}

	ret = gsapi_init_with_args(gs, argc, args);
	if (ret && ret != gs_error_Quit)
		/* Just keep going, to cleanup. */
		fprintf(stderr, "gsapi_init_with_args: error %d\n", ret);

	ret = gsapi_exit(gs);
	if (ret < 0 && ret != gs_error_Quit) {
		fprintf(stderr, "gsapi_exit: error %d\n", ret);
		return ret;
	}

	gsapi_delete_instance(gs);

	return 0;
}

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
	gs_to_raster_fuzz(data, size);
	return 0;
}
