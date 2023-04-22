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
        raise Exception("Following error has been found: {}".format(stderr))
    return stdout.decode('utf-8').strip()


def installConf(model):
    
    # clean up the existing config files
    try:
        for configPath in glob.glob("{}/*t2_161_mic.conf".format(INSTALL_PATH)):
             os.remove(configPath)
        for configPath in CONFIGS.get(model):
            filename = os.path.basename(configPath)
            print("Copying: {CONFIG_PATH} to {INSTALL_PATH}/10-{FILENAME}".format(INSTALL_PATH=INSTALL_PATH, CONFIG_PATH=configPath, FILENAME=filename))
            shutil.copy2(configPath, "{INSTALL_PATH}/10-{FILENAME}".format(INSTALL_PATH=INSTALL_PATH, FILENAME=filename))
    except Exception as e:
        print("Error found: {}".format(e))
        return False
    return True


def main():
    
    model = getModel()
    if not model in CONFIGS:
        print("Sorry, the {} model is not currently supported.".format(model))
        exit()
        
    print("This machine is a supported {} model.\n".format(model))
    print("Installing PipeWire configuration files...\n")
    ok = installConf(model)
    if not ok:
        print("Could not install PipeWire configuration files.")
        print("This program will now exit.")
        exit()
    
if __name__ == "__main__":
    main()
