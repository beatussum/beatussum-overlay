# Beatussum's Gentoo overlay

[![License](https://img.shields.io/github/license/beatussum/join)](LICENSE)
[![GitHub Actions Workflow Status (run pkgcheck)](https://img.shields.io/github/actions/workflow/status/beatussum/beatussum-overlay/run-pkgcheck.yml?label=run%20pkgcheck)](https://github.com/beatussum/beatussum-overlay/actions/workflows/run-pkgcheck.yml/)

## About this

I use this **Gentoo** overlay to maintain the packages whose I am proxied maintainer on the main tree.
All new packages I maintain are now on the [GURU repository](https://wiki.gentoo.org/wiki/Project:GURU).
If you want to use some of my packages that are now missing on this overlay, please see [this page](https://wiki.gentoo.org/wiki/Project:GURU/Information_for_End_Users) in order to _enable_ **GURU** on your computer..

## Add this overlay

Just use with [eselect-repository](https://wiki.gentoo.org/wiki/Eselect/Repository) as _root_:

```bash
eselect repository list
eselect repository enable beatussum-overlay
emaint sync --repo beatussum-overlay
```
