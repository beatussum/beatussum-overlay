# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1

DESCRIPTION="Fish-like fast/unobtrusive autosuggestions for zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-autosuggestions/"
SRC_URI="https://github.com/zsh-users/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="primaryuri test"

RDEPEND=">=app-shells/zsh-4.3.11"

DOCS=(
	CHANGELOG.md
	README.md
)

DISABLE_AUTOFORMATTING=true
DOC_CONTENTS="\
For use this script,   load it into your interactive ZSH session:
  source ${EROOT}/usr/share/zsh/plugins/${PN}/${PN}.zsh
For further information, please read the README.md file installed
in ${EROOT}/usr/share/doc/${PF}."

src_prepare() {
	default

	emake clean
}

src_install() {
	einstalldocs
	readme.gentoo_create_doc

	insinto "/usr/share/zsh/plugins/${PN}"
	doins "${PN}.zsh"
}

pkg_postinst() {
	readme.gentoo_print_elog
}
