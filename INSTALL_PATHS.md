# Installation paths (shared by standalone and deb install)

Both the standalone install script and the deb package install to the same locations.

## Files installed

| Purpose | Path |
|--------|------|
| WirePlumber DSP config | `/etc/wireplumber/wireplumber.conf.d/` — `*-dsp.conf` installed here |
| FIRs, DSP graphs, Lua scripts | `/usr/share/t2-linux-audio/<MODEL_DIR>/` — e.g. `16_1`, `9_1` — `.wav`, `.json`, `.lua` |

## UCM files (separate install)

| Purpose | Path |
|--------|------|
| ALSA UCM profiles | `/usr/share/alsa/ucm2/AppleT2/` — `HiFi-x2.conf`, `HiFi-x4.conf`, `HiFi-x6.conf` |
| ALSA UCM card bindings | `/usr/share/alsa/ucm2/conf.d/AppleT2x{2,4,6}/` — channel-layout-specific driver profiles |

UCM source files live in `ucm2/` in the repo (or `/usr/share/t2-apple-audio-dsp/ucm2` in the deb package).

## Symlinks created

| Symlink | Target |
|---------|--------|
| `/usr/share/wireplumber/scripts/device/<name>.lua` | → `/usr/share/t2-linux-audio/<MODEL_DIR>/<name>.lua` |

(One symlink per Lua script in the model directory.)

## Scripts

### DSP config

- **Standalone**: run `./install.sh` from the source tree (requires `config/` and `firs/`). Installs config and FIRs into the paths above and creates the symlinks.
- **Deb**: package installs config under `/usr/share/t2-apple-audio-dsp/config` and FIRs under `/usr/share/t2-linux-audio`; postinst installs WirePlumber config and creates the symlinks only (FIRs are already in place).

**Uninstall**: `./uninstall.sh` removes the WirePlumber config, Lua symlinks, and `/usr/share/t2-linux-audio`.

### UCM config

- **Standalone**: run `./install-ucm.sh` from the source tree (uses `./ucm2` by default).
- **Deb**: run `/usr/share/t2-apple-audio-dsp/install-ucm.sh`.

**Uninstall**: `./uninstall-ucm.sh` (or the deb copy under `/usr/share/t2-apple-audio-dsp/`).

Install UCM before DSP config so PipeWire/WirePlumber see the correct ALSA devices.
