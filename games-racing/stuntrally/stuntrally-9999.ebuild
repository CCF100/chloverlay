EAPI=8
inherit cmake git-r3 alternatives
DESCRIPTION="3D racing game with Sci-Fi elements and own Track Editor. The main repository with sources and data. Using Ogre-Next 3.0 and VDrift."
HOMEPAGE="https://cryham.org/stuntrally/"
EGIT_REPO_URI="https://github.com/stuntrally/stuntrally3.git"
EGIT_MIN_CLONE_TYPE=shallow
LICENSE="GPL-3"
SLOT="0"
IUSE=""
#RESTRICT="strip"
RDEPEND="
	dev-games/ogre-next
	dev-games/mygui-next
	sci-physics/bullet[extras]
	dev-libs/tinyxml2
	net-libs/enet
	media-libs/libogg
	media-libs/libvorbis
	media-libs/openal
	dev-libs/boost
	"
#DEPEND="${RDEPEND}"
#BDEPEND="virtual/pkgconfig"

PATCHES=(
	${FILESDIR}/0001-Gentoo-cmake-fix.patch
	${FILESDIR}/0002-More-Gentoo-cmake-fixes.patch
)

src_unpack() {
        git-r3_src_unpack
        mkdir -v ${WORKDIR}/${P}/data/tracks || die
        git-r3_fetch "https://github.com/stuntrally/tracks3.git"
        git-r3_checkout "https://github.com/stuntrally/tracks3.git" ${WORKDIR}/${P}/data/tracks
}


#src_prepare() {
#	default
#	mv -v CMake CMakeCI
#	mv -v CMakeManual CMake
#	mv -v CMakeLists.txt  CMakeListsCI.txt
#	mv -v CMakeLists-Debian.txt CMakeLists.txt
#	cmake_src_prepare
#}

src_configure() {
	local mycmakeargs=(
		-DOGRE_ENABLE_PRECOMPILED_HEADERS=OFF
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_MODULE_PATH=/usr/lib64/OGRE/cmake
	)
	cmake_src_configure
}

#src_compile() {}

src_install() {
	into /usr/share/sr3
	dobin bin/RelWithDebInfo/stuntrally3
	dobin bin/RelWithDebInfo/sr-translator
	dobin bin/RelWithDebInfo/sr-editor3
	insinto /usr/share/sr3
	doins bin/RelWithDebInfo/plugins.cfg
	dodir data
	dodir config
	alternatives_auto_makesym
}
