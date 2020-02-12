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

if ! [[ -d KKnD ]]; then
    git clone https://github.com/IceReaper/KKnD
fi

cd KKnD
git stash
patch -Np1 -i ../patches/fetch-engine.patch

if [[ -d engine ]]; then
    rm -rf engine
fi

make
cd packaging/linux
./buildpackage.sh $(git rev-list --branches $(git rev-parse --abbrev-ref HEAD) --count).git.$(git log | head -n 1 | cut -d ' ' -f 2 | head -c 7) ../../../
cd ../../..