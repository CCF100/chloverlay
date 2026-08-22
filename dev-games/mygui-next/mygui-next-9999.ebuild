EAPI=8
inherit cmake git-r3
DESCRIPTION="Fast, flexible and simple GUI. Fork for Ogre-next 3.0 master on branch ogre3"
HOMEPAGE="https://mygui.info"
EGIT_REPO_URI="https://github.com/cryham/mygui-next.git"
EGIT_BRANCH="ogre3"
LICENSE="MIT"
SLOT="0"
IUSE=""
#RESTRICT="strip"
RDEPEND="dev-games/ogre-next"
#DEPEND="${RDEPEND}"
#BDEPEND="virtual/pkgconfig"

PATCHES=(
	${FILESDIR}/'0001-patch-for-system-installed-OGRE-next.patch'
)

#src_prepare() {}

#src_configure() {}

#src_compile() {}

src_install() {
	cmake_src_install
	mv -v ${D}/usr/lib ${D}/usr/$(get_libdir)
}
