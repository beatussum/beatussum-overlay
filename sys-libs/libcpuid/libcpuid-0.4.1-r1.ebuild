# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{5..7})

inherit autotools python-single-r1

DESCRIPTION="A small C library for x86 (and x86_64) CPU detection and feature extraction"
HOMEPAGE="http://libcpuid.sourceforge.net"
SRC_URI="https://github.com/anrieff/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
REQUIRED_USE="test? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="primaryuri !test? ( test )"

DEPEND="test? ( ${PYTHON_DEPS} )"

PATCHES=(
	"${FILESDIR}/${PF}-python3-fix.patch"
)

src_prepare() {
	default

	eautoreconf
}

src_test() {
	emake test
}
