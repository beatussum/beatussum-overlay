# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 readme.gentoo-r1

DESCRIPTION="Scripts to support compressed swap devices or ramdisks with zram"
HOMEPAGE="https://github.com/vaeth/zram-init/"
EGIT_REPO_URI="https://github.com/vaeth/${PN}.git"
LICENSE="GPL-2"
SLOT="0"
MY_LINGUAS=(de fr)
IUSE="${MY_LINGUAS[@]/#/l10n_} +nls systemd +zsh-completion"
REQUIRED_USE="nls? ( || ( ${MY_LINGUAS[@]/#/l10n_} ) )"

BDEPEND="nls? ( sys-devel/gettext )"

RDEPEND="
	>=app-shells/push-2.0
	!<sys-apps/openrc-0.13
	nls? ( virtual/libintl )
"

DISABLE_AUTOFORMATTING=true
DOC_CONTENTS=\
'To use zram-init, activate it in your kernel and add it to default runlevel:
	rc-update add zram-init default
If you use systemd enable zram_swap, zram_tmp, and/or zram_var_tmp with
systemctl. You might need to modify /etc/modprobe.d/zram.conf depending
on the number of devices that you want to create.
If you use /tmp as zRAM device with OpenRC, you should add zram-init to the
boot runlevel:
	rc-update add zram-init boot
Still for the same case, you should add in the /etc/conf.d file for the services
using /tmp the following line:
	rc_need="zram-init"'

src_compile() {
	emake PREFIX="/usr" GETTEXT=$(usex nls TRUE FALSE)
}

src_install() {
	readme.gentoo_create_doc
	einstalldocs

	local man po
	for i in "${MY_LINGUAS[@]}"; do
		if use "l10n_${i}"; then
			man+="${i} "
			po+="i18n/${i}.po "
		fi
	done; unset i

	emake DESTDIR="${D}" PREFIX="/usr" SYSCONFDIR="/etc" \
		BINDIR="${D}/sbin" GETTEXT=$(usex nls TRUE FALSE) \
		ZSH_COMPLETION=$(usex zsh-completion TRUE FALSE) \
		SYSTEMD=$(usex systemd TRUE FALSE) \
		OPENRC=$(usex systemd FALSE TRUE) \
		PO="${po}" MANI18N="${man}" install
}

pkg_postinst() {
	readme.gentoo_print_elog
}
