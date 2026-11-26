# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DOTNET_PKG_COMPAT="11.0"
DOTNET_PKG_PROJECTS=( "AM2RLauncher.Gtk" )
NUGET_APIS+=( "https://www.nuget.org/api/v2" )
NUGETS="
	atksharp@3.24.24.95
	cairosharp@3.24.24.95
	eto.forms@2.11.0
	eto.platform.gtk@2.11.0
	gdksharp@3.24.24.95
	giosharp@3.24.24.95
	glibsharp@3.24.24.95
	gtksharp@3.24.24.95
	libgit2sharp.nativebinaries@2.0.323
	libgit2sharp@0.31.0
	log4net@2.0.15
	microsoft.netcore.platforms@1.1.0
	microsoft.netcore.platforms@5.0.0
	microsoft.win32.registry@5.0.0
	microsoft.win32.systemevents@6.0.0
	netstandard.library@2.0.3
	pangosharp@3.24.24.95
	system.buffers@4.5.1
	system.componentmodel.annotations@5.0.0
	system.configuration.configurationmanager@4.5.0
	system.configuration.configurationmanager@6.0.0
	system.drawing.common@6.0.0
	system.memory@4.5.0
	system.memory@4.5.4
	system.numerics.vectors@4.4.0
	system.runtime.compilerservices.unsafe@4.5.3
	system.security.accesscontrol@4.5.0
	system.security.accesscontrol@5.0.0
	system.security.accesscontrol@6.0.0
	system.security.cryptography.protecteddata@4.5.0
	system.security.cryptography.protecteddata@6.0.0
	system.security.permissions@4.5.0
	system.security.permissions@6.0.0
	system.security.principal.windows@5.0.0
	system.windows.extensions@6.0.0
"
inherit git-r3 dotnet-pkg desktop xdg

S="${WORKDIR}/${P}/AM2RLauncher"
DOTNET_PKG_BAD_PROJECTS=(
	"${S}/AM2RLauncher.Mac/AM2RLauncher.Mac.csproj"
	"${S}/AM2RLauncher.Wpf/AM2RLauncher.Wpf.csproj"
)
DESCRIPTION="A front-end application that simplifies installing the latest AM2R-Community-Updates, creating APKs for Android use, as well as Mods for AM2R."
HOMEPAGE="https://github.com/AM2R-Community-Developers/"
EGIT_REPO_URI="${HOMEPAGE}/AM2RLauncher.git"
SRC_URI+=" ${NUGET_URIS} "
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""
#RESTRICT="strip"

# Run-time dependencies.
RDEPEND="dev-libs/libappindicator >=dev-util/xdelta-3:3[lzma]"

# Build-time dependencies that need to be binary compatible with the system.
#DEPEND="${RDEPEND}"

# Build-time dependencies that are executed during the emerge process.
BDEPEND="virtual/dotnet-sdk"

src_unpack() {
	git-r3_src_unpack
	dotnet-pkg_src_unpack
}

src_install() {
	dotnet-pkg_src_install
	mkdir ${D}/usr/bin
	dosym /usr/share/${P}/${PN}.Gtk /usr/bin/${PN}
	domenu distribution/linux/${PN}.desktop
	doicon -s 128 distribution/linux/${PN}.png

        insinto /usr/share/metainfo
        doins distribution/linux/${PN}.appdata.xml
}
