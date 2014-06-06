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
            biome = re.sub('\.bc$', '', params.group(1))
            rarity = int(params.group(2))
            if rarity in data:
                data[rarity].append(biome)
            else:
                data[rarity] = [biome]

    return data

def get_types_biomes():
    config_filename = os.path.join(get_plugin_dir(), "worlds/world/WorldConfig.ini")
    typesBiomes = {}
    typesBiomes['all'] = {}
    for biomeType in ['NormalBiomes', 'IceBiomes', 'IsleBiomes', 'BorderBiomes']:
        string = run("grep '" + biomeType + ":' " + config_filename)
        string = re.sub('^' + re.escape(biomeType) + '\:\s*', '', string)
        biomes = string.split(",")
        for biome in biomes:
            biome = re.sub("\n$", '', biome)
            if biomeType == 'IceBiomes':
                tmpBiomeType = 'NormalBiomes'
            else:
                tmpBiomeType = biomeType

            if not tmpBiomeType in typesBiomes:
                typesBiomes[tmpBiomeType] = {}

            typesBiomes[tmpBiomeType][biome] = True
            typesBiomes['all'][biome] = True

    return typesBiomes

def main():
    typesBiomes = get_types_biomes()
    data = get_data()
    unused_biomes = {}
    rarities = list(reversed(sorted(data.keys())))
    for biomeType in typesBiomes:
        typeBiomes = typesBiomes[biomeType]
        if biomeType != 'all':
            print '==== ' + biomeType + ' ===='
            totalRarity = 0
            for rarity in rarities:
                for biome in data[rarity]:
                    if biome in typeBiomes:
                        totalRarity += rarity

            for rarity in rarities:
                for biome in sorted(data[rarity]):
                    if biome in typeBiomes:
                        print "%s: %d (%.1f%%)" % (biome, rarity, 100.0 * rarity / totalRarity)
        else:
            for rarity in rarities:
                for biome in data[rarity]:
                    if not (biome in typeBiomes):
                        unused_biomes[biome] = True

    if any(unused_biomes):
        print 'WARNING: unused biomes: ' + ", ".join(unused_biomes.keys())

if __name__ == "__main__":
    main()
