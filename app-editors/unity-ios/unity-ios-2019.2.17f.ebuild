# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs unity-plugins

MY_PV="${PV}1"

DESCRIPTION="A Unity plugin for developing on the iOS platform"
HOMEPAGE="https://unity3d.com"

HASH="8e603399ca02"
SRC_URI="${SRC_URI_BASE}/${HASH}/LinuxEditorTargetInstaller/UnitySetup-iOS-Support-for-Editor-${MY_PV}.tar.xz -> ${P}.tar.xz"

LICENSE="Unity-EULA"
SLOT="2019"
KEYWORDS="~amd64"
RESTRICT="bindist primaryuri strip test"

BDEPEND="$(unity-plugins_src_uri_depends)"

S="${WORKDIR}"
QA_PREBUILT="*"

CHECKREQS_DISK_BUILD="3400M"

src_install() {
	# To avoid changing permissions
	dodir "${UNITY_DIR}"
	cp -ar "${P}"/* "${D}/${UNITY_DIR}" || die "The installation has failed"
}
