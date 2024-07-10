# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{6..13} )

inherit autotools python-any-r1

DESCRIPTION="A small C library for x86 (and x86_64) CPU detection and feature extraction"
HOMEPAGE="https://libcpuid.sourceforge.net/"
SRC_URI="https://github.com/anrieff/libcpuid/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-2"
SLOT="0/16"
KEYWORDS="~amd64"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

DEPEND="test? ( ${PYTHON_DEPS} )"

DOCS=(
	AUTHORS
	ChangeLog
	NEWS
	README
	Readme.md
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf "$(use_enable static-libs static)"
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
}
