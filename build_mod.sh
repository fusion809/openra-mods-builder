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

# Define variables
repo_owner="$1"
repo_name="$2"
if [[ -n $3 ]]; then
    commit_hash="$3"
    commit_7hash=$(echo ${commit_hash} | head -c 7)
    commit_number="$4"
fi

# Clone repo
if ! [[ -d ${repo_name} ]]; then
    git clone https://github.com/${repo_owner}/${repo_name}
fi

cd ${repo_name}

git stash
if [[ -n ${commit_hash} ]]; then
    git checkout ${commit_hash}
fi

patch -Np1 -i ../fetch-engine.patch

if [[ -d engine ]]; then
    rm -rf engine
fi

make || (printf "The build of the mod failed.\n" && exit 0)

cd packaging/linux
if [[ -n ${commit_number} ]]; then
    ./buildpackage.sh ${commit_number}.git.${commit_7hash} ../../../
else
    ./buildpackage.sh $(git rev-list --branches $(git rev-parse --abbrev-ref HEAD) --count).git.$(git log | head -n 1 | cut -d ' ' -f 2 | head -c 7) ../../../
fi

cd ../../..
