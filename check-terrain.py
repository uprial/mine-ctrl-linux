#! /usr/bin/env python

import os
import re

BIOME_NAME_PATTERN = "[\\w\\s\\(\\)\\+]+"
BIOME_LIST_PATTERN = "(?:" + BIOME_NAME_PATTERN + ",?)+"

class Path(object):

    @classmethod
    def get_plugin_path(cls, path):
        working_dir = os.path.dirname(cls._get_data_dir())
        return os.path.join(working_dir, "plugins/TerrainControl/worlds/world", path)

    @staticmethod
    def _get_data_dir():
        return os.path.dirname(os.path.realpath(__file__))

class ConfigFile(object):
    _content = None

    def __init__(self, filename):
        filename = Path.get_plugin_path(filename)
        with open(filename, "r") as filehandle:
            self._content = filehandle.read()

    def get_biomes(self, key):
        value = self._get("^\\s*" + re.escape(key) + ":\\s*(" + BIOME_LIST_PATTERN + ")$")

        if value is not None:
            biomes = self._parse_biomes(value)
        else:
            biomes = []

        return biomes

    def get_int(self, key):
        value = self._get("^\\s*" + re.escape(key) + ":\\s*(\\d+)$")

        if value is not None:
            value = int(value)
        else:
            value = 0

        return value

    def _get(self, pattern):
        match = re.search(pattern, self._content, re.MULTILINE)
        if match is not None:
            value = match.group(1)
        else:
            value = None

        return value

    @staticmethod
    def _strip_biome(biome):
        biome = re.sub("\n$", '', biome)
        biome = re.sub("^\\s+", '', biome)
        biome = re.sub("\\s+$", '', biome)

        return biome

    @classmethod
    def _parse_biomes(cls, string):
        biomes = string.split(",")
        biomes = [cls._strip_biome(biome) for biome in biomes]
        if len(biomes) == 1 and biomes[0] == "":
            biomes = []

        return biomes


class Group(object):

    def __init__(self, name, size, rarity, biome_names):
        self.name = name
        self.size = size
        self.rarity = rarity
        self.biome_names = biome_names

    def __repr__(self):
        return str({"name": self.name, "size": self.size, "rarity": self.rarity, "biome_names": self.biome_names})

class WorldConfig(ConfigFile):

    def __init__(self):
        super(WorldConfig, self).__init__("WorldConfig.ini")

        self.isle_biomes = self.get_biomes("IsleBiomes")
        self.border_biomes = self.get_biomes("BorderBiomes")
        self.groups = self._get_groups()

    def _get_groups(self):
        groups = []
        for line in self._content.split("\n"):
            match = re.match("^\\s*BiomeGroup\\((" + BIOME_NAME_PATTERN + "),\\s*(\\d+)\\s*,\\s*(\\d+)\\s*,(" + BIOME_LIST_PATTERN + ")\\)$", line)
            if match:
                name = match.group(1)
                size = int(match.group(2))
                rarity = int(match.group(3))
                biome_names = self._parse_biomes(match.group(4))

                groups.append(Group(name, size, rarity, biome_names))

        return groups

class BiomeConfig(ConfigFile):

    def __init__(self, biome):
        assert re.match("^" + BIOME_NAME_PATTERN + "$", biome), \
            "Wrong biome name: '%s'" % (biome)
        super(BiomeConfig, self).__init__("WorldBiomes/%s.bc" % (biome))

        self.name = biome
        self.rarity = self.get_int("BiomeRarity")
        self.isle_in = self.get_biomes("IsleInBiome")
        self.is_border = self.get_biomes("BiomeIsBorder")

    def __repr__(self):
        return str({"name": self.name, "rarity": self.rarity, "isle_in": self.isle_in, "is_border": self.is_border})

class Biomes(object):

    def __init__(self):
        self._biomes = {}
        biome_names = self._get_biome_names()
        for biome_name in biome_names:
            self._biomes[biome_name] = BiomeConfig(biome_name)

    def values(self):
        return self._biomes.values()

    def keys(self):
        return self._biomes.keys()

    def get(self, key):
        return self._biomes[key]

    @staticmethod
    def _get_biome_names():
        path = Path.get_plugin_path("WorldBiomes")
        biome_names = []
        for (_, _, filenames) in os.walk(path):
            for filename in filenames:
                if filename.endswith(".bc"):
                    biome_names.append(filename[0:len(filename)-3])

        return biome_names

def check_isle_and_border_biomes(world_config, biomes):
    used_isle_biomes = []
    used_border_biomes = []
    for biome in biomes.values():
        if len(biome.isle_in) > 0:
            assert biome.name in world_config.isle_biomes, \
                "Biome '%s' is isle in '%s' but isn't listed in world config" \
                % (biome.name, "', '".join(biome.isle_in))
            used_isle_biomes.append(biome.name)
        if len(biome.is_border) > 0:
            assert biome.name in world_config.border_biomes, \
                "Biome '%s' is border of '%s' but isn't listed in world config" \
                % (biome.name, "', '".join(biome.is_border))
            used_border_biomes.append(biome.name)

    alone_isle_biomes = list(set(world_config.isle_biomes) - set(used_isle_biomes))
    assert len(alone_isle_biomes) <= 0, \
        "Following isle biomes are listed in world config but aren't used: '%s'" \
        % ("', '".join(alone_isle_biomes))

    alone_border_biomes = list(set(world_config.border_biomes) - set(used_border_biomes))
    assert len(alone_border_biomes) <= 0, \
        "Following border biomes are listed in world config but aren't used: '%s'" \
        % ("', '".join(alone_border_biomes))

def check_groups(world_config, biomes):
    biomes_map = {}
    for group in world_config.groups:
        for biome_name in group.biome_names:
            assert biome_name not in biomes_map, \
                "Biome '%s' is presented in more than one group: '%s'" \
                % (biome_name, "', '".join([biomes_map[biome_name], group.name]))

            biomes_map[biome_name] = group.name

    system_biomes = ['FrozenOcean', 'Sky', 'Hell', 'Ocean', 'FrozenRiver', 'River']
    alone_biomes = list(set(biomes.keys()) - set(biomes_map.keys()) - set(world_config.border_biomes) - set(world_config.isle_biomes) - set(system_biomes))

    assert len(alone_biomes) <= 0, \
        "Following biomes aren't listed in any groups: '%s'" \
        % ("', '".join(alone_biomes))


def show_rarities(world_config, biomes):

    total_groups_rarity = 0
    total_group_biomes_rarity = {}
    for group in world_config.groups:
        total_groups_rarity += group.rarity
        total_group_biomes_rarity[group.name] = 0
        for biome_name in group.biome_names:
            biome = biomes.get(biome_name)
            total_group_biomes_rarity[group.name] += biome.rarity

    print "==== GROUPS ===="
    sorted_groups = sorted(world_config.groups, key=lambda x: x.rarity, reverse=True)
    for group in sorted_groups:
        print "%s: %d (%.1f%%)" % (group.name, group.rarity, 100.0 * group.rarity / total_groups_rarity)
    for group in sorted_groups:
        print "==== GROUP: %s ====" % (group.name)
        biomes_list = []
        for biome_name in group.biome_names:
            biomes_list.append(biomes.get(biome_name))

        sorted_biomes = sorted(biomes_list, key=lambda x: x.rarity, reverse=True)
        for biome in sorted_biomes:
            print "%s: %d (%.1f%%)" % (biome.name, biome.rarity, 100.0 * biome.rarity / total_group_biomes_rarity[group.name])

def main():
    world_config = WorldConfig()
    biomes = Biomes()

    check_isle_and_border_biomes(world_config, biomes)
    check_groups(world_config, biomes)
    show_rarities(world_config, biomes)

if __name__ == "__main__":
    main()
