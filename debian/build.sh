#!/bin/bash
mkdir temp
mkdir temp/DEBIAN
control=debian/control
# get version from control file
version=$(grep "Version:" "$control" | cut -d ' ' -f 2)
package=$(grep "Package:" "$control" | cut -d ' ' -f 2)
#copy files
cp $control temp/DEBIAN/control
cp debian/postinst temp/DEBIAN/postinst

mkdir -p temp/etc/pipewire/pipewire.conf.d
cp config/10-t2_161_speakers.conf temp/etc/pipewire/pipewire.conf.d

mkdir -p temp/usr/share/pipewire/devices/apple
cp firs/*.wav temp/usr/share/pipewire/devices/apple

#generate debian package
output="${package}_${version}_amd64.deb"
echo "package ${output}"
dpkg-deb --root-owner-group -Zgzip --build temp $output
# remove temp folder
rm -r temp

