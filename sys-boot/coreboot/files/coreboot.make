# Copyright (c) 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
#
# Script to build multiple coreboot boards in parallel

.DELETE_ON_ERROR:
.SUFFIXES:
SHELL := /bin/bash

ifeq ($(configs),)
$(error configs must be specified)
endif

roms:=$(addsuffix /coreboot.rom,$(basename $(configs)))

.PHONY: all FORCE

all: $(roms)

# Export all parameters
export
# Don't export private variables
unexport configs roms

%/coreboot.rom: FORCE
	$(MAKE) obj="$(dir $@)" \
		DOTCONFIG="$(@:/coreboot.rom=.config)" \
		oldconfig \
		< <(yes "")
	@if grep -q "CONFIG_VENDOR_EMULATION=y" "$(@:/coreboot.rom=.config)"; then \
		echo "Error: $(@:/coreboot.rom=.config) incorrect?" >&2; \
		exit 1; \
	fi

	$(MAKE) obj="$(dir $@)" \
		DOTCONFIG="$(@:/coreboot.rom=.config)"

# Expand FW_MAIN_* since we might add some files
	cbfstool "$@" expand -r FW_MAIN_A,FW_MAIN_B

# Modify firmware descriptor if building for the EM100 emulator on
# Intel platforms.
# TODO(crbug.com/863396): Should we have an 'intel' USE flag? Do we
# still have any Intel platforms that don't use ifdtool?
ifeq ($(EM100_IDF),1)
	@echo "Enabling em100 mode via ifdttool (slower SPI flash)"
	ifdtool --em100 "$@"
	mv "${builddir}/coreboot.rom"{.new,} || die
endif
