# Apple T2 ALSA UCM Profile

This directory contains the ALSA UCM profile for Apple T2 audio hardware.

The `ucm2/` tree mirrors the `alsa-ucm-conf` upstream layout so the profile can
be prepared as a separate upstream submission from the kernel driver.

Source: [KaiT2en-Fedora `t2bce_audio-alsa-ucm-conf`](https://github.com/KaiT2en/KaiT2en-Fedora/tree/main/modules/t2bce_audio-alsa-ucm-conf)

Installed to `/usr/share/alsa/ucm2` by `install-ucm.sh` (separate from the DSP install).

```sh
./install-ucm.sh
./uninstall-ucm.sh
```
