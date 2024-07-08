# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_DOC_DIR="/usr/share/doc/${PF}"

inherit autotools flag-o-matic

DESCRIPTION="A text-based widget toolkit"
HOMEPAGE="https://github.com/gansm/finalcut/"
SRC_URI="https://github.com/gansm/finalcut/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3+"
SLOT="0/0"
KEYWORDS="~amd64"
MY_COMPONENTS=(doc examples newfont test)
IUSE="+gpm static-libs test ${MY_COMPONENTS[*]}"
REQUIRED_USE="test? ( !examples )"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/glib:2
	sys-libs/ncurses:=[tinfo]
	gpm? ( sys-libs/gpm )
"

BDEPEND="
	virtual/pkgconfig
	test? ( >=dev-util/cppunit-1.12.0 )
"

RDEPEND="${DEPEND}"

my_del_from_makefile() {
	local -r pattern="$1"; shift
	local -r comp=("$@")

	for i in "${comp[@]}"; do
		f="${i}/Makefile.am"

		sed -i "/${pattern}/d" "${f}" \
			|| die "Cannot delete '${pattern}' from '${f}'"
	done; unset i f
}

src_prepare() {
	default

	use doc && my_del_from_makefile "docdir" . doc
	use newfont && my_del_from_makefile "docdir" final/font

	for i in "${MY_COMPONENTS[@]}"; do
		if ! use "${i}"; then
			if [[ "${i}" = "newfont" ]]; then
				(
					sed -i "\|final/font/Makefile|d" configure.ac && \
					sed -i "s/font//" final/Makefile.am
				) || die "Unable to unset the component 'newfont'"
			else
				(
					sed -i "\|${i}/Makefile|d" configure.ac && \
					sed -i "s/${i}//" Makefile.am
				) || die "Unable to unset the component '${i}'"
			fi
		fi
	done; unset i

	eautoreconf
}

src_configure() {
	# `-fno-inline-small-functions` to avoid inline expension and thus linkage
	# errors.

	if use test; then
		append-cxxflags \
			-DDEBUG \
			-DUNIT_TEST \
			-Wno-error=unused-result
	fi

	econf \
		$(use_enable static-libs static) \
		$(use_with gpm) \
		$(use_with test unit-test) \
		--docdir="${EPREFIX}${MY_DOC_DIR}"
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

	find "${ED}" -name "*.la" -delete || die
}
