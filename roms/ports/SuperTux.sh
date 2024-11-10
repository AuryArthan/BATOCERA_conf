#!/bin/sh

DIR="$(dirname "$(readlink -f "$0")")"
cd ${DIR}/.data/SuperTux

./SuperTux-v0.6.3.glibc2.29-x86_64.AppImage
