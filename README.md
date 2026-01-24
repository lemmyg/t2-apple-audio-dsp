## T2 Linux Audio DSP configuration.

Based on Asahi Linux userspace audio configuration. on  MacBook Pro 16 2019 T2.

Thanks to Asahi Linux, chadmed, Drakelerex and Manawyrm.

## Supported models:
    
    # MacBook Pro 16 2019: Id: 16_1

    The project has been adjusted to test Asahi Linux audio workflow on a MacBook Pro 16 2019 with T2 audio driver.

    New FIRs were created measuring the MacBook Pro 16 with UMIK-1 mic and manually created FIRs of EQ filters using REW.

    For more information about Asahi audio, please visit the original project at [asahi-audio](https://github.com/chadmed/asahi-audio)

    Using chadmed bankstown-lv2 and triforce-lv2 plugins. 

    
    # MacBook Air 2020: Id: 9_1

    The project has been adjusted to test Asahi Linux audio workflow on a MacBook Air 2020 with T2 audio driver.

    The Impulse files for the M1 Macbook Air J313 made by Asahi Linux were used because I believe that it has the same speakers as the 2020 Intel MacBook Air

    For more information about Asahi audio, please visit the original project at asahi-audio



## Installation instructions

First follow [t2-audio](https://wiki.t2linux.org/guides/audio-config) instructions and install pipewire.

Once the audio is working, you can install the FIRs config in your system.
Note that this configuration has been tested on Ubuntu 25.10. 
For previous versions please check speakers_161 branch.

### 1a - Ubuntu

Download and Install the Ubuntu package:

https://github.com/lemmyg/t2-apple-audio-dsp/releases/download/master-v0.5.0-1/t2-apple-audio-dsp_0.5.0-1_amd64.deb

Manual installation:

```sh
sudo apt install pipewire pipewire-audio-client-libraries libpipewire-0.3-modules libspa-0.2-{bluetooth,jack,modules} pipewire{,-{audio-client-libraries,pulse,bin,tests}}
sudo apt install wireplumber bankstown-lv2 triforce-lv2 lsp-plugins-lv2 swh-lv2
```
Clone the git branch and install the FIRs config:

```sh
git clone -b speakers_161 https://github.com/lemmyg/t2-apple-audio-dsp.git
cd t2-apple-audio-dsp
bash install.sh
```

### 1b - NixOS

Copy `pipewire_sink_conf.nix` to `/etc/nixos/` and import it in `configuration.nix`.

Add `ladspaPlugins`, `calf` and `lsp-plugins` to `environment.systemPackages` in `configuration.nix`.'

To make the LADSPA + LV2 plugins available for PipeWire we also need to add these ENVs:

```
systemd.user.services.pipewire.environment = {
    LADSPA_PATH = "${pkgs.ladspaPlugins}/lib/ladspa";
    LV2_PATH = "${config.system.path}/lib/lv2";
};
```

Rebuid:
```
sudo nixos-rebuild switch   
```

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
