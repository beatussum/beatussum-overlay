# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1

DESCRIPTION="Fish shell like syntax highlighting for Zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-syntax-highlighting/"
SRC_URI="https://github.com/zsh-users/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="primaryuri !test? ( test )"

RDEPEND=">app-shells/zsh-4.3.11"

DISABLE_AUTOFORMATTING=true
DOC_CONTENTS=\
"To use syntax highlighting,   enable it in the current
interactive shell:
  source ${EROOT}/usr/share/zsh/plugins/${PN}/${PN}.zsh
For further information, please read the documentation
files."

src_prepare() {
	default

	sed -i "s/COPYING.md//" Makefile || die
}

src_install() {
	readme.gentoo_create_doc

	emake DESTDIR="${ED}" PREFIX="/usr" \
		DOC_DIR="${ED}/usr/share/doc/${PF}" \
		install
	dodoc HACKING.md

	dosym "../../../${PN}/${PN}.zsh" \
		"/usr/share/zsh/plugins/${PN}/${PN}.zsh"
}

pkg_postinst() {
	readme.gentoo_print_elog
}
