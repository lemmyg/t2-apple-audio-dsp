# Installation paths (shared by standalone and deb install)

Both the standalone install script and the deb package install to the same locations.

## Files installed

| Purpose | Path |
|--------|------|
| ALSA card rename udev rule | `/etc/udev/rules.d/99-t2-audio-rename.rules` — sets card id to `t2-<MODEL_DIR>` (e.g. `t2-16_1`) |
| WirePlumber DSP config | `/etc/wireplumber/wireplumber.conf.d/50-t2-audio.conf` (from `configs/wireplumber.conf`) |
| FIRs and DSP graphs | `/usr/share/t2linux-audio/<MODEL_DIR>/` — e.g. `16_1`, `9_1` — `.wav`, `graph.json`, `mic.json` |

`<MODEL_DIR>` is the DMI product name with the comma replaced by an underscore
and the `MacBookAir`/`MacBookPro` prefix dropped, e.g. `MacBookPro16,1` → `16_1`.

## UCM files (separate install)

| Purpose | Path |
|--------|------|
| ALSA UCM profiles | `/usr/share/alsa/ucm2/AppleT2/` — `HiFi-x2.conf`, `HiFi-x4.conf`, `HiFi-x6.conf` |
| ALSA UCM card bindings | `/usr/share/alsa/ucm2/conf.d/AppleT2x{2,4,6}/` — channel-layout-specific driver profiles |

UCM source files live in `ucm2/` in the repo. They are not shipped in the deb,
which pulls them in through its `apple-t2-audio-config` dependency.

## Scripts

### DSP config

- **Standalone**: run `./install.sh` from the source tree (requires `configs/`). Installs the udev rule, the WirePlumber config, and the model's FIRs and graphs into the paths above.
- **Deb**: the package ships all model configs under `/usr/share/t2-apple-audio-dsp/configs` and the FIRs and graphs under `/usr/share/t2linux-audio`; postinst installs the udev rule and the WirePlumber config for the detected model (the audio data is already in place).

**Verify**: `./check-install.sh`

**Uninstall**: `./uninstall.sh` removes the udev rule, the WirePlumber config, and `/usr/share/t2linux-audio`. It also clears the Lua symlink and old PipeWire configs left behind by pre-1.1 versions.

### UCM config

- **Standalone**: run `./install-ucm.sh` from the source tree (uses `./ucm2` by default, or a path passed as the first argument).

**Verify**: `./check-install-ucm.sh`

**Uninstall**: `./uninstall-ucm.sh`

Install UCM before the DSP config so PipeWire/WirePlumber see the correct ALSA devices.
