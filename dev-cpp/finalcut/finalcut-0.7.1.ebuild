# Copyright 1999-2021 Gentoo Authors
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
IUSE="+gpm static-libs test ${MY_COMPONENTS[*]}"
REQUIRED_USE="test? ( !examples )"
RESTRICT="primaryuri !test? ( test )"

DEPEND="
	sys-libs/ncurses:=[tinfo]
	gpm? ( sys-libs/gpm )
"

BDEPEND="virtual/pkgconfig"

RDEPEND="${DEPEND}"

MY_DOC_DIR="/usr/share/doc/${PF}"

_del_makefile() {
	local -r pattern="$1"; shift
	local -r comp=("$@")

	for i in "${comp[@]}"; do
		f="${i}/Makefile.am"

		if [[ "${i}" = "." ]] || use "${i/fonts/newfont}"; then
			sed -i "/${pattern}/d" "${f}" \
				|| die "Cannot delete '${pattern}' from '${f}'"
		fi
	done; unset i f
}

src_prepare() {
	default

	_del_makefile "doc_DATA" .
	_del_makefile "docdir" . doc fonts
	_del_makefile ".*\.sh" doc

	for i in "${MY_COMPONENTS[@]}"; do
		if ! use "${i}"; then
			comp="${i/newfont/fonts}"

			(
				sed -i "\|${comp}/Makefile|d" configure.ac && \
				sed -i "s/ ${comp}//" Makefile.am
			) || die "Unable to unset the component '${comp}'"
		fi; unset comp
	done; unset i

	eautoreconf
}

src_configure() {
	# `-O0` to avoid inline expension and thus
	# linkage errors
	use test && append-cxxflags -O0 -DUNIT_TEST

	econf $(use_enable static-libs static) \
		$(use_with gpm) \
		$(use_with test unit-test) \
		--docdir="${EPREFIX}${MY_DOC_DIR}"
}

src_install() {
	einstalldocs

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
