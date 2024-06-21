# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A full-featured BDD unit testing framework for all POSIX shells"
HOMEPAGE="https://shellspec.info/"
SRC_URI="https://github.com/shellspec/shellspec/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc example test"
RESTRICT="!test? ( test )"

DEPEND="
	|| (
		>=app-shells/bash-2.03
		>=app-shells/dash-0.5.4
		app-shells/ksh
		app-shells/loksh
		>=app-shells/mksh-28r
		>=app-shells/posh-0.3.14
		>=app-shells/yash-2.29
		>=app-shells/zsh-3.1.9
		>=sys-apps/busybox-1.20.0
	)
"

BDEPEND="test? ( ${DEPEND} )"
RDEPEND="${DEPEND}"

DOCS=(
	CHANGELOG.md
	CONTRIBUTING.md
	README.md
)

src_compile() { :; }

src_test() {
	emake test
}

src_install() {
	einstalldocs

	use doc && dodoc -r docs
	use example && dodoc -r examples

	emake PREFIX="${ED}/usr" install
	rm "${ED}/usr/lib/shellspec/LICENSE" || die
}
