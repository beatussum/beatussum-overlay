# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit prefix readme.gentoo-r1

DESCRIPTION="ZSH port of Fish history search (up arrow)"
HOMEPAGE="https://github.com/zsh-users/zsh-history-substring-search/"
SRC_URI="https://github.com/zsh-users/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="primaryuri"

RDEPEND=">=app-shells/zsh-4.3"

DISABLE_AUTOFORMATTING=true
DOC_CONTENTS="\
For use this script,    load it into your interactive ZSH session:
  source ${EROOT}/usr/share/zsh/plugins/${PN}/${PN}.zsh
If you want to use zsh-syntax-highlighting along with this script,
then make sure that you load it before you load this script.
For further information,  please read the README.md file installed
in ${EROOT}/usr/share/doc/${PF}."

src_prepare() {
	default

	hprefixify -w 1 "${PN}.zsh"
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
