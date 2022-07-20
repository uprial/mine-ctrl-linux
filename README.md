# Overview

This repo assists to run a modern Minecraft server.

# Pre-requisites

* MacOS, Ubuntu or CentOS as a server OS

# Setup

### Copy you SSH key

from:

    # ssh-keygen -t rsa -b 2048
    cat ~/.ssh/id_rsa.pub

to: [GitHub - SSH keys](https://github.com/settings/ssh)

### Prepare file structure

    mkdir -p ~/mine
    cd ~/mine

### Clone this repo

    git clone git@github.com:uprial/mine-ctrl-linux.git ctrl-linux

### Pick server version

Check [Java Edition version history](https://minecraft.fandom.com/wiki/Java_Edition_version_history)

### Install Java

    brew install openjdk

Check the output of the command above of how to finish the installation.

### Check the server configuration

    cp ctrl-linux/config.local.sh.sample ctrl-linux/config.local.sh
    vim ctrl-linux/config.local.sh

### Build a new server

Check [Paper releases](https://papermc.io/downloads).

If Paper doesn't have the server version you picked, check [simple instructions to build CraftBukkit and Spigot](https://www.spigotmc.org/wiki/buildtools/) and try this:

    ./ctrl-linux/build-server.sh

### Try to start the server 1st time

    ./ctrl-linux/start-server.sh

You'll get an error message about EULA. Fix it:

    sed -i '' 's/=false/=true/' eula.txt

### Start the server 2nd time

    ./ctrl-linux/start-server.sh

Download a client launcher: https://ru-m.org/, install the same version as the server and check that the client works with the server. Then stop the server via Ctrl+C and clean the mess up:

    ./ctrl-linux/clean-worlds.sh

Make you first backup:

    cp -r . ../m-empty
    tar -zcf ../m-empty.tar.gz *

### Install plugins

For each plugin that refers to sites outside of www.spigotmc.org, please check its existence on www.spigotmc.org and prefer the latter if it exists.

Also, please check for newest versions of links via search.

* [AuthMeReloaded](https://ci.codemc.org/job/AuthMe/job/AuthMeReloaded/)
* [CraftBook](https://www.spigotmc.org/resources/craftbook.2083/)
* [CustomCreatures](https://www.spigotmc.org/resources/customcreatures.68711/)
* [CustomNukes](https://www.spigotmc.org/resources/customnukes.68710/)
* [CustomRecipes](https://www.spigotmc.org/resources/customrecipes.89435/)
* [CustomVillage](https://www.spigotmc.org/resources/customvillage.69170/)
* [Dynmap](https://www.spigotmc.org/resources/dynmap.274/)
* [LuckPerms](https://www.spigotmc.org/resources/luckperms.28140/)
* [TakeAim](https://www.spigotmc.org/resources/takeaim.68713/)
* [Vault](https://www.spigotmc.org/resources/vault.34315/)
* [WorldBorder](https://www.spigotmc.org/resources/worldborder.60905/)
* [WorldEdit](https://dev.bukkit.org/projects/worldedit)
* [WorldGuard](https://dev.bukkit.org/projects/worldguard)

Abandoned plugins worth to check for updates:
* [CustomDamage, **1.16 only**](https://www.spigotmc.org/resources/customdamage.68712/)
* [Dynmap-Mobs, **1.9 only**](https://dev.bukkit.org/projects/dynmap-mobs)
* [Dynmap-WorldGuard, **1.14 only**](https://dev.bukkit.org/projects/dynmap-worldguard)
* [HealthBar, **BROKEN in 1.16**](https://www.spigotmc.org/resources/healthbars-1-12-2-1-16-4-mob-or-player-healthbar-customizable-toggleable.84895/)
* [Herobrine, **1.12 only**](https://www.spigotmc.org/resources/herobrine.50393/)
* [PermissionsEx, **1.14 only**](https://dev.bukkit.org/projects/permissionsex)
* [TerrainControl, **1.12 only**](http://tardisjenkins.duckdns.org:8080/job/TerrainControl/)

In case any updates in links or versions, please update this document and also the [CLIENT.md](CLIENT.md) document with the versions you've chosen.

Enable the TerrainControl, **1.12 only**

    echo -e "worlds:\n  world:\n    generator: TerrainControl" >> bukkit.yml

Change LuckPerms storage-method in plugins/LuckPerms/config.yml:

    storage-method: YAML

Try the server:

    ./ctrl-linux/start-server.sh
    Ctrl+C
    ./ctrl-linux/clean-worlds.sh

Make you second backup:

    cp -r . ../m-clean
    tar -zcf ../m-clean.tar.gz *

### Configure the game

Check previous configration differences in ./ctrl-linux/expected-diffs and the current differences generated in ./diffs via `./ctrl-linux/make-diff.sh`. Configure the game until the difference in differences is negotiated.

### Setup server

Add your host public key to `~/.ssh/authorized_keys`.

    ssh root@remote-host -t "screen -RD mine"
    ./ctrl-linux/start-server-continuous.sh
	Ctrl+a, d

### Install mcrcon

    git clone https://github.com/Tiiffi/mcrcon
    cd mcrcon/
    vim README.md
    make
    sudo make install

### Setup cron

    cp data/m.cron /etc/cron.d/


### Update client overview

    CLIENT.md

# See also

* [Client installation](CLIENT.md)
