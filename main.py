# SPDX-License-Identifier: MIT
# (C) 2023 Linux T2 Kernel Team
import subprocess
import glob
import os
import sys
import shutil
import fnmatch
import traceback
import argparse
CONFIG = {
    "mic":      {"*":                   [["config/10-t2_mic.conf", "/etc/pipewire/pipewire.conf.d"]]},
    "speakers": {"MacBookPro16,*":      [["config/10-t2_161_speakers.conf", "/etc/pipewire/pipewire.conf.d"],
                                         ["firs/t2_161/*.wav", "/usr/share/pipewire/devices/apple"]]}
}



def getModel():
    # Get from the system the current model
    p = subprocess.Popen('dmidecode -s system-product-name', shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = p.communicate()
    if stderr:
        raise Exception(f"Following error has been found: {stderr}")
    return stdout.decode('utf-8').strip()


def installConf(model, configNames):
    # clean up the existing config files
    print(f"Installing PipeWire configuration files for {model}")
    try:
        for config in configNames:
            for configModel, paths in CONFIG[config].items():
                if not fnmatch.fnmatch(model, configModel):
                    # early check
                    print(f"Ignoring: {configModel} and {configPath}, not supported for model {model}")
                    continue
                for configPattern, installPath in paths:
                    filePattern = os.path.basename(configPattern)
                    # clean the destination
                    for configPath in glob.glob(f"{installPath}/{filePattern}"):
                         # print(f"cleaning {configPath}")
                         os.remove(configPath)
            
                    # copy files
                    for configPath in glob.glob(configPattern):
                        filename = os.path.basename(configPath)
                        print(f"Copying: {configPath} to {installPath}/{filename}")
                        shutil.copy2(configPath, f"{installPath}/{filename}")
    except Exception as e:
        print(f"Could not install PipeWire configuration files: {e}")
        traceback.print_exc()
        exit()
    return


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--config', choices=['mic', 'speakers', 'all'], default="all")
    args = parser.parse_args()
    if args.config == "all":
        configs = ["mic", "speakers"]
    elif args.config == "mic":
        configs = ["mic"]
    elif args.config == "speakers":
        configs = ["mic"]
    else:
        raise
    model = getModel()
    installConf(model, configs)
    
    
if __name__ == "__main__":
    main()
