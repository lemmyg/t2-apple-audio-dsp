#!/bin/bash
mkdir temp
mkdir temp/DEBIAN
cp debian/control temp/DEBIAN/control

mkdir -p temp/etc/pipewire/pipewire.conf.d
cp  config/10-t2_161_speakers.conf temp/etc/pipewire/pipewire.conf.d

mkdir -p temp/usr/share/pipewire/devices/apple
cp firs/*.wav temp/usr/share/pipewire/devices/apple

dpkg-deb --build --root-owner-group -Zgzip temp
mv temp.deb t2-apple-audio-dsp-speakers161_1.0.0_amd64.deb
