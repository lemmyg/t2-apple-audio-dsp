# SPDX-License-Identifier: MIT
# (C) 2023 Linux T2 Kernel Team
import subprocess
import glob
import os
import sys
import shutil
import fnmatch
import traceback

CONFIGS = {
    "*":                "config/10-t2_mic.conf",
    "MacBookPro16,*":   "config/10-t2_161_speakers.conf",
}

INSTALL_PATH = "/etc/pipewire/pipewire.conf.d"


def getModel():
    # Get from the system the current model
    p = subprocess.Popen('dmidecode -s system-product-name', shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = p.communicate()
    if stderr:
        raise Exception(f"Following error has been found: {stderr}")
    return stdout.decode('utf-8').strip()


def installConf(model):
    # clean up the existing config files
    try:
        for configPath in glob.glob(f"{INSTALL_PATH}/*-t2_*.conf"):
             os.remove(configPath)
        for configModel, configPath in CONFIGS.items():
            if fnmatch.fnmatch(model, configModel):
                filename = os.path.basename(configPath)
                print(f"Copying: {configPath} to {INSTALL_PATH}/{filename}")
                shutil.copy2(configPath, f"{INSTALL_PATH}/{filename}")
            else:
                print(f"Ignoring: {configModel} and {configPath}, not supported for model {model}")
    except Exception as e:
        print(f"Could not install PipeWire configuration files: {e}")
        traceback.print_exc()
        exit()
    return


def main():
    
    model = getModel()
    print(f"Found {model} model.")
    print("Installing PipeWire configuration files...")
    installConf(model)
    
    
if __name__ == "__main__":
    main()
