#! /usr/bin/env python

import os
import subprocess
import re

def get_plugin_dir():
    working_dir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    return os.path.join(working_dir, "plugins/TerrainControl")

def run(command):
    proc = subprocess.Popen(command, shell = True, stdout = subprocess.PIPE) 
    return proc.stdout.read()

def get_data():
    biomes_dir = os.path.join(get_plugin_dir(), "worlds/world/WorldBiomes")
    lines = run("grep -R 'BiomeRarity' " + biomes_dir).split("\n")
    data = {}
    for i in range(len(lines)):
        line = re.sub('^' + re.escape(biomes_dir) + '\/', '', lines[i])
        params = re.match('^(.+)\:BiomeRarity\:\s(\d+)$', line)
        if params:
            biome = params.group(1)
            rarity = int(params.group(2))
            if rarity in data:
                data[rarity].append(biome)
            else:
                data[rarity] = [biome]
    return data

def get_used_biomes():
    config_filename = os.path.join(get_plugin_dir(), "worlds/world/WorldConfig.ini")
    used_biomes = {}
    border_biomes = {}
    for biomeType in ['NormalBiomes', 'IceBiomes', 'IsleBiomes', 'BorderBiomes']:
        string = run("grep '" + biomeType + ":' " + config_filename)
        string = re.sub('^' + re.escape(biomeType) + '\:\s*', '', string)
        biomes = string.split(",")
        for biome in biomes:
            biome = re.sub("\n$", '', biome)
            used_biomes[biome] = True
            if biomeType == 'BorderBiomes':
                border_biomes[biome] = True

    return used_biomes, border_biomes

def main():
    used_biomes, border_biomes = get_used_biomes()
    unused_biomes = {}
    data = get_data()
    rarities = list(reversed(sorted(data.keys())))
    for rarity in rarities:
        for biome in sorted(data[rarity]):
            shortBiome = re.sub('\.bc$', '', biome)
            if shortBiome in used_biomes:
                if shortBiome in border_biomes:
                    print biome + ": " + str(rarity) + " *"
                else:
                    print biome + ": " + str(rarity) + ""
            else:
                unused_biomes[biome] = True

    if any(unused_biomes):
        print 'WARNING: unused biomes: ' + ", ".join(unused_biomes.keys())

if __name__ == "__main__":
    main()
