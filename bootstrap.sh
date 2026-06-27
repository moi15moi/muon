#!/bin/sh
# SPDX-FileCopyrightText: Stone Tickle <lattis@mochiro.moe>
# SPDX-License-Identifier: GPL-3.0-only

# Requirements:
# - c99
# - sh

set -eux

dir="$1"
mkdir -p "$dir"

# clock_gettime() lived in librt before glibc 2.17 (e.g. CentOS <= 6).
# Probe for it rather than assuming, since systems without glibc (e.g.
# musl, Windows) typically have no separate librt to link against.
extra_libs=""
if printf 'int main(void){return 0;}' | ${CC:-c99} -x c - -lrt -o /dev/null >/dev/null 2>&1; then
    extra_libs="-lrt"
fi

# shellcheck disable=SC2086
${CC:-c99} ${CFLAGS:-} ${LDFLAGS:-} -Iinclude "src/amalgam.c" -o "$dir/muon-bootstrap" $extra_libs
