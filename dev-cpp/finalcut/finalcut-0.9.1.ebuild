# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="A text-based widget toolkit"
HOMEPAGE="https://github.com/gansm/finalcut/"
SRC_URI="https://github.com/gansm/finalcut/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3+"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc examples +gpm static-libs test"
REQUIRED_USE="test? ( !examples )"
RESTRICT="!test? ( test )"

DEPEND="
	sys-libs/ncurses:=[tinfo]
	gpm? ( sys-libs/gpm )
"

BDEPEND="
	virtual/pkgconfig
	test? ( >=dev-util/cppunit-1.12.0 )
"

RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-fix-tests.ebuild" )

src_prepare() {
	default

	sed -i "/AM_CPPFLAGS/ s/-Werror//" {examples,final,test}/Makefile.am \
		|| die 'Failed to remove `-Werror` from `CPPFLAGS`'

	for component in doc examples test; do
		if ! use "${component}"; then
			sed -i "/SUBDIRS/ s/${component}//" Makefile.am \
				|| die "Failed to remove ${component} from the building process"
		fi
	done

	eautoreconf
}

src_configure() {
	if use test; then
		append-cppflags -DDEBUG
		append-cxxflags -DDEBUG -DUNIT_TEST
	fi

	econf \
		$(use_enable static-libs static) \
		$(use_with gpm) \
		$(use_with test unit-test)
}

src_install() {
	emake DESTDIR="${ED}" PACKAGE="${PF}" install
	dodoc CODE_OF_CONDUCT.md Contributing.md SECURITY.md

	if use examples; then
			local examples="/usr/share/doc/${PF}/examples"
			docompress -x "${examples}"

			for example in examples/.libs/*; do
					example="${example#examples/.libs/}"

					local install_dir="${examples}/${example}"

					insinto "${install_dir}"
					doins "examples/${example}.cpp"
					exeinto "${install_dir}"
					doexe "examples/${example}"
			done
	fi

	find "${ED}" -name "*.la" -delete || die
}
