## Testing Asahi Linux userspace audio configuration on  MacBook Pro 16 2019 T2.

Thanks to chadmed and Asahi Linux.

The project has been adjusted to test Asahi Linux audio workflow on a MacBook Pro 16 2019 with T2 audio driver.

New FIRs were created measuring the MacBook Pro 16 with UMIK-1 mic and manually created FIRs of EQ filters using REW.

For more information about Asahi audio, please visit the original project at [asahi-audio](https://github.com/chadmed/asahi-audio)

## Installation instructions

First follow [t2-audio](https://wiki.t2linux.org/guides/audio-config) instructions and install pipewire.

Once the audio is working, you can install the FIRs config in your system.
Note that this configuration has been tested on Ubuntu 22.04 and 22.10. 
For Ubuntu user, 22.10 is recommended as Pipewire is properly integrated.

Install the following dependecies:

```sh
sudo add-apt-repository ppa:pipewire-debian/pipewire-upstream
sudo apt install pipewire pipewire-audio-client-libraries libpipewire-0.3-modules libspa-0.2-{bluetooth,jack,modules} pipewire{,-{audio-client-libraries,pulse,bin,tests}}
sudo apt install wireplumber lsp-plugins calf-plugins swh-plugins
```
clone the git branch and install the FIRs config:

```sh
git clone -b macbookT2_16_1 https://github.com/lemmyg/asahi-audio.git
cd asahi-audio
bash mac-audio.sh
```
Reboot and open the audio settings.
"Apple Audio Driver Speakers" should be at 100% and "MacBook Pro T2 DSP Speakers" selected as main volumen control. Usually at 75% max.
Do not select "Apple Audio Driver Speakers" directly as the audio will be send directly to the speakers without any adjustment.

## Uninstall
```sh
sudo rm /etc/pipewire/pipewire.conf.d/10-*-sink.conf
sudo rm -r /usr/share/pipewire/devices/apple
```


### Disclaimer
This project has been create to share the settings with [T2 kernel team](https://wiki.t2linux.org/). Note that the project is still under working in progress and may not be safe for general usage. Misconfigured settings in userspace could damage speakers permanently.

Thanks
