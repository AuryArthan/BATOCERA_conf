#!/bin/sh

DIR="$(dirname "$(readlink -f "$0")")"
cd ${DIR}/.data/Render96

unclutter-remote -h
./sm64.us.f3dex2e
