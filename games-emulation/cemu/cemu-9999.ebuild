# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg git-r3

DESCRIPTION="Wii U emulator"
HOMEPAGE="https://cemu.info/ https://github.com/cemu-project/Cemu"
EGIT_REPO_URI="https://github.com/cemu-project/Cemu.git"
LICENSE="MPL-2.0 ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+cubeb discord +sdl +vulkan -vcpkg +wxwidgets"

DEPEND="app-arch/zarchive
	app-arch/zstd
	cubeb? ( media-libs/cubeb )
	dev-libs/boost
	dev-libs/glib
	dev-libs/hidapi
	>=dev-libs/libfmt-9.1.0:=
	dev-libs/libzip
	dev-libs/openssl
	dev-libs/pugixml
	dev-libs/rapidjson
	dev-libs/wayland
	media-libs/libglvnd
	media-libs/libsdl2[haptic,joystick]
	net-misc/curl
	sys-libs/zlib
	vulkan? ( dev-util/vulkan-headers )
	x11-libs/gtk+:3[wayland]
	x11-libs/libX11
	wxwidgets? ( x11-libs/wxGTK:3.3-gtk3[opengl] )
	virtual/libusb"
RDEPEND="${DEPEND}"
BDEPEND="media-libs/glm"

#S="${WORKDIR}/${MY_PN}-${SHA}"

PATCHES=(
	#"${FILESDIR}/${PN}-0002-remove-default-from-system-g.patch"
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	if use vcpkg ; then
		VCPKG_FORCE_DOWNLOADED_BINARIES=true
		VCPKG_DISABLE_METRICS=1
		./dependencies/vcpkg/bootstrap-vcpkg.sh
	else
		VCPKG_FORCE_SYSTEM_BINARIES=1
	fi
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		"-DENABLE_CUBEB=$(usex cubeb)"
		"-DENABLE_DISCORD_RPC=$(usex discord)"
		-DENABLE_OPENGL=ON
		"-DwxWidgets_CONFIG_EXECUTABLE=/usr/$(get_libdir)/wx/config/gtk3-unicode-3.3"
		"-DENABLE_SDL=$(usex sdl)"
		"-DENABLE_VCPKG=$(usex vcpkg)"
		"-DENABLE_VULKAN=$(usex vulkan)"
		"-DENABLE_WXWIDGETS=$(usex wxwidgets)"
		-DCMAKE_DISABLE_PRECOMPILE_HEADERS=OFF
		-DALLOW_EXTERNAL_SPIRV_TOOLS=ON
		-Wno-dev
	)
	# "-DwxWidgets_CONFIG_EXECUTABLE=/usr/$(get_libdir)/wx/config/gtk3-unicode-3.2"
	cmake_src_configure
}

src_install() {
	newbin "bin/Cemu_relwithdebinfo" "${PN}"
	insinto "/usr/share/${PN}/gameProfiles"
	doins -r bin/gameProfiles/default/*
	insinto "/usr/share/${PN}"
	einstalldocs
	newicon -s 128 src/resource/logo_icon.png "info.${PN}.Cemu.png"
	domenu "dist/linux/info.${PN}.Cemu.desktop"
}
