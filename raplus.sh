#!/bin/bash
if ! [[ -f GeoLite2-Country.mmdb.gz ]]; then
    printf "You need to download GeoLite2-Country.mmdb.gz from MaxMind\n"
    printf "and place it in the top level of this repository in order for\n"
    printf "this AppImage to build.\n"
    printf "To do this you need to create a MaxMind account.\n"
    printf "Further information can be found at:\n"
    printf "https://dev.maxmind.com/geoip/geoip2/geolite2/.\n"
    exit 0
fi

if ! [[ -d raplusmod ]]; then
    git clone https://github.com/MlemandPurrs/raplusmod
fi

cd raplusmod
git stash
patch -Np1 -i ../fetch-engine.patch

if [[ -d engine ]]; then
    rm -rf engine
fi

make
cd packaging/linux
./buildpackage.sh $(git-comno).git.$(git-hash7) ../../../
cd ../../..
