## Testing Asahi Linux userspace audio configuration on  MacBook Air 2020 T2.

Thanks to chadmed, Asahi Linux, and Manawyrm.

The project has been adjusted to test Asahi Linux audio workflow on a MacBook Air 2020 with T2 audio driver.

The files made by Asahi Linux for the M1 Macbook Air J313 were used.

For more information about Asahi audio, please visit the original project at [asahi-audio](https://github.com/chadmed/asahi-audio)

## Installation instructions

First follow [t2-audio](https://wiki.t2linux.org/guides/audio-config) instructions and install pipewire.

Once the audio is working, you can install the FIRs config in your system.
Note that this configuration has only been tested on Ubuntu 25.04

### 1a - Ubuntu

This configuration was tested with the default Ubuntu pipewire packages, however some plugins are needed

https://bugs.launchpad.net/ubuntu/+source/pipewire/+bug/2054223

Install the following dependecies:

```sh
sudo add-apt-repository ppa:pipewire-debian/pipewire-upstream
sudo apt update
sudo apt upgrade
sudo apt install pipewire pipewire-audio-client-libraries libpipewire-0.3-modules libspa-0.2-{bluetooth,jack,modules} pipewire{,-{audio-client-libraries,pulse,bin,tests}}
sudo apt install wireplumber lsp-plugins calf-plugins swh-plugins
```
Clone the git branch and install the FIRs config:

```sh
git clone -b speakers_161 https://github.com/lemmyg/t2-apple-audio-dsp.git
cd t2-apple-audio-dsp
bash install.sh
```

### 2

To restart pipewire:

```sh
systemctl --user restart pipewire pipewire-pulse wireplumber
```

### 3

Reboot and open the audio settings.
"Apple Audio Driver Speakers" should be at 100% and "MacBook Air 9,1 Speakers" selected as main volume control. Usually at 75% max.
Do not select "Apple Audio Driver Speakers" directly as the audio will be send directly to the speakers without any adjustment.

## Uninstall

### Ubuntu

```sh
bash uninstall.sh
```

### Disclaimer
This project has been create to share the settings with [T2 kernel team](https://wiki.t2linux.org/). Note that the project is still under working in progress and may not be safe for general usage. Misconfigured settings in userspace could damage speakers permanently.

Thanks
