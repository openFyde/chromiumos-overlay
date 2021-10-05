# Copyright 2022 Antmicro
# Distributed under the terms of the BSD license.

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit python-r1

DESCRIPTION="Renode is an open source software development framework with
commercial support from Antmicro that lets you develop, debug and test
multi-node device systems reliably, scalably and effectively."
HOMEPAGE="https://renode.io"

SRC_URI="https://dl.antmicro.com/projects/renode/builds/renode-${PV}-sources.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

DEPEND="
	>=dev-lang/mono-5.20
	$(python_gen_cond_dep '
		=dev-python/robotframework-4.0.1[${PYTHON_USEDEP}]
		dev-python/netifaces[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
"
RDEPEND="
	${DEPEND}
"

S="${WORKDIR}/renode"

src_compile() {
	./build.sh --no-gui --skip-fetch || die
}

src_install() {
	# Call die in case any of the commands fail (incl. sourced scripts).
	trap die ERR

	cd tools/packaging

	# Set variables required by the 'common_copy_files.sh' script.
	BASE="${S}"
	DIR="${ED}/opt/renode"
	INSTALL_DIR="/opt/renode"
	SED_COMMAND="sed -i"
	TARGET=Release

	. common_copy_files.sh

	# Create renode and renode-test wrappers.
	local command_script=renode
	local mono_version="$(cat ../mono_version)"
	cat > "$command_script" <<-EOF
		#!/bin/sh
		MONOVERSION=$mono_version
		REQUIRED_MAJOR=${mono_version%%.*}
		REQUIRED_MINOR=${mono_version##*.}
		EOF
	# skip the first line (with the hashbang)
	tail -n +2 linux/renode-template >> $command_script
	dobin renode

	local common_script=$DIR/tests/common.sh
	local test_script=renode-test
	copy_bash_tests_scripts $test_script $common_script
	dobin renode-test
}

src_test() {
	./renode --version || die
	./renode --console -e 'help; version; quit' || die

	# Run such unit tests that don't need to download any binaries.
	local test_script="$PWD/renode-test"
	cd tests/unit-tests || die
	local tests=(
		AdHocCompiler/adhoc-compiler.robot
		arm-thumb.robot
		big-endian-watchpoint.robot
		emulation-environment.robot
		external-mmu.robot
		host-uart.robot
		llvm-disassemble.robot
		log-tests.robot
		memory-invalidation.robot
		opcodes-counting.robot
		riscv-custom-instructions.robot
		riscv-interrupt-mode.robot
		riscv-unit-tests.robot
		tb_overwrite.robot
	)
	${test_script} --stop-on-error -j $(nproc) ${tests[@]} || die
}
