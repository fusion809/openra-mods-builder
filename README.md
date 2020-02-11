# OpenRA mods builder
This repository has scripts to make building unofficial mods of OpenRA that are no longer under active development or maintenance by their developers easier on Linux. 

Recently, MaxMind&mdash;which provided the GeoLite2-Country.mmdb.gz file for download&mdash;decided to only allow manual downloads of this file, not automatic, the later of which the build scripts of OpenRA's engine previously relied upon. The engine's build scripts have since been updated so that this file is no longer required, but many mods that have not received regular maintenance or development in a while are now impossible to build without some patching of the build scripts. This repository provides those patches and incorporates it into an automated build system of AppImages for these mods. You will need to manually download the GeoLite2-Country.mmdb.gz file from MaxMind, however, see https://dev.maxmind.com/geoip/geoip2/geolite2/ for further information.

Beware that some of these mods had their SDK last updated before the AppImages started to incorporate their own Mono runtime, and hence they may not run without a Mono runtime installed on your host machine. 

Mods currently supported by this repository include:
- [Krush Kill n' Destroy](https://github.com/IceReaper/KKnD) &mdash; build using `kknd.sh`.
- [Medieval Warfare](https://github.com/CombinE88/Medieval-Warfare) &mdash; build using `mw.sh`. This script builds an older commit of this mod (namely commit number 258, hash: 3b9d21e), because the later commits do not build properly or their AppImages do not run. 
- [Red Alert Plus](https://github.com/MlemandPurrs/raplusmod) &mdash; build using `raplus.sh`.
- [Red Alert Unplugged](https://github.com/RAunplugged/uRA) &mdash; build using `ura.sh`. 