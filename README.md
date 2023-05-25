## Improving Audio Quality on MacBook Pro T2 Builtin Microphones in Linux Using Pipewire Filterchain Config

This project aims to address the low audio signal issue caused by the T2 audio driver in the built in microphone in Linux by providing a Pipewire filterchain configuration that mixes and normalizes 3 mics digital audio signal in real-time. For more information about the T2 kernel team, please visit [T2 kernel team](https://wiki.t2linux.org/)

## Installation instructions

Before proceeding with the installation, please follow the [t2-audio](https://wiki.t2linux.org/guides/audio-config) instructions and install Pipewire.

Please note that this configuration has only been tested on version 22.10. If you are an Ubuntu user, we recommend using version 22.10 as Pipewire is properly integrated with this version.

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
cd t2-apple-mic-dsp
bash install.sh
```
Reboot your device and open the audio settings. You should see "MacBook Pro T2 DSP Mic" as your new normalized source. Please note that the original source, "Apple Audio Device Builtin Microphone," should be set to 100%.

## Uninstall
To uninstall this configuration, please execute the following command in your terminal:

```sh
sudo rm /etc/pipewire/pipewire.conf.d/*t2_161_mic.conf
```
## References

[normalization-chain](https://forum.endeavouros.com/t/pipewire-filter-chains-normalize-audio-noise-suppression/31661)

[librnnoise_ladspa-plugin](https://github.com/werman/noise-suppression-for-voice)

[pipewire-filtercahin](https://docs.pipewire.org/page_module_filter_chain.html)

### Disclaimer
This configuration is designed to normalize the signal and limit it to -6 dB and should not cause any issues. However, please note that this configuration comes without any warranty and you use it at your own risk.
