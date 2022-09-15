// Copyright 2019 The ChromiumOS Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package main

import (
	"strings"
)

// Returns whether the flag turns on 'invasive' sanitizers. These are sanitizers incompatible with
// things like FORTIFY, since they require meaningful runtime support, intercept libc calls, etc.
func isInvasiveSanitizerFlag(flag string) bool {
	// There are a few valid spellings here:
	//   -fsanitize=${sanitizer_list}, which enables the given sanitizers
	//   -fsanitize-trap=${sanitizer_list}, which specifies sanitizer behavior _if_ these
	//     sanitizers are already enabled.
	//   -fsanitize-recover=${sanitizer_list}, which also specifies sanitizer behavior _if_
	//     these sanitizers are already enabled.
	//   -fsanitize-ignorelist=/path/to/file, which designates a config file for sanitizers.
	//
	// All we care about is the first one, since that's what actually enables sanitizers. Clang
	// does not accept a `-fsanitize ${sanitizer_list}` spelling of this flag.
	fsanitize := "-fsanitize="
	if !strings.HasPrefix(flag, fsanitize) {
		return false
	}

	sanitizers := flag[len(fsanitize):]
	if sanitizers == "" {
		return false
	}

	for _, sanitizer := range strings.Split(sanitizers, ",") {
		// Keep an allowlist of sanitizers known to not cause issues.
		switch sanitizer {
		case "alignment", "array-bounds", "bool", "bounds", "builtin", "enum",
			"float-cast-overflow", "integer-divide-by-zero", "local-bounds",
			"nullability", "nullability-arg", "nullability-assign",
			"nullability-return", "null", "return", "returns-nonnull-attribute",
			"shift-base", "shift-exponent", "shift", "unreachable", "vla-bound":
			// These sanitizers are lightweight. Ignore them.
		default:
			return true
		}
	}
	return false
}

func processSanitizerFlags(builder *commandBuilder) {
	hasSanitizeFlags := false
	// TODO: This doesn't take -fno-sanitize flags into account. This doesn't seem to be an
	// issue in practice.
	for _, arg := range builder.args {
		if arg.fromUser && isInvasiveSanitizerFlag(arg.value) {
			hasSanitizeFlags = true
			break
		}
	}

	if !hasSanitizeFlags {
		return
	}

	// Flags not supported by sanitizers (ASan etc.)
	unsupportedSanitizerFlags := map[string]bool{
		"-D_FORTIFY_SOURCE=1": true,
		"-D_FORTIFY_SOURCE=2": true,
		"-Wl,--no-undefined":  true,
		"-Wl,-z,defs":         true,
	}

	builder.transformArgs(func(arg builderArg) string {
		// TODO: This is a bug in the old wrapper to not filter
		// non user args for gcc. Fix this once we don't compare to the old wrapper anymore.
		if (builder.target.compilerType != gccType || arg.fromUser) &&
			unsupportedSanitizerFlags[arg.value] {
			return ""
		}
		return arg.value
	})

	builder.filterArgPairs(func(arg1, arg2 builderArg) bool {
		return !(arg1.value == "-Wl,-z" && arg2.value == "-Wl,defs")
	})
}
