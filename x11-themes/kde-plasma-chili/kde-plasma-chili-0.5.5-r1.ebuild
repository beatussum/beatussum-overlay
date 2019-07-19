# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The hottest login theme around for KDE Plasma 5"
HOMEPAGE="https://github.com/MarianArlt/kde-plasma-chili"
SRC_URI="https://github.com/MarianArlt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~x86-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~arm64-linux ~ppc64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
RESTRICT="primaryuri"

DOCS=(
	AUTHORS
	CHANGELOG.md
	CREDITS
	README.md
)

PATCHES=(
	"${FILESDIR}/${P}-i18n-fix.patch"
)

src_install() {
	einstalldocs
	rm "${DOCS[@]}" LICENSE.md || die

	insinto "/usr/share/sddm/themes/${PN}"
	doins -r *
}
