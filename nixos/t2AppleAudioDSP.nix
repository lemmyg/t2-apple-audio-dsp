# SPDX-License-Identifier: MIT
# (C) 2022 The Asahi Linux Contributors
# https://github.com/lemmyg/t2-apple-audio-dsp/
# Version: master-v1.0.1

{ config, lib, pkgs, ... }:

{
  options.t2AppleAudioDSP = {
    enable = lib.mkEnableOption "";
    model = lib.mkOption {
      default = null;
      description = "The model of your T2 MacBook. Options are 16_1, 16_4 and 9_1.";
      type = lib.types.enum [ "16_1" "16_4" "9_1" ];
    };
  };

  config = lib.mkIf config.t2AppleAudioDSP.enable (
    let

      t2AppleAudioDSP = pkgs.fetchFromGitHub {
        owner = "lemmyg";
        repo = "t2-apple-audio-dsp";
        rev = "c3d45818ae6cba2b532bd50de010ba32fbe68f56";
        sha256 = "ZjZbsyhlFzGZ1Nv1ESm0Vvu+wHMgpiyCe5hcsZLyDCc=";
      };

      oldPath = "/usr/share/t2-linux-audio/${config.t2AppleAudioDSP.model}";
      newPath = "${t2AppleAudioDSP}/firs/${config.t2AppleAudioDSP.model}";
      configFile = "${t2AppleAudioDSP}/config/${config.t2AppleAudioDSP.model}/51-t2-dsp.conf";

      dspGraph = pkgs.runCommand "graph.json" {} ''
        cat ${newPath}/graph.json | sed -e 's|${oldPath}|${newPath}|g' > $out
      '';

      dspSinkConfig = pkgs.runCommand "51-t2-dsp.conf" {} ''
        cat ${configFile} > $out
        sed -i 's|${oldPath}/graph.json|${dspGraph}|g' $out
        sed -i 's|${oldPath}|${newPath}|g' $out
      '';

    in {

      environment.systemPackages = with pkgs; [ ladspaPlugins ];

      services.pipewire.wireplumber = {
        configPackages = [
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-t2-dsp.conf" (builtins.readFile "${dspSinkConfig}"))
        ];
        extraLv2Packages = with pkgs; [
          bankstown-lv2
          swh_lv2
          lsp-plugins 
          # triforce-lv2 override shouldn't be needed for 26.05 and later
          (triforce-lv2.overrideAttrs {
            meta.platforms = lib.platforms.linux;
          })
        ];
      };
  });
}
