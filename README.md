# xroar-builds

Linux x86_64 builds of [XRoar](https://www.6809.org.uk/xroar/), the Dragon
and Tandy Color Computer emulator by Ciaran Anscomb. Upstream ships source and
Windows/macOS binaries only; these releases exist so that
[mise](https://mise.jdx.dev/) can install XRoar on Linux:

```toml
[tools]
"github:klp2/xroar-builds" = { version = "latest", asset_pattern = "xroar-*-linux-x86_64.tar.gz" }
```

Each release is built in an `ubuntu:22.04` container, so it runs on that and
newer distros, and links the system's SDL2, ALSA, PulseAudio, libsndfile, and
libpng (any desktop Linux has them). The front ends match Homebrew's build:
the SDL2 UI, without GTK.

## Releasing a new version

`VERSION` pins the upstream version and the sha256 of its source tarball;
upstream publishes no checksums or signatures. A weekly workflow opens an issue
when upstream has a newer tarball. To release it, check the tarball, update
`VERSION`, and push: the release workflow builds `v<version>` if that release
doesn't exist yet. `./build.sh` runs the same build locally:

```sh
podman run --rm -v "$PWD:/repo:Z" -w /repo ubuntu:22.04 ./build.sh
```

## conda-forge

`conda-forge/recipe.yaml` is a recipe for submitting XRoar to
[conda-forge](https://conda-forge.org/) through
[staged-recipes](https://github.com/conda-forge/staged-recipes). Once it is
accepted, mise installs it as `conda:xroar` and this repository is no longer
needed. Test it locally with `rattler-build build --recipe
conda-forge/recipe.yaml -c conda-forge` and a variant config that sets
`c_stdlib: sysroot` (conda-forge's CI provides one).

## License

XRoar is GPL-3.0-or-later; its bundled portalib is LGPL-3.0-or-later and
includes the SDS string library (BSD-3-Clause). Every release attaches the
upstream source tarball it was built from. The build scripts here are under the same license.
