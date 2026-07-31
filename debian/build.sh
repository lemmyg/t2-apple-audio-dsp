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

# Copy all model configs to package (for postinst to select based on model)
mkdir -p temp/usr/share/t2-apple-audio-dsp
cp -r configs temp/usr/share/t2-apple-audio-dsp/

# Install wav, json, and Lua scripts to /usr/share/t2-linux-audio (same as install.sh)
for model_dir in configs/*/; do
    if [ -d "$model_dir" ]; then
        model=$(basename "$model_dir")
        mkdir -p "temp/usr/share/t2-linux-audio/${model}"
        for ext in wav json; do
            for file in "$model_dir"*."$ext"; do
                [ -e "$file" ] || continue
                cp "$file" "temp/usr/share/t2-linux-audio/${model}/"
            done
        done
        for file in configs/*.lua; do
            [ -e "$file" ] || continue
            cp "$file" "temp/usr/share/t2-linux-audio/${model}/"
        done
        chmod 755 "temp/usr/share/t2-linux-audio/${model}" 2>/dev/null || true
        chmod 644 "temp/usr/share/t2-linux-audio/${model}"/* 2>/dev/null || true
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

