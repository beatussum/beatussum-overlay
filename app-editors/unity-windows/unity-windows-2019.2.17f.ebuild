# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

HASH="8e603399ca02"

inherit unity-plugins

MY_PV="${PV}1"

DESCRIPTION="A Unity plugin for developing on the Android platform"
HOMEPAGE="https://unity3d.com"
SRC_URI="${SRC_URI_BASE}/MacEditorTargetInstaller/UnitySetup-Windows-Mono-Support-for-Editor-${MY_PV}.pkg -> ${P}.pkg"
LICENSE="Unity-EULA"
SLOT="2019"
KEYWORDS="-* ~amd64"
RESTRICT="bindist primaryuri strip test"

BDEPEND="$(unity-plugins_src_uri_depends)"

S="${WORKDIR}"
QA_PREBUILT="*"

src_install() {
	# To avoid changing permissions
	dodir "${UNITY_ENGINES_DIR}"
	cp -ar "${P}" "${D}/${UNITY_ENGINES_DIR}/WindowsStandaloneSupport" \
		|| die "The installation has failed"
}
