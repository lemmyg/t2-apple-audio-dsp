
### T2 Linux Audio DSP configuration.

Based on Asahi Linux userspace audio configuration.
This project is part of [T2 kernel team](https://wiki.t2linux.org/).

The project aims to create Pipewire filtechain configs to adjust the audio levels for buildin microphone and speakers in Linux. 
Thanks to Asahi Linux, chadmed, Drakelerex and Manawyrm.

## Supported models:
    
    # MacBook Pro 16 2019: Id: 16_1, 16_2 and 16_4

    The project has been adjusted to test Asahi Linux audio workflow on a MacBook Por 16 2019 T2 audio driver.

    The Impulse files were created measuring speakers with REW. For Apple mic, using triforce-lv2 plugins.

    For more information about Asahi audio, please visit the original project at asahi-audio

    Using chadmed bankstown-lv2 and triforce-lv2 plugins. 

    
    # MacBook Air 2020: Id: 9_1

    The project has been adjusted to test Asahi Linux audio workflow on a MacBook Air 2020 with T2 audio driver.

    The Impulse files for the M1 Macbook Air J313 made by Asahi Linux were used because I believe that it has the same speakers as the 2020 Intel MacBook Air

    For more information about Asahi audio, please visit the original project at asahi-audio



## Installation instructions

Install the ALSA UCM profiles first (`./install-ucm.sh`). In the future these profiles will be shipped as an Ubuntu package or bundled directly with the kernel.

Install base T2 audio config from [t2-audio](https://wiki.t2linux.org/guides/audio-config)

Once the audio is working, you can install the FIRs config in your system.
Note that this configuration has been tested on Ubuntu 25.10. 
For previous versions please check speakers_161 and mic branches.

### 1a - Ubuntu dep package

Download and Install the Ubuntu package from master:

https://github.com/lemmyg/t2-apple-audio-dsp/releases

### 1b - Manual installation:

```sh
sudo apt install pipewire pipewire-pulse wireplumber libpipewire-0.3-modules-extra libspa-0.2-modules-extra
sudo apt install bankstown-lv2 triforce-lv2 lsp-plugins-lv2 swh-lv2
```
Clone the git branch and install the FIRs config:

```sh
git clone https://github.com/lemmyg/t2-apple-audio-dsp.git
cd t2-apple-audio-dsp
bash install.sh
```

### 1c - NixOS Module

**Currently only speakers are working. Let us know if the microphone setup works for you.**

Download `nixos/t2AppleAudioDSP.nix` from this repo and import it into your configuration. For example, place it in /etc/nixos and in your configuration.nix, add it to imports, like so:
```
...
  imports = [
    ./t2AppleAudioDSP.nix
  ];
...
```
Somewhere in your configuration, such as configuration.nix, add:
```
  t2AppleAudioDSP = {
    enable = true;
    model = "<your_model>";
  };
```
where `<your_model>` is one of "16_1" "16_4" and "9_1". 

Rebuid: 
```sudo nixos-rebuild switch```

### 2

To restart pipewire:

```sh
systemctl --user restart pipewire pipewire-pulse wireplumber
```

### 3

Reboot and open the audio settings.
"Apple Audio Driver Speakers" should be at 100% and "MacBook Pro T2 DSP Speakers" selected as main volumen control. Usually at 75% max.
Do not select "Apple Audio Driver Speakers" directly as the audio will be send directly to the speakers without any adjustment.

## Uninstall

### Ubuntu

```sh
bash uninstall.sh
```

### NixOS

Reverse installation steps and rebuild.

### Disclaimer
This project has been create to share the settings with [T2 kernel team](https://wiki.t2linux.org/). Note that the project is still under working in progress and may not be safe for general usage. Misconfigured settings in userspace could damage speakers permanently.

Thanks
