#!/bin/bash
mkdir temp
mkdir temp/DEBIAN
control=debian/control
control=debian/control
# get version from control file
version=$(grep "Version:" "$control" | cut -d ' ' -f 2)
package=$(grep "Package:" "$control" | cut -d ' ' -f 2)

#copy files
cp $control temp/DEBIAN/control
mkdir -p temp/etc/pipewire/pipewire.conf.d
cp config/10-t2_mic.conf temp/etc/pipewire/pipewire.conf.d
#generate debian package
output="${package}_${version}_amd64.deb"
echo "package ${output}"
dpkg-deb --root-owner-group -Zgzip --build temp $output
echo "tag=$(ls t2-apple-audio-dsp-*)"

