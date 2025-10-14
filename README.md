## Testing Asahi Linux userspace audio configuration on  MacBook Air 2020 T2.

Thanks to chadmed, Asahi Linux, and Manawyrm.

The project has been adjusted to test Asahi Linux audio workflow on a MacBook Air 2020 with T2 audio driver.

The Impulse files for the M1 Macbook Air J313 made by Asahi Linux were used because I believe that it has the same speakers as the 2020 Intel MacBook Air

For more information about Asahi audio, please visit the original project at [asahi-audio](https://github.com/chadmed/asahi-audio)

## Installation instructions

First follow [t2-audio](https://wiki.t2linux.org/guides/audio-config) instructions and install pipewire.

Once the audio is working, you can install the FIRs config in your system.
Note that this configuration has only been tested on Ubuntu 25.04

### 1a - Ubuntu

This configuration was tested with the default Ubuntu pipewire packages, however some plugins are needed

Older Ubuntu versions may be impacted by this bug, I believe that Ubuntu 24.04 is impacted
https://bugs.launchpad.net/ubuntu/+source/pipewire/+bug/2054223

Install the following dependecies:

```sh
sudo apt install pipewire pipewire-audio-client-libraries libpipewire-0.3-modules libspa-0.2-{bluetooth,jack,modules} pipewire{,-{audio-client-libraries,pulse,bin,tests}}
sudo apt install wireplumber lsp-plugins calf-plugins swh-plugins
```

### 3
"Apple Audio Driver Speakers" should be at 100% and "MacBook Air 9,1 Speakers" selected as main volume control. Usually at 75% max.
Do not select "Apple Audio Driver Speakers" directly as the audio will be send directly to the speakers without any adjustment.

## Uninstall
Remove any configuration files that were added, and audio should return to default

### Disclaimer
This project has been create to share the settings with [T2 kernel team](https://wiki.t2linux.org/). Note that the project is still under working in progress and may not be safe for general usage. Misconfigured settings in userspace could damage speakers permanently.

Thanks
