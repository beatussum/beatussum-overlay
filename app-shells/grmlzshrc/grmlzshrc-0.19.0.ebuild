# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="grml-etc-core"

DESCRIPTION="Grmls core configuration files for zsh"
HOMEPAGE="https://grml.org/zsh/"
SRC_URI="https://github.com/grml/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="primaryuri"

BDEPEND="app-text/txt2tags"

RDEPEND="app-shells/zsh"

S="${WORKDIR}/${MY_PN}-${PV}"

DOCS=(
	README.md
	debian/changelog
)

src_compile() {
	emake -C "${S}/doc"
}

src_install() {
	einstalldocs

	insinto /etc
	doins -r etc/zsh

	insinto /etc/skel
	doins etc/skel/.zshrc

	doman "doc/${PN}.5"

	insinto /usr/share/grml
	doins -r usr_share_grml/zsh
}
