# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd git-r3

DESCRIPTION="GamerOS session on Gamescope"
HOMEPAGE="https://github.com/bazzite-org/gamescope-session"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+steam"

RDEPEND="
	gui-wm/gamescope
	sys-power/switcheroo-control
	steam? ( games-util/gamescope-session-steam )
"

src_install() {
	dobin usr/bin/*
	systemd_douserunit usr/lib/systemd/user/*
	insinto /usr/share/gamescope-session-plus
	exeinto /usr/share/gamescope-session-plus
	doins usr/share/gamescope-session-plus/device-quirks
	doexe usr/share/gamescope-session-plus/gamescope-session-plus
	dodoc LICENSE README.md
}
