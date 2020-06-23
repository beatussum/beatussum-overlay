# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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

src_prepare() {
	default

	emake clean
}

src_install() {
	einstalldocs

	insinto "/usr/share/zsh/plugins/${PN}"
	doins "${PN}.zsh"
}

pkg_postinst() {
	einfo "For use this script, load it into your interactive ZSH session:"
	einfo "\tsource /usr/share/zsh/plugins/${PN}/${PN}.zsh"
	einfo
	einfo "For further information, please read the README.md file installed"
	einfo "in /usr/share/doc/${PF}"
}
