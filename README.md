### MacBook Pro T2 Pipewire Filterchain Configs


### Macbook pro 16 2019 speakers DSP Config

Thanks to chadmed and Asahi Linux.

Based on Asahi Linux speakers filterchain configs.

New FIRs were created measuring a MacBook Pro 16,1 2019 with UMIK-1 mic and manually created FIRs of EQ filters using REW.

For more information about Asahi audio, please visit the original project at [asahi-audio](https://github.com/chadmed/asahi-audio)

## Installation instructions

First follow [t2-audio](https://wiki.t2linux.org/guides/audio-config) instructions and install pipewire.

Once the audio is working, you can install the FIRs config in your system.
Note that this configuration has been tested on Ubuntu 22.04 and 22.10 and above.
For Ubuntu user, 22.10 is recommended as Pipewire is properly integrated.

Install the following dependecies:
```sh
sudo add-apt-repository ppa:pipewire-debian/pipewire-upstream
sudo apt install pipewire pipewire-audio-client-libraries libpipewire-0.3-modules libspa-0.2-{bluetooth,jack,modules} pipewire{,-{audio-client-libraries,pulse,bin,tests}}
sudo apt install wireplumber lsp-plugins calf-plugins
```
clone the git branch and install the FIRs config:
```sh
git clone https://github.com/lemmyg/t2-apple-audio-dsp.git
cd t2-apple-audio-dsp
bash install.sh --config speakers
```
Reboot and open the audio settings.
"Apple Audio Driver Speakers" should be at 100% and "MacBook Pro T2 DSP Speakers" selected as main volumen control. Usually at 75% max.
Do not select "Apple Audio Driver Speakers" directly as the audio will be send directly to the speakers without any adjustment.

## Uninstall
```sh
sudo rm /etc/pipewire/pipewire.conf.d/10-t2_161_speakers.conf
sudo rm -r /usr/share/pipewire/devices/apple
```

### Disclaimer
This project has been create to share the settings with [T2 kernel team](https://wiki.t2linux.org/). Note that the project is still under working in progress and may not be safe for general usage. Misconfigured settings in userspace could damage speakers permanently.

### Buildin 3 microphone  DSP config

This project aims to address the low audio signal issue caused by the T2 audio driver in the built in microphone in Linux by providing a Pipewire filterchain configuration that mixes and normalizes 3 mics digital audio signal in real-time. For more information about the T2 kernel team, please visit [T2 kernel team](https://wiki.t2linux.org/)

## Installation instructions

Before proceeding with the installation, please follow the [t2-audio](https://wiki.t2linux.org/guides/audio-config) instructions and install Pipewire.

Please note that this configuration has only been tested on version 22.10 and above. If you are an Ubuntu user, we recommend using version 22.10 as Pipewire is properly integrated with this version.

To install the configuration, first install the following dependencies:

```sh
sudo add-apt-repository ppa:pipewire-debian/pipewire-upstream
sudo apt update
sudo apt install pipewire wireplumber pipewire-audio-client-libraries libpipewire-0.3-modules libspa-0.2-{bluetooth,jack,modules} pipewire{,-{audio-client-libraries,pulse,bin,tests}}
sudo apt install swh-plugins
#compile and install librnnoise_ladspa plugin
git clone https://github.com/werman/noise-suppression-for-voice.git
cd noise-suppression-for-voice
cmake -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_VST_PLUGIN=OFF -DBUILD_VST3_PLUGIN=OFF -DBUILD_LV2_PLUGIN=OFF -DBUILD_LADSPA_PLUGIN=ON -DBUILD_AU_PLUGIN=OFF -DBUILD_AUV3_PLUGIN=OFF -DBUILD_TESTS=OFF
make -C build
sudo make -C build install
```

Next, clone the git branch and install the configuration by executing the following commands:

```sh
git clone https://github.com/lemmyg/t2-apple-audio-dsp.git
cd t2-apple-audio-dsp
bash install.sh --config mic
```
Reboot your device and open the audio settings. You should see "MacBook Pro T2 DSP Mic" as your new normalized source. Please note that the original source, "Apple Audio Device Builtin Microphone," should be set to 100%.

## Uninstall
To uninstall this configuration, please execute the following command in your terminal:

```sh
sudo rm /etc/pipewire/pipewire.conf.d/10-t2_mic.conf
```
## References

[normalization-chain](https://forum.endeavouros.com/t/pipewire-filter-chains-normalize-audio-noise-suppression/31661)

[librnnoise_ladspa-plugin](https://github.com/werman/noise-suppression-for-voice)

[pipewire-filtercahin](https://docs.pipewire.org/page_module_filter_chain.html)

[asahi-audio](https://github.com/chadmed/asahi-audio)

### Disclaimer
This configuration is designed to normalize the signal and limit it to -6 dB and should not cause any issues. However, please note that this configuration comes without any warranty and you use it at your own risk.
