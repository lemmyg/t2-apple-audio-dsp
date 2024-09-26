# SPDX-License-Identifier: MIT
# (C) 2022 The Asahi Linux Contributors

{ config, pkgs, ... }:

let
  t2AppleAudioDSP = pkgs.fetchFromGitHub {
    owner = "lemmyg";
    repo = "t2-apple-audio-dsp";
    rev = "9422c57caeb54fde45121b9ea31628080da9d3bd";
    sha256 = "MgKBwE9k9zyltz6+L+VseSiQHS/fh+My0tNDpdllPNw=";
  };
in

{
  services.pipewire.configPackages = [
    (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-t2_headset_mic.conf" (builtins.readFile "${t2AppleAudioDSP}/config/10-t2_headset_mic.conf"))
    (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-t2_mic.conf" (builtins.readFile "${t2AppleAudioDSP}/config/10-t2_mic.conf"))
  ];
}
