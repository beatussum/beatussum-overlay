# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="CPU-X"

inherit cmake-utils xdg

DESCRIPTION="A Free software that gathers information on CPU, motherboard and more"
HOMEPAGE="https://x0rg.github.io/CPU-X/"
SRC_URI="https://github.com/X0rg/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+bandwidth +dmidecode force-libstatgrab +gtk +libcpuid +libpci +ncurses +nls"
RESTRICT="primaryuri"

DEPEND="
	force-libstatgrab? ( sys-libs/libstatgrab )
	!force-libstatgrab? ( sys-process/procps:= )
	gtk? ( >=x11-libs/gtk+-3.12:3 )
	libcpuid? ( >=sys-libs/libcpuid-0.3.0 )
	libpci? ( sys-apps/pciutils )
	ncurses? ( sys-libs/ncurses:= )
"

BDEPEND="
	dev-lang/nasm
	nls? ( sys-devel/gettext )
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=(
	"${FILESDIR}/${P}-custom-build-fix.patch"
	"${FILESDIR}/${P}-static-libs-fix.patch"
)

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_GTK=$(usex gtk)
		-DWITH_NCURSES=$(usex ncurses)
		-DWITH_GETTEXT=$(usex nls)
		-DWITH_LIBCURL=OFF
		-DWITH_LIBJSONC=OFF
		-DWITH_LIBCPUID=$(usex libcpuid)
		-DWITH_LIBPCI=$(usex libpci)
		-DWITH_LIBSTATGRAB=OFF
		-DWITH_DMIDECODE=$(usex dmidecode)
		-DWITH_BANDWIDTH=$(usex bandwidth)
		-DFORCE_LIBSTATGRAB=$(usex force-libstatgrab)
	)

	cmake-utils_src_configure
}
