# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit kernel-build

MY_P="linux-${PV%.*}"

DESCRIPTION="Linux kernel built with Microsoft's WSL patches and defaults"
HOMEPAGE="
	https://github.com/microsoft/WSL2-Linux-Kernel/
	https://www.kernel.org/
"
#S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"

EGIT_REPO_URI="https://github.com/microsoft/WSL2-Linux-Kernel"
#EGIT_BRANCH="linux-msft-wsl-$(ver_cut 1-2).y"
EGIT_MIN_CLONE_TYPE="shallow"
inherit git-r3
#PDEPEND="
#	>=virtual/dist-kernel-${PV}
#"
IUSE="debug"
RDEPEND="app-emulation/qemu" # create vhd for modules
src_prepare() {
	default
	case ${ARCH} in
		arm | hppa | loong | sparc | x86)
			> .config || die
			;;
		amd64)
			cp "${S}/Microsoft/config-wsl" .config || die
			;;
		arm64)
			cp "${S}/Microsoft/config-wsl-arm64" .config || die
			;;
		*)
			die "Unsupported Arch ${ARCH}"
			;;
		esac
	kernel-build_merge_configs
}
pkg_postinst(){
	einfo "To use it with wsl, copy it to a windows drive"
	einfo "Then configure C:\Users\<UserName>\.wslconfig"
	einfo "[wsl2]"
	einfo "kernel=..."
	einfo "kernelModules=...(path to vhd)"
	einfo "Generate the module vhd with gen_modules_vhd.sh"
	einfo "An example script was installed into /etc/kernel/postinst.d"
}
src_install(){
	#dobin Microsoft/scripts/gen_modules_vhdx.sh
	kernel-build_src_install
	insinto /etc/kernel/postinst.d
	#newins "${FILESDIR}/gen-module-vhdx.sh" gen-module-vhdx.sh.example
}
