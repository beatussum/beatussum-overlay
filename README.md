[![Build Status](https://travis-ci.org/beatussum/beatussum-overlay.svg?branch=master)](https://travis-ci.org/beatussum/beatussum-overlay)

# Beatussum's Gentoo overlay

## About this

My **Gentoo** overlay aims to provide some packages that are not (yet) in the main **Gentoo** tree.

## Add this overlay

Just use [Layman](https://wiki.gentoo.org/wiki/Project:Layman) as _root_:

```bash
layman --list
layman --add  beatussum-overlay
layman --sync beatussum-overlay
```
