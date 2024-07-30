# Beatussum's Gentoo overlay

[![License](https://img.shields.io/github/license/beatussum/join)](LICENSE)
[![GitHub Actions Workflow Status (run pkgcheck)](https://img.shields.io/github/actions/workflow/status/beatussum/beatussum-overlay/run-pkgcheck.yml?label=run%20pkgcheck)](https://github.com/beatussum/beatussum-overlay/actions/workflows/run-pkgcheck.yml/)

## About this

My **Gentoo** overlay aims to provide some packages that are not (yet) in the main **Gentoo** tree.

## Add this overlay

Just use with [eselect-repository](https://wiki.gentoo.org/wiki/Eselect/Repository) as _root_:

```bash
eselect repository list
eselect repository enable beatussum-overlay
emaint sync --repo beatussum-overlay
```
