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

### Check the server configuration

    cp ctrl-linux/config.local.sh.sample ctrl-linux/config.local.sh
    vim ctrl-linux/config.local.sh

### Build a new server

Check [simple instructions to build CraftBukkit and Spigot](https://www.spigotmc.org/wiki/buildtools/) and try this:

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

* [AuthMeReloaded](https://ci.codemc.org/job/AuthMe/job/AuthMeReloaded/) - dev build
* [CraftBook](https://www.spigotmc.org/resources/craftbook.2083/)
* [CustomCreatures](https://dev.bukkit.org/projects/customcreatures)
* [CustomDamage](https://dev.bukkit.org/projects/customdamage)
* [CustomNukes](https://dev.bukkit.org/projects/customnukes)
* [Dynmap, **1.13 only**](https://www.spigotmc.org/resources/dynmap.274/)
* [Dynmap-Mobs, **1.13 only**](https://dev.bukkit.org/projects/dynmap-mobs)
* [Dynmap-WorldGuard, **1.12 only**](https://dev.bukkit.org/projects/dynmap-worldguard)
* [HealthBar](https://www.spigotmc.org/resources/healthbar.57695/)
* [Herobrine, **1.12 only**](https://www.spigotmc.org/resources/herobrine.50393/)
* [PermissionsEx](https://dev.bukkit.org/projects/permissionsex)
* [TerrainControl, **1.12 only**](http://tardisjenkins.duckdns.org:8080/job/TerrainControl/)
* [Vault](https://www.spigotmc.org/resources/vault.34315/)
* [WorldBorder](https://www.spigotmc.org/resources/worldborder.60905/)
* [WorldEdit](https://dev.bukkit.org/projects/worldedit) - beta
* [WorldGuard](https://dev.bukkit.org/projects/worldguard)

In case any updates in links or versions, please update this document and also the [CLIENT.md](CLIENT.md) document with the versions you've chosen.

Enable the TerrainControl if needed:

    echo -e "worlds:\n  world:\n    generator: TerrainControl" >> bukkit.yml

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

# See also

* [Client installation](CLIENT.md)
