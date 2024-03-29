// Copyright 2019 The ChromiumOS Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//go:build libc_exec
// +build libc_exec

package main

// #include <errno.h>
// #include <stdio.h>
// #include <stdlib.h>
// #include <string.h>
// #include <unistd.h>
// #include <sys/types.h>
// #include <sys/wait.h>
//
// int libc_exec(const char *pathname, char *const argv[], char *const envp[]) {
//	// Since fork() brings us to one thread, we can only use async-signal-safe funcs below.
//	pid_t pid = fork();
//	if (pid == 0) {
//		// crbug.com/1166017: we're (very rarely) getting ERESTARTSYS on some builders.
//		// Documentation indicates that this is a bug in the kernel. Work around it by
//		// retrying. 25 is an arbitrary retry number that Should Be Enough For Anyone(TM).
//		int i = 0;
//		for (; i < 25; i++) {
//			execve(pathname, argv, envp);
//			if (errno != 512) {
//				break;
//			}
//			// Sleep a bit. Not sure if this helps, but if the condition we're seeing is
//			// transient, it *hopefully* should. nanosleep isn't async-signal safe, so
//			// we have to live with sleep()
//			sleep(1);
//		}
//		fprintf(stderr, "exec failed (errno: %d)\n", errno);
//		_exit(1);
//	}
//	if (pid < 0) {
//		return errno;
//	}
//
//	int wstatus;
//	pid_t waited = waitpid(pid, &wstatus, 0);
//	if (waited == -1) {
//		return errno;
//	}
//	exit(WEXITSTATUS(wstatus));
//}
import "C"
import (
	"os/exec"
	"unsafe"
)

// Replacement for syscall.Execve that uses the libc.
// This allows tools that rely on intercepting syscalls via
// LD_PRELOAD to work properly (e.g. gentoo sandbox).
// Note that this changes the go binary to be a dynamically linked one.
// See crbug.com/1000863 for details.
// To use this version of exec, please add '-tags libc_exec' when building Go binary.
// Without the tags, libc_exec.go will not be used.

func execCmd(env env, cmd *command) error {
	freeList := []unsafe.Pointer{}
	defer func() {
		for _, ptr := range freeList {
			C.free(ptr)
		}
	}()

	goStrToC := func(goStr string) *C.char {
		cstr := C.CString(goStr)
		freeList = append(freeList, unsafe.Pointer(cstr))
		return cstr
	}

	goSliceToC := func(goSlice []string) **C.char {
		// len(goSlice)+1 as the c array needs to be null terminated.
		cArray := C.malloc(C.size_t(len(goSlice)+1) * C.size_t(unsafe.Sizeof(uintptr(0))))
		freeList = append(freeList, cArray)

		// Convert the C array to a Go Array so we can index it.
		// Note: Storing pointers to the c heap in go pointer types is ok
		// (see https://golang.org/cmd/cgo/).
		cArrayForIndex := (*[1<<30 - 1]*C.char)(cArray)
		for i, str := range goSlice {
			cArrayForIndex[i] = goStrToC(str)
		}
		cArrayForIndex[len(goSlice)] = nil

		return (**C.char)(cArray)
	}

	execCmd := exec.Command(cmd.Path, cmd.Args...)
	mergedEnv := mergeEnvValues(env.environ(), cmd.EnvUpdates)
	if errno := C.libc_exec(goStrToC(execCmd.Path), goSliceToC(execCmd.Args), goSliceToC(mergedEnv)); errno != 0 {
		return newErrorwithSourceLocf("exec error: %d", errno)
	}

	return nil
}
