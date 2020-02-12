#!/bin/bash
set -e

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    printf "Usage:\n\n"
    printf "./build_mod.sh owner name commit\n\n"
    printf "where owner is the owner of the GitHub repository of the mod.\n"
    printf "name is the name of said GitHub repository.\n"
    printf "commit is the commit we are building from. This argument is\n"
    printf "useful for when the latest commit has significant faults with it.\n"
    exit 0
fi

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
    commit_number=$(git -C ${repo_name} rev-list --count ${commit_hash})
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
find . -name "*.sh" -exec chmod +x {} \;

patch -Np1 -i ../patches/fetch-engine.patch

if [[ -d engine ]]; then
    rm -rf engine
fi

make || (printf "The build of the mod failed.\n" && exit 0)

cd packaging/linux
if [[ -n ${commit_hash} ]]; then
    ./buildpackage.sh ${commit_number}.git.${commit_7hash} ../../../
else
    ./buildpackage.sh $(git rev-list --branches $(git rev-parse --abbrev-ref HEAD) --count).git.$(git log | head -n 1 | cut -d ' ' -f 2 | head -c 7) ../../../
fi

cd ../../..
