# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic git-r3

DESCRIPTION="Object-oriented Graphics Rendering Engine Next Generation"
HOMEPAGE="https://ogrecave.github.io/ogre-next/api/latest"
EGIT_REPO_URI="https://github.com/OGRECave/ogre-next.git"
EGIT_BRANCH="v3-0"

LICENSE="MIT public-domain"
SLOT="0"
#KEYWORDS="~amd64 ~arm ~x86"

#IUSE="assimp bullet cg doc +dotscene egl-only freeimage +gl3plus gles2 glslang opengl qt6 samples test tiny tools sdl vulkan wayland"
#REQUIRED_USE="
#	|| ( gl3plus gles2 opengl tiny vulkan )
#	egl-only? ( || ( gl3plus gles2 opengl ) )
#	test? ( samples )
#	vulkan? ( glslang )
#	wayland? ( egl-only )
#"
# vulkan broken, proper handling required for wayland
#RESTRICT="
#	!test? ( test )
#	vulkan? ( test )
#	wayland? ( test )
#"

# freetype and zlib are automagic
# vulkan-loader is dlopen'd
RDEPEND="
	media-libs/freetype
	media-libs/freeimage
	dev-libs/libzip
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libXrandr
	x11-libs/libXaw
	media-libs/freeglut
	media-libs/mesa
	app-text/doxygen
	media-gfx/graphviz
	dev-python/clang
	media-libs/libsdl2
	dev-libs/rapidjson
"
DEPEND="${RDEPEND}
"
BDEPEND="
	dev-build/ninja
	dev-build/cmake
"

#PATCHES=(
#	"${FILESDIR}"/ogre-14.5.2-fix-tests.patch
#	"${FILESDIR}"/ogre-14.5.2-clang22.patch
#)

src_unpack() {
	git-r3_src_unpack
	mkdir -v ${WORKDIR}/${P}/ogre-next-deps
	git-r3_fetch "https://github.com/OGRECave/ogre-next-deps" refs/heads/master
	git-r3_checkout "https://github.com/OGRECave/ogre-next-deps" ${WORKDIR}/${P}/ogre-next-deps
}

src_prepare() {
	cmake_src_prepare

	# Users should set this via their CFLAGS (like -march)
	sed -e '/check_cxx_compiler_flag(-msse OGRE_GCC_HAS_SSE)/d' \
		-i CMakeLists.txt || die
}

src_configure() {
	# odr violations
	filter-lto

	local mycmakeargs=(
		# https://gitweb.gentoo.org/repo/gentoo.git/commit/?id=fb809aeadee57ffa24591e60cfb41aecd4823090
		-DOGRE_ENABLE_PRECOMPILED_HEADERS=OFF
		-DOGRE_BUILD_COMPONENT_PLANAR_REFLECTIONS=1
		-DOGRE_BUILD_COMPONENT_SCENE_FORMAT=1
		-DOGRE_BUILD_SAMPLES2=0
		-DOGRE_BUILD_TESTS=0
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	#use doc && cmake_build OgreDoc
}
