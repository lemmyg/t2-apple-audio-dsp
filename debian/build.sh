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
chmod +x temp/DEBIAN/postinst
if [ -f debian/postrm ]; then
    cp debian/postrm temp/DEBIAN/postrm
    chmod +x temp/DEBIAN/postrm
fi
if [ -f debian/copyright ]; then
    cp debian/copyright temp/DEBIAN/copyright
fi

# Copy install script to /usr/local/bin
mkdir -p temp/usr/local/bin
cp install.sh temp/usr/local/bin/t2-apple-audio-dsp-install
chmod 755 temp/usr/local/bin/t2-apple-audio-dsp-install

# Copy all model configs to package (for postinst to select based on model)
mkdir -p temp/usr/share/t2-apple-audio-dsp
cp -r config temp/usr/share/t2-apple-audio-dsp/

# Install FIR files directly to final location for all models
# This ensures they're available at boot time, avoiding timing issues
for model_dir in firs/*/; do
    if [ -d "$model_dir" ]; then
        model=$(basename "$model_dir")
        mkdir -p "temp/usr/share/pipewire/devices/${model}"
        cp "$model_dir"*.wav "temp/usr/share/pipewire/devices/${model}/" 2>/dev/null
        # Ensure directory and files are readable by all
        chmod 755 "temp/usr/share/pipewire/devices/${model}" 2>/dev/null || true
        chmod 644 "temp/usr/share/pipewire/devices/${model}"/*.wav 2>/dev/null || true
    fi
done

# Install copyright file for package managers (KDE Discover, etc.)
if [ -f debian/copyright ]; then
    mkdir -p temp/usr/share/doc/${package}
    cp debian/copyright temp/usr/share/doc/${package}/copyright
fi

#generate debian package
output="${package}_${version}_amd64.deb"
echo "Building package ${output}"
dpkg-deb --root-owner-group -Zgzip --build temp $output
# remove temp folder
rm -r temp
echo "Package built: ${output}"

# Generate SHA256 checksum and show package info
echo "Generating checksum..."
sha256sum "$output" > "${output}.sha256"
echo "Package info:"
echo "  SHA256: $(cat ${output}.sha256)"
echo "  Size:   $(ls -lh $output | awk '{print $5}')"

