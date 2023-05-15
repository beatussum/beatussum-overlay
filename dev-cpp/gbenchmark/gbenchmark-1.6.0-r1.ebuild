# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN#g}"
PYTHON_COMPAT=( python3_{6..11} )

inherit cmake-multilib python-r1

DESCRIPTION="A microbenchmark support library"
HOMEPAGE="https://github.com/google/benchmark/"
SRC_URI="https://github.com/google/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="default-libcxx libpfm lto +exceptions test +tools"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

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
		>=dev-python/scipy-1.5.0[${PYTHON_USEDEP}]

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
)

PATCHES=(
	"${FILESDIR}/${P}-fix-gtest.patch"
)

src_prepare() {
	sed -i "s|doc/\${PROJECT_NAME}|doc/${PF}|" "${S}/src/CMakeLists.txt" \
		|| die "Cannot fix the documentation installation directory"

	cmake_src_prepare
}

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
