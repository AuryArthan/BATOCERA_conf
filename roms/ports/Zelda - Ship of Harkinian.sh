#!/bin/sh

DIR="$(dirname "$(readlink -f "$0")")"
cd ${DIR}/.data/ShipOfHarkinian

./soh.appimage
