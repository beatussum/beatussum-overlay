# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS="cmake"
MY_PN="${PN#g}"
PYTHON_COMPAT=( python3_{6..9} )

inherit cmake-multilib python-r1

DESCRIPTION="A microbenchmark support library"
HOMEPAGE="https://github.com/google/benchmark/"
SRC_URI="https://github.com/google/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="default-libcxx libpfm lto +exceptions test +tools"
RESTRICT="primaryuri !test? ( test )"

DEPEND="
	default-libcxx? ( sys-libs/libcxx[${MULTILIB_USEDEP}] )
	libpfm? ( dev-libs/libpfm:= )
"

BDEPEND="
	>=dev-util/cmake-3.5.1
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )
"

RDEPEND="
	tools? (
		dev-python/scipy[${PYTHON_USEDEP}]

		${PYTHON_DEPS}
	)

	${DEPEND}
"

S="${WORKDIR}/${MY_PN}-${PV}"

DOCS=(
	AUTHORS
	CONTRIBUTING.md
	CONTRIBUTORS
	README.md
	docs/AssemblyTests.md
	docs/perf_counters.md
	docs/random_interleaving.md
	docs/tools.md
)

PATCHES=(
	"${FILESDIR}/${P}-fix-gtest.patch"
)

multilib_src_configure() {
	local mycmakeargs=(
		-DBENCHMARK_ENABLE_EXCEPTIONS="$(usex exceptions)"
		-DBENCHMARK_ENABLE_GTEST_TESTS="$(usex test)"
		-DBENCHMARK_ENABLE_LTO="$(usex lto)"
		-DBENCHMARK_ENABLE_LIBPFM="$(usex libpfm)"
		-DBENCHMARK_ENABLE_TESTING="$(usex test)"
		-DBENCHMARK_USE_LIBCXX="$(usex default-libcxx)"
	)

	cmake_src_configure
}

python_install() {
	python_domodule "${S}/tools/gbench"
	python_doscript "${S}/tools/compare.py"
	python_doscript "${S}/tools/strip_asm.py"
}

multilib_src_install_all() {
	einstalldocs

	use tools && python_foreach_impl python_install
}
