# Beatussum's Gentoo overlay

## About this

My **Gentoo** overlay aims to provide some packages that are not (yet) in the
main **Gentoo** tree.

## Add this overlay

Just use with [eselect-repository](https://wiki.gentoo.org/wiki/Eselect/Repository) as _root_:

```bash
eselect repository list
eselect repository enable beatussum-overlay
emaint sync --repo beatussum-overlay
```
