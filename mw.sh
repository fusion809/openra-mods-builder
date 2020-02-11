#!/bin/bash
set -e
if ! [[ -f GeoLite2-Country.mmdb.gz ]]; then
    printf "You need to download GeoLite2-Country.mmdb.gz from MaxMind\n"
    printf "and place it in the top level of this repository in order for\n"
    printf "this AppImage to build.\n"
    printf "To do this you need to create a MaxMind account.\n"
    printf "Further information can be found at:\n"
    printf "https://dev.maxmind.com/geoip/geoip2/geolite2/.\n"
    exit 0
fi

if ! [[ -d Medieval-Warfare ]]; then
    git clone https://github.com/CombinE88/Medieval-Warfare
fi

cd Medieval-Warfare
git stash
git checkout 3b9d21e50ad3f3f9979c6fd4922752f761a227f6
patch -Np1 -i ../fetch-engine.patch

if [[ -d engine ]]; then
    rm -rf engine
fi

make
cd packaging/linux
./buildpackage.sh 258.git.3b9d21e ../../../
cd ../../..
