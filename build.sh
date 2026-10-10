#!/usr/bin/env bash
# Build XRoar from the upstream source tarball pinned in VERSION and package it
# into dist/. Runs as root in an ubuntu:22.04 container (the release workflow,
# or podman locally): building against an old glibc keeps the binary running
# on newer distros. The binary links the system's SDL2, ALSA, PulseAudio,
# libsndfile, and libpng, which any desktop Linux already has.
set -euo pipefail

cd "$(dirname "$0")"
read -r version sha256 <VERSION
name="xroar-$version"
src="$name.tar.gz"
dist="$PWD/dist"
pkg="$name-linux-x86_64"

export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq --no-install-recommends \
  build-essential ca-certificates curl pkg-config \
  libsdl2-dev libasound2-dev libpulse-dev libsndfile1-dev libpng-dev zlib1g-dev >/dev/null

work=$(mktemp -d)
curl -fsSL "https://www.6809.org.uk/xroar/dl/$src" -o "$work/$src"
# Upstream publishes no checksums or signatures, so VERSION pins the hash
echo "$sha256  $work/$src" | sha256sum -c -

tar -xzf "$work/$src" -C "$work"
cd "$work/$name"
# Same front ends as Homebrew's build: SDL2 UI, no GTK
./configure --prefix=/ --without-gtk3 --without-gtk2
make -j"$(nproc)"
make install DESTDIR="$work/$pkg"
cp COPYING.GPL COPYING.LGPL README "$work/$pkg/"

# Fail the build rather than ship a binary missing a front end
modules=$("$work/$pkg/bin/xroar" -ui help 2>&1 && "$work/$pkg/bin/xroar" -ao help 2>&1)
for want in "SDL2 UI" "PulseAudio" "ALSA audio"; do
  grep -q "$want" <<<"$modules" || {
    echo "xroar build lacks: $want" >&2
    exit 1
  }
done

mkdir -p "$dist"
tar -czf "$dist/$pkg.tar.gz" -C "$work" "$pkg"
# The GPL source alongside the binary
cp "$work/$src" "$dist/"
(cd "$dist" && sha256sum "$pkg.tar.gz" "$src" >SHA256SUMS)
ls -l "$dist"
