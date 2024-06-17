# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN#g}"
PYTHON_COMPAT=( python3_{8..12} )

inherit cmake-multilib python-r1

DESCRIPTION="A microbenchmark support library"
HOMEPAGE="https://github.com/google/benchmark/"
SRC_URI="https://github.com/google/benchmark/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="default-libcxx doc libpfm lto +exceptions test +tools"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
MY_COMMON_DEPEND="tools? ( ${PYTHON_DEPS} )"

DEPEND="
	default-libcxx? ( sys-libs/libcxx[${MULTILIB_USEDEP}] )
	libpfm? ( dev-libs/libpfm:= )

	${MY_COMMON_DEPEND}
"

BDEPEND="
	>=dev-build/cmake-3.10
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )
"

RDEPEND="
	tools? (
		dev-python/numpy[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.10.0[${PYTHON_USEDEP}]
	)

	${MY_COMMON_DEPEND}
"

S="${WORKDIR}/${MY_PN}-${PV}"

DOCS=(
	AUTHORS
	CONTRIBUTING.md
	CONTRIBUTORS
	README.md
	docs/random_interleaving.md
	docs/reducing_variance.md
	docs/tools.md
	docs/user_guide.md
)

src_prepare() {
	if use doc; then
		sed -i \
			'162s|${CMAKE_INSTALL_DOCDIR}|${CMAKE_INSTALL_DOCDIR}/html|' \
			"${S}/src/CMakeLists.txt" \
			|| die "Cannot fix the HTML documentation installation directory"
	fi

	cmake_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBENCHMARK_ENABLE_DOXYGEN="$(usex doc)"
		-DBENCHMARK_ENABLE_EXCEPTIONS="$(usex exceptions)"
		-DBENCHMARK_ENABLE_GTEST_TESTS="$(usex test)"
		-DBENCHMARK_ENABLE_LTO="$(usex lto)"
		-DBENCHMARK_ENABLE_LIBPFM="$(usex libpfm)"
		-DBENCHMARK_ENABLE_TESTING="$(usex test)"
		-DBENCHMARK_ENABLE_WERROR=OFF
		-DBENCHMARK_INSTALL_DOCS="$(usex doc)"
		-DBENCHMARK_USE_BUNDLED_GTEST=OFF
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
