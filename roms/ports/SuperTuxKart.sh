#!/bin/sh

DIR="$(dirname "$(readlink -f "$0")")"
cd ${DIR}/.data/SuperTuxKart

./run_game.sh
