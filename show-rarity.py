#! /usr/bin/env python

import os
import subprocess
import re
import yaml

def get_data_dir():
    return os.path.dirname(os.path.realpath(__file__))

def get_plugin_dir():
    working_dir = os.path.dirname(get_data_dir())
    return os.path.join(working_dir, "plugins/TerrainControl")

def run(command):
    proc = subprocess.Popen(command, shell = True, stdout = subprocess.PIPE) 
    return proc.stdout.read()

def get_rarities_data():
    biomes_dir = os.path.join(get_plugin_dir(), "worlds/world/WorldBiomes")
    lines = run("grep -R 'BiomeRarity' " + biomes_dir).split("\n")
    rarities_data = {}
    for i in range(len(lines)):
        line = re.sub('^' + re.escape(biomes_dir) + '\/', '', lines[i])
        params = re.match('^(.+)\:BiomeRarity\:\s(\d+)$', line)
        if params:
            biome = re.sub('\.bc$', '', params.group(1))
            rarity = int(params.group(2))
            if rarity in rarities_data:
                rarities_data[rarity].append(biome)
            else:
                rarities_data[rarity] = [biome]

    return rarities_data

def get_biomes(rarities_data):
    biomes = []
    for rarity_biomes in rarities_data.values():
        biomes = biomes + rarity_biomes

    return biomes

def strip_biome(biome):
    biome = re.sub("\n$", '', biome)
    biome = re.sub("^\s+", '', biome)
    biome = re.sub("\s+$", '', biome)

    return biome

def get_biomes_types():
    config_filename = os.path.join(get_plugin_dir(), "worlds/world/WorldConfig.ini")
    biomes_types = {}
    for biomeType in ['IsleBiomes', 'BorderBiomes']:
        string = run("grep '" + biomeType + ":' " + config_filename)
        string = re.sub('^' + re.escape(biomeType) + '\:\s*', '', string)
        biomes = string.split(",")
        for biome in biomes:
            biome = strip_biome(biome)

            assert not biome in biomes_types, \
                "Biome '%s' of '%s' is duplicated in '%s'" \
                % (biome, biomeType, biomes_types[biome])

            biomes_types[biome] = biomeType

    return biomes_types

def check_biomes_types(biomes):
    biomes_types = get_biomes_types()
    error = False
    for biome in biomes:
        for existing_biome, biome_type in biomes_types.iteritems():
            regexp1 = '^' + re.escape(existing_biome) + ".+$"
            regexp2 = '^.+' + re.escape(existing_biome) + "$"
            if (re.match(regexp1, biome) or re.match(regexp2, biome)) \
                and existing_biome != biome \
                and not biome in biomes_types:
                print "ERROR: '%s' is present in '%s' but '%s' isn't" \
                    % (existing_biome, biome_type, biome)
                error = True

    for existing_biome, biome_type in biomes_types.iteritems():
        if not existing_biome in biomes:
            print "ERROR: '%s' in '%s' isn't a real biome" \
                % (existing_biome, biome_type)
            error = True

    return not error

def get_groups_biomes():
    config_filename = os.path.join(get_plugin_dir(), "worlds/world/WorldConfig.ini")
    groups_biomes = {}

    strings = run("grep '^BiomeGroup(' " + config_filename)
    strings = strings.split("\n")
    for string in strings:
        if len(string) < 1:
            continue

        string = re.sub('^BiomeGroup\(\s*', '', string)
        string = re.sub('\)$', '', string)
        biomes = string.split(",")

        group = strip_biome(biomes[0])
        groups_biomes[group] = []

        for biome in biomes[3:]:
            biome = strip_biome(biome)

            groups_biomes[group].append(biome)

    return groups_biomes

def check_groups_biomes(biomes):
    groups_biomes = get_groups_biomes()

    error = False
    for biome in biomes:
        for group, group_biomes in groups_biomes.iteritems():
            for group_biome in group_biomes:
                regexp1 = '^' + re.escape(group_biome) + ".+$"
                regexp2 = '^.+' + re.escape(group_biome) + "$"
                if (re.match(regexp1, biome) or re.match(regexp2, biome)) \
                    and group_biome != biome \
                    and not biome in group_biomes:
                    print "ERROR: '%s' is present in '%s' but '%s' isn't" \
                        % (group_biome, group, biome)
                    error = True

    for group, group_biomes in groups_biomes.iteritems():
        for group_biome in group_biomes:
            if not group_biome in biomes:
                print "ERROR: '%s' in '%s' isn't a real biome" \
                    % (group_biome, group)
                error = True

    return not error

def check_biomes_present(biomes):
    biomes_types = get_biomes_types()
    groups_biomes = get_groups_biomes()

    groups_biomes_list = []
    for group, group_biomes in groups_biomes.iteritems():
        groups_biomes_list = groups_biomes_list + group_biomes
    
    error = False

    system_biomes = ['FrozenOcean', 'Sky', 'Hell', 'Ocean', 'FrozenRiver', 'River']
    for biome in biomes:
        if not biome in groups_biomes_list \
            and not biome in biomes_types \
            and not biome in system_biomes:
            print "ERROR: '%s' isn't resented in any biome group" \
                % (biome)
            error = True

    return not error

def differs(value1, value2):
    diff = float(value1) / float(value2)
    return (diff < 0.9) or (diff > 1.1)

def check_rarities(rarities_data):
    data_filename = os.path.join(get_data_dir(), "rarities.txt")
    with open(data_filename, 'r') as filehandle:
        saved_rarities = yaml.load(filehandle.read())

    error = False
    for rarity, rarity_biomes in rarities_data.iteritems():
        for biome in rarity_biomes:
            if not biome in saved_rarities:
                print "WARNING: rarity of '%s' wasn't saved" % biome
                continue

            saved_rarity = saved_rarities[biome]
            if not type(saved_rarities[biome]) is int:
                saved_rarity = re.sub('\s+\*$', '', saved_rarity)
                saved_rarity = int(saved_rarity)

            if differs(saved_rarity, rarity):
                print "ERROR: rarity of '%s' is %d. It differs from saved %d" \
                    % (biome, rarity, saved_rarity)
                error = True

    return not error

def main():
    rarities_data = get_rarities_data()
    biomes = get_biomes(rarities_data)

    if not check_biomes_types(biomes) \
        or not check_groups_biomes(biomes) \
        or not check_biomes_present(biomes) \
        or not check_rarities(rarities_data): \
        exit(2)

    rarities = list(reversed(sorted(rarities_data.keys())))
    total_rarity = 0
    for rarity in rarities:
        for biome in rarities_data[rarity]:
            total_rarity += rarity

    for rarity in rarities:
        for biome in sorted(rarities_data[rarity]):
            print "%s: %d (%.1f%%)" % (biome, rarity, 100.0 * rarity / total_rarity)

if __name__ == "__main__":
    main()
