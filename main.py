# SPDX-License-Identifier: MIT
# (C) 2023 Linux T2 Kernel Team
import subprocess
import glob
import os
import sys
import shutil

CONFIGS = {
    "MacBookPro16,1": ["config/t2_161_mic.conf"],
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
        for configPath in glob.glob(f"{INSTALL_PATH}/*t2_161_mic.conf"):
             os.remove(configPath)
        for configPath in CONFIGS.get(model):
            filename = os.path.basename(configPath)
            print(f"Copying: {configPath} to {INSTALL_PATH}/10-{filename}")
            shutil.copy2(configPath, f"{INSTALL_PATH}/10-{filename}")
    except Exception as e:
        print("Error found: {}".format(e))
        return False
    return True


def main():
    
    model = getModel()
    if not model in CONFIGS:
        print(f"Sorry, the {model} model is not currently supported.")
        exit()
        
    print(f"This machine is a supported {model} model.\n")
    print("Installing PipeWire configuration files...\n")
    ok = installConf(model)
    if not ok:
        print("Could not install PipeWire configuration files.")
        print("This program will now exit.")
        exit()
    
if __name__ == "__main__":
    main()
