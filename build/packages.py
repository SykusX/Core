#!/usr/bin/python
import configparser
from os import listdir, walk, makedirs, remove
from os.path import isfile, join, exists
import shutil, errno

package_folders = [f for f in listdir("packages") if not isfile(join("packages", f))]
package_file_both = open("archimg/packages.both", "a")
package_file_x86 = open("archimg/packages.i686", "a")
package_file_amd64 = open("archimg/packages.x86_64", "a")

for folder in package_folders:
    config = configparser.ConfigParser()
    config.read(join(join("packages", folder), "sykuspkg.ini"))
    if config["general"]["type"] == "official":

        root_src_dir = join(join("packages", folder), "cfg")
        root_dst_dir = "archimg/airootfs"

        if config["general"]["arch"] == "both":
            package_file_both.write(config["general"]["name"] + "\n")
        elif config["general"]["arch"] == "x86":
            package_file_x86.write(config["general"]["name"] + "\n")
        elif config["general"]["arch"] == "amd64":
            package_file_amd64.write(config["general"]["name"] + "\n")
        else:
            print("Architecture not supported for package: ", config["general"]["name"])

        for src_dir, dirs, files in walk(root_src_dir):
            dst_dir = src_dir.replace(root_src_dir, root_dst_dir, 1)
            if not exists(dst_dir):
                makedirs(dst_dir)
            for file_ in files:
                src_file = join(src_dir, file_)
                dst_file = join(dst_dir, file_)
                if exists(dst_file):
                    remove(dst_file)
                shutil.move(src_file, dst_file)
