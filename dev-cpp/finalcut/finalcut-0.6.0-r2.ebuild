# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="A text-based widget toolkit"
HOMEPAGE="https://github.com/gansm/finalcut/"
SRC_URI="https://github.com/gansm/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
MY_COMPONENTS=(doc examples newfont test)
IUSE="+gpm ${MY_COMPONENTS[*]}"
REQUIRED_USE="test? ( !examples )"
RESTRICT="primaryuri !test? ( test )"

DEPEND="
	sys-libs/ncurses[tinfo]
	gpm? ( sys-libs/gpm )
"

BDEPEND="
	virtual/pkgconfig

	${DEPEND}
"

PATCHES=(
	"${FILESDIR}/${P}-fix-cppunit-config.patch"
	"${FILESDIR}/${P}-fix-without-package.patch"
)

MY_DOC_DIR="/usr/share/doc/${PF}"

src_prepare() {
	default

	sed -i "/doc_DATA/d" Makefile.am \
		|| die "Unable to assign the installation of the documentation" \
			'to `einstalldocs`'

	sed -i "/docdir/d" {,doc/,fonts/}Makefile.am \
		|| die "Unable not to force the installation of the documentation" \
			"into \`${MY_DOC_DIR%-*}\` instead of \`${MY_DOC_DIR}\`"

	sed -i "/.*\.sh/d" doc/Makefile.am \
		|| die "Unable to delete strange shell scripts from the installation" \
			"of the documentation"

	for i in "${MY_COMPONENTS[*]}"; do
		if ! use "${i}"; then
			sed -E -i "s| ${i/newfont/fonts}(/Makefile)?||g" \
				configure.ac Makefile.am \
				|| die "Unable to unset the \`${i}\` component"
		fi
	done; unset i

	eautoreconf
}

src_configure() {
	use test &&	append-cxxflags -g -O0 -DUNIT_TEST

	econf $(use_with gpm) \
		$(use_with test unit-test) \
		--docdir="${MY_DOC_DIR}"
}

src_install() {
	emake DESTDIR="${D}" install

	if use examples; then
		examples="${MY_DOC_DIR}/examples"
		docompress -x "${examples}"

		for i in examples/.libs/*; do
			base="$(basename "${i}")"

			insinto "${examples}/${base}"
			doins "examples/${base}.cpp"
			exeinto "${examples}/${base}"
			doexe "${i}"
		done; unset i base
	fi; unset examples

	einstalldocs
}
