# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fish shell like syntax highlighting for Zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-syntax-highlighting/"
SRC_URI="https://github.com/zsh-users/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="primaryuri"

RDEPEND=">app-shells/zsh-4.3.11"

src_prepare() {
	default

	sed -i "s/COPYING.md//" Makefile || die
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" \
		DOC_DIR="${D}/usr/share/doc/${PF}" \
		install

	dosym "../../../${PN}/${PN}.zsh" \
		"/usr/share/zsh/plugins/${PN}/${PN}.zsh"

	dodoc HACKING.md
}

pkg_postinst() {
	einfo "To use syntax highlighting, enable it in the current"
	einfo "interactive shell:"
	einfo "  source /usr/share/zsh/plugins/${PN}/${PN}.zsh"
	einfo "For further information, please read the doc files."
}
