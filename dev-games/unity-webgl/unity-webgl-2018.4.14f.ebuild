# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

HASH="05119b33d0b7"

inherit check-reqs unity-plugins

MY_PV="${PV}1"

DESCRIPTION="A Unity plugin for developing on the WebGL platform"
HOMEPAGE="https://unity3d.com"
SRC_URI="${SRC_URI_BASE}/LinuxEditorTargetInstaller/UnitySetup-WebGL-Support-for-Editor-${MY_PV}.tar.xz -> ${P}.tar.xz"
LICENSE="Unity-EULA"
SLOT="lts-2018"
KEYWORDS="-* ~amd64"
RESTRICT="bindist primaryuri strip test"

BDEPEND="$(unity-plugins_src_uri_depends)"

RDEPEND="
	net-libs/nodejs[npm]
	virtual/ffmpeg
	virtual/jre
"

QA_PREBUILT="*"

CHECKREQS_DISK_BUILD="900M"

src_install() {
	# To avoid changing permissions
	dodir "${UNITY_DIR}"
	cp -ar * "${D}/${UNITY_DIR}" || die "The installation has failed"
}
