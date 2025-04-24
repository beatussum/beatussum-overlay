# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

DESCRIPTION="Light GUI editor for SQLite databases"
HOMEPAGE="https://sqlitebrowser.org/"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sqlitebrowser/sqlitebrowser.git"
else
	SRC_URI="https://github.com/sqlitebrowser/sqlitebrowser/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+ MPL-2.0"
SLOT="0"
IUSE="sqlcipher test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-editors/qhexedit2-0.8.10
	dev-db/sqlite:3
	>=dev-libs/qcustomplot-2.1.1-r10
	dev-qt/qtbase:6[gui,network,ssl,widgets,xml]
	>=x11-libs/qscintilla-2.14.1-r1:=[qt6(+)]

	sqlcipher? ( dev-db/sqlcipher )
"

DEPEND="
	${RDEPEND}
	dev-qt/qtbase:6[concurrent]
"

BDEPEND="dev-qt/qttools:6[linguist]"

DOCS=(
	images/
	BUILDING.md
	CHANGELOG.md
	README.md
)

src_configure() {
	local mycmakeargs=(
		-DQT_MAJOR=Qt6
		-DFORCE_INTERNAL_QSCINTILLA=OFF
		-DFORCE_INTERNAL_QCUSTOMPLOT=OFF
		-DFORCE_INTERNAL_QHEXEDIT=OFF
		-Dsqlcipher=$(usex sqlcipher)
		-DENABLE_TESTING=$(usex test)
	)

	# https://bugs.gentoo.org/855254
	append-flags -fno-strict-aliasing
	filter-lto

	cmake_src_configure
}

src_install() {
	[[ ${PV} == *9999* ]] && DOCS+=( SECURITY.md )
	cmake_src_install
}
