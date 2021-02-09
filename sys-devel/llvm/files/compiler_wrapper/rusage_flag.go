// Copyright 2019 The Chromium OS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"syscall"
	"time"
)

func getRusageLogFilename(env env) string {
	value, _ := env.getenv("TOOLCHAIN_RUSAGE_OUTPUT")
	return value
}

func lockFileExclusive(fd uintptr) error {
	maxTries := 100
	for i := 0; i < maxTries; i++ {
		const seekSet = 0
		err := syscall.FcntlFlock(fd, syscall.F_SETLKW, &syscall.Flock_t{
			Type:   syscall.F_WRLCK,
			Whence: seekSet,
			Start:  0,
			Len:    0,
		})
		if err == nil {
			return nil
		}
		if err != syscall.EINTR {
			return fmt.Errorf("locking file: %v", err)
		}
	}
	return fmt.Errorf("locking file failed after %d tries", maxTries)
}

type rusageLog struct {
	ExitCode        int      `json:"exit_code"`
	ElapsedRealTime float64  `json:"elapsed_real_time"`
	ElapsedUserTime float64  `json:"elapsed_user_time"`
	ElapsedSysTime  float64  `json:"elapsed_sys_time"`
	MaxMemUsed      int64    `json:"max_mem_used"`
	Compiler        string   `json:"compiler"`
	CompilerArgs    []string `json:"compiler_args"`
}

func logRusage(env env, logFileName string, compilerCmd *command) (exitCode int, err error) {
	rusageBefore := syscall.Rusage{}
	if err := syscall.Getrusage(syscall.RUSAGE_CHILDREN, &rusageBefore); err != nil {
		return 0, err
	}
	compilerCmdWithoutRusage := &command{
		Path:       compilerCmd.Path,
		Args:       compilerCmd.Args,
		EnvUpdates: append(compilerCmd.EnvUpdates, "TOOLCHAIN_RUSAGE_OUTPUT="),
	}
	startTime := time.Now()
	exitCode, err = wrapSubprocessErrorWithSourceLoc(compilerCmdWithoutRusage,
		env.run(compilerCmdWithoutRusage, env.stdin(), env.stdout(), env.stderr()))
	if err != nil {
		return 0, err
	}
	elapsedRealTime := time.Since(startTime)
	rusageAfter := syscall.Rusage{}
	if err := syscall.Getrusage(syscall.RUSAGE_CHILDREN, &rusageAfter); err != nil {
		return 0, err
	}
	elapsedSysTime := time.Duration(rusageAfter.Stime.Nano()-rusageBefore.Stime.Nano()) * time.Nanosecond
	elapsedUserTime := time.Duration(rusageAfter.Utime.Nano()-rusageBefore.Utime.Nano()) * time.Nanosecond
	// Note: We assume that the compiler takes more heap than any other
	// subcommands that we might have executed before.
	maxMemUsed := rusageAfter.Maxrss
	absCompilerPath := getAbsCmdPath(env, compilerCmd)

	// We need to temporarily set umask to 0 to ensure 777 permissions are actually 777
	// This effects builderbots in particular
	oldMask := syscall.Umask(0)
	defer syscall.Umask(oldMask)

	if err := os.MkdirAll(filepath.Dir(logFileName), 0777); err != nil {
		return 0, wrapErrorwithSourceLocf(err, "error creating rusage log directory %s", logFileName)
	}

	timeUnit := float64(time.Second)

	logEntry := rusageLog{
		ExitCode:        exitCode,
		ElapsedRealTime: float64(elapsedRealTime) / timeUnit,
		ElapsedUserTime: float64(elapsedUserTime) / timeUnit,
		ElapsedSysTime:  float64(elapsedSysTime) / timeUnit,
		MaxMemUsed:      maxMemUsed,
		Compiler:        absCompilerPath,
		CompilerArgs:    compilerCmd.Args,
	}

	// Note: using file mode 0666 so that a root-created log is writable by others.
	logFile, err := os.OpenFile(logFileName, os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0666)
	if err != nil {
		return 0, wrapErrorwithSourceLocf(err, "creating rusage logfile %s", logFileName)
	}

	// O_APPEND's atomicity guarantees are only for writes up to a certain size. If we don't
	// lock the file, we might end up with corrupted records.
	//
	// Note that Close()'ing the file releases all associated locks.
	if err := lockFileExclusive(logFile.Fd()); err != nil {
		_ = logFile.Close()
		return 0, wrapErrorwithSourceLocf(err, "locking rusage logfile %s: %v", logFileName, err)
	}

	if err := json.NewEncoder(logFile).Encode(logEntry); err != nil {
		_ = logFile.Close()
		return 0, wrapErrorwithSourceLocf(err, "converting rusage logfile entry to JSON %v", logEntry)
	}

	closeErr := logFile.Close()
	if err != nil {
		return 0, wrapErrorwithSourceLocf(err, "writing to rusage logfile %s: %v", logFileName, err)
	}
	if closeErr != nil {
		return 0, wrapErrorwithSourceLocf(err, "closing rusage logfile %s: %v", logFileName, closeErr)
	}

	return exitCode, nil
}
