# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Include btrfs snapshots at boot options (Grub menu)"
HOMEPAGE="https://github.com/Antynea/grub-btrfs"
SRC_URI="https://github.com/Antynea/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE="systemd"
RESTRICT="primaryuri test"

RDEPEND="
	sys-boot/grub:2
	sys-fs/btrfs-progs
	systemd? ( sys-apps/systemd )
"

PATCHES=(
	"${FILESDIR}/${P}-config.patch"
	"${FILESDIR}/${P}-install-process.patch"
)

src_compile() { :; }

src_install() {
	default

	use systemd && emake DESTDIR="${D}" install-systemd
}

pkg_postinst() {
	if use systemd; then
		elog "If you would like Grub to automatically update when a"
		elog "snapshots is made or deleted:"
		elog "   - Mount your subvolume which contains snapshots to"
		elog "     '/.snapshots'"
		elog '   - Use `systemctl start/enable grub-btrfs.path`'
		elog '   - `grub-btrfs.path` automatically (re)generate'
		elog "     'grub.cfg' when  a  modification  appear  in"
		elog "     '/.snapshots'"
	fi
}
