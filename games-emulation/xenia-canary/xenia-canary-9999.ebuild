# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop flag-o-matic toolchain-funcs git-r3

DESCRIPTION="Xbox 360 emulator research project (Canary version)."
HOMEPAGE="https://github.com/xenia-canary/xenia-canary https://xenia.jp/"

EGIT_REPO_URI="https://github.com/xenia-canary/xenia-canary.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cpu_flags_x86_avx discord"
REQUIRED_USE="cpu_flags_x86_avx"

DEPEND="app-arch/brotli
	app-arch/bzip2
	app-arch/snappy
	app-arch/zarchive
	app-arch/zstd
	dev-cpp/tomlplusplus
	dev-libs/capstone
	dev-libs/date
	dev-libs/expat
	dev-libs/libfmt:=
	dev-libs/libpcre2
	dev-libs/pugixml
	dev-libs/xxhash
	dev-util/spirv-tools
	discord? ( dev-libs/discord-rpc )
	media-gfx/graphite2
	media-libs/alsa-lib
	media-libs/libjpeg-turbo:=
	media-libs/libpulse
	media-libs/libsdl2
	media-libs/libsndfile
	media-libs/VulkanMemoryAllocator
	media-libs/vulkan-loader
	media-video/pipewire
	sys-apps/util-linux
	sys-libs/zlib-ng
	x11-libs/gtk+"
RDEPEND="${DEPEND}"
BDEPEND="dev-libs/cxxopts
	dev-libs/utfcpp
	dev-util/vulkan-headers"

# Avoid the upstream Release configuration (forced thin LTO + lld, Clang only).
CMAKE_BUILD_TYPE="RelWithDebInfo"

src_prepare() {
	# hardcode branch value until I can figure out a way of detecting this
	#einfo "Current branch: $(git branch --show-current)"
	einfo "Current commit: $(git rev-parse --short HEAD)"
	cat <<-EOF > "${S}/version.h" || die
	#ifndef GENERATED_VERSION_H_
	#define GENERATED_VERSION_H_
	#define XE_BUILD_BRANCH "canary_experimental"
	#define XE_BUILD_COMMIT "$(git rev-parse HEAD)"
	#define XE_BUILD_COMMIT_SHORT "$(git rev-parse --short HEAD)"
	#define XE_BUILD_DATE __DATE__
	#endif  // GENERATED_VERSION_H_
	EOF
	cmake_src_prepare
}

src_configure() {
	CC="clang"
	CPP="clang-cpp" # necessary for xorg-server and possibly other packages
	CXX="clang++"
	AR="llvm-ar"
	NM="llvm-nm"
	RANLIB="llvm-ranlib"

	if tc-is-gcc; then
		# Causes startup error in libstdc++ HashTable with GCC.
		filter-lto
	fi
	if tc-is-clang; then
		# These flags result in the emulator showing no video (Rocket/Tiger Lake).
		filter-flags -march=* -mtune=*
	fi
	CXXFLAGS="${CXXFLAGS} -Wno-unused-result"
	local mycmakeargs=(
		-DXENIA_BUILD_TESTS=OFF
		"-DXENIA_BUILD_DISCORD=$(usex discord ON OFF)"
		-DUSE_SYSTEM_CAPSTONE=ON
		-DUSE_SYSTEM_CXXOPTS=ON
		-DUSE_SYSTEM_DATE=ON
		"-DUSE_SYSTEM_DISCORD_RPC=$(usex discord ON OFF)"
		-DUSE_SYSTEM_FMT=ON
		-DUSE_SYSTEM_PUGIXML=ON
		-DUSE_SYSTEM_SNAPPY=ON
		-DUSE_SYSTEM_SPIRV_TOOLS=ON
		-DUSE_SYSTEM_TOMLPLUSPLUS=ON
		-DUSE_SYSTEM_UTFCPP=ON
		-DUSE_SYSTEM_VULKAN_HEADERS=ON
		-DUSE_SYSTEM_VULKAN_MEMORY_ALLOCATOR=ON
		-DUSE_SYSTEM_XXHASH=ON
		-DUSE_SYSTEM_ZARCHIVE=ON
		-DUSE_SYSTEM_ZLIB_NG=ON
		-DUSE_SYSTEM_ZSTD=ON
	)
	cmake_src_configure
}

src_install() {
	newbin "${BUILD_DIR}/bin/Linux/${PN/-/_}" "${PN}"
	for size in 16 32 48 64 128 256 512 1024; do
		newicon -s ${size} "assets/icon/${size}.png" "${PN}.png"
	done
	make_desktop_entry xenia-canary "Xenia Canary" "${PN}" "Game;Emulator"
	dodoc README.md
}
