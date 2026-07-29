# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dkms
HOMEPAGE="https://github.com/firlin123/jupiter-dkms"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	die "fuck you, no versioned ebuild for you >:3"
fi

DESCRIPTION="Jupiter ACPI platform driver DKMS"


LICENSE="GPL-2"
SLOT="0"

DEPEND="
	virtual/linux-sources
	sys-kernel/linux-headers
"

#PATCHES=( )

pkg_setup() {
	dkms_pkg_setup
}

src_prepare() {
	## Fix build failure, bug #513542 and bug #761370
	#sed "s%^KDIR :=.*%KDIR := ${KV_OUT_DIR:-$KERNEL_DIR}%g" -i Makefile || die
	#sed "s/#MODULE_VERSION#/${PV}/" -i dkms/dkms.conf || die
	#mv dkms/dkms.conf dkms.conf || die
	default
}

src_compile() {
	local modlist=( jupiter=acpi )
	local modargs=(
		KVERSION=${KV_FULL}
	)
	dkms_src_compile
}

src_install() {
	insinto /usr/share/initramfs-tools/modules.d
	newins usr/share/initramfs-tools/modules.d jupiter-dkms.conf
	dkms_src_install
}
