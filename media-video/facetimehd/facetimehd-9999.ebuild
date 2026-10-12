# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 linux-mod-r1

DESCRIPTION="Reverse engineered Linux driver for the FacetimeHD (Broadcom 1570) PCIe webcam"
HOMEPAGE="https://github.com/patjak/facetimehd"

EGIT_REPO_URI="https://github.com/patjak/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
#RESTRICT="bindist mirror"

RDEPEND="media-video/facetimehd-firmware"
BDEPEND="app-arch/cpio
	app-arch/gzip
	app-arch/xz-utils
	net-misc/curl
	sys-apps/coreutils
"



src_unpack() {
	git-r3_src_unpack
	#emake -C "${S}"
}

src_compile() {
	#emake -C "${S}" all
	local modlist=(
	facetimehd
        facetimehd=kernel/drivers
	)
	linux-mod-r1_src_compile
}

#src_install() {
#	insinto "/lib/firmware/facetimehd"
#	doins firmware.bin
#	
#}
