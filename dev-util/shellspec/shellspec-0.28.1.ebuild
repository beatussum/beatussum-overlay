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
RESTRICT="test? ( test )"

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
