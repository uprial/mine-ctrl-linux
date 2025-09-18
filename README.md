# Overview

This repo assists to run a modern Minecraft server.

# Pre-requisites

* MacOS, Ubuntu or CentOS as a server OS

# Setup

### Copy you SSH key

from:

    ssh-keygen -t rsa -b 2048
    cat ~/.ssh/id_rsa.pub

to: [GitHub - SSH keys](https://github.com/settings/ssh)

### Prepare file structure

    mkdir -p ~/mine
    cd ~/mine

### Clone this repo

    git clone git@github.com:uprial/mine-ctrl-linux.git ctrl-linux

### Pick server version

Check [Java Edition version history](https://minecraft.fandom.com/wiki/Java_Edition_version_history)

### Install Java on MacOS

    brew install openjdk

Check the output of the command above of how to finish the installation.

### Check the server configuration

    cp ctrl-linux/config.local.sh.sample ctrl-linux/config.local.sh
    vim ctrl-linux/config.local.sh

### Build a new server

Check [Paper releases](https://papermc.io/downloads).

If Paper doesn't have the server version you picked, check [simple instructions to build CraftBukkit and Spigot](https://www.spigotmc.org/wiki/buildtools/) and try this:

    ./ctrl-linux/build-server.sh

### Configure EULA

#### Start the server 1st time

    ./ctrl-linux/start-server.sh
    stop
    ./ctrl-linux/clean-worlds.sh

You'll get an error message about EULA. Fix it:

    sed -i '' 's/=false/=true/' eula.txt

### Check the client works

#### Start the server 2nd time

Download a client launcher: [CLIENT.md](CLIENT.md), install the same version as the server and check that the client works with the server.

### Install plugins

Download the latest versions of plugins listed in [CLIENT.md](CLIENT.md).

For each plugin hosted outside of www.spigotmc.org, please check its existence on www.spigotmc.org.

### Configure the basic params

Change LuckPerms storage-method in plugins/LuckPerms/config.yml:

    storage-method: YAML

Enable TerraformGenerator in bukkit.yml:

    worlds:
      world:
        generator: TerraformGenerator

#### Start the server 3rd time

Make your backup:

    cp -r . ../m-clean
    tar -zcf ../m-clean.tar.gz *

#### Configure all the params

Check previous configration differences in ./ctrl-linux/expected-diffs and the current differences generated in ./diffs via `./ctrl-linux/make-diff.sh`. Configure the game until the difference in differences is negotiated.

Configure MaxMind License Key in plugins/AuthMe/config.yml:Protection.geoIpDatabase

#### Start the server 4rd time

### Test Plugins

AuthMe
* Register and login on the server

AutoMinecart
* Put a rail into a chest minecart, push it

Bluemap
* Open HTTP://\<server.properties:server-ip>:\<plugins/BlueMap/webserver.conf:port>

CraftBook
* Create a sign with "[Chunk]" on the second line. A message should appear.
* Create a regular piston, on it put a sign with "[Crush]" on the second line. The piston should break blocks.

CustomBazookas
* Make a bazooka from a firework and a nether star
* Load a crossbow in your left hand and the bazooka in your right, and make a shot

CustomCreatures
* Once killed, you should have an apple and two modifiers.
* Change chainmail-zombie.filter.probability to 99.5, `/customcreatures reload`, the zombie should appear.

CustomNukes
* Put a TNT in center and 8 x SAND, forge a Toy bomb, trigger a chain of 8 Toy bombs via Flint & Steel

CustomRecipes
* Put an Egg in center and 8 x GUNPOWDER, forge a Creeper spawn egg.

CustomVillage
* Find the closest village via https://www.chunkbase.com/apps/village-finder or TerraformGenerator `/terra locate`, `/customvillage info`

GlobalGamerules
* Check gamerule minecartMaxSpeed

LuckPerms
TBD

MasochisticSurvival
* Spawn a shooting mob, it should immediately target the player
* Break a healing crystal, kick the Ender Dragon, the healing crystal should be resurrected

Secret Rooms
* Check an End Ship has an illusioner
* With debug enabled, check that logs report Whirlpool and Dungeon generation

TakeAim
* Summon a Skeleton and a Ghast, take a long distance from them, they should aim at you when you're simultaneously moving and jumping

Vault
TBD

WorldBorder
* Reach the world border

WorldEdit
* Take a wooden axe, pick start via left-click, pick end via right-click, `//set sand`

WorldGuard
* Take a wooden axe, pick start via left-click, pick end via right-click, `/rg claim test`

### Setup server

Add your host public key to `~/.ssh/authorized_keys`.

    tar -zcf mine-0.tar.gz *
    scp mine-0.tar.gz root@remote-host:~/

    ssh root@remote-host -t "screen -RD mine"
    mkdir -p mine
    cd mine
    mv ../mine-0.tar.gz ./
    tar -xf mine-0.tar.gz
    find . -name '._*' -exec rm {} \;

Check server.properties:server-ip

Check plugins/BlueMap/webserver.conf:port

    ./ctrl-linux/start-server-continuous.sh
    Ctrl+a, d

### Install mcrcon

    cd ./ctrl-linux
    git clone https://github.com/Tiiffi/mcrcon
    cd mcrcon/
    vim README.md
    make
    sudo make install

### Setup backups

    cp ./ctrl-linux/data/m-cron /etc/cron.d/

Check backups work. :-)

### Render the map

    /bluemap update world

# See also

* [Client installation](CLIENT.md)
