Adds [XRoar](https://www.6809.org.uk/xroar/), a Dragon and Tandy Color Computer emulator (C, autotools).

Notes for review:

- **Linux only for now.** The recipe builds the ALSA and PulseAudio back ends, which are Linux-only. Upstream also supports macOS and Windows; those can come later in the feedstock.
- **SDL3.** conda-forge's `sdl2` is sdl2-compat over SDL3, and XRoar 1.12 supports SDL3 directly, so the recipe uses `sdl3`.
- **Licenses.** XRoar is GPL-3.0-or-later. Its bundled `portalib` (same author) is LGPL-3.0-or-later and includes a copy of the SDS string library (BSD-3-Clause, notice in `README.SDS`). All three license files are packaged.
- **X11.** XRoar calls Xlib directly as well as through SDL, so `xorg-libx11` is a host dependency (avoids an overlinking warning).
- Lints clean with `conda-smithy recipe-lint --conda-forge`, and `build-locally.py linux64` builds it and passes the tests.

Checklist

- [x] Title of this PR is meaningful: e.g. "Adding my_nifty_package", not "updated recipe".
- [x] Recipe uses the v1 `recipe.yaml` format, or this PR explains the exceptional requirement for deprecated v0.
- [x] License file is packaged (see the [v1 example recipe](https://github.com/conda-forge/staged-recipes/blob/main/recipes/example-v1/recipe.yaml) for an example).
- [x] Source is from official source.
- [x] Package does not vendor other packages. (If a package uses the source of another package, they should be separate packages or the licenses of all packages need to be packaged).
- [x] If static libraries are linked in, the license of the static library is packaged.
- [x] Package does not ship static libraries. If static libraries are needed, [follow CFEP-18](https://github.com/conda-forge/cfep/blob/main/cfep-18.md).
- [x] Build number is 0.
- [x] A tarball (`url`) rather than a repo (e.g. `git_url`) is used in your recipe (see [here](https://conda-forge.org/docs/maintainer/adding_pkgs.html#build-from-tarballs-not-repos) for more details).
- [ ] GitHub users listed in the maintainer section have posted a comment confirming they are willing to be listed there.
- [x] When in trouble, please check our [knowledge base documentation](https://conda-forge.org/docs/maintainer/knowledge_base.html) before pinging a team.
