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

Download a client launcher: https://ru-m.org/, install the same version as the server and check that the client works with the server. Then stop the server via /stop and clean the mess up:

### Install plugins

Download the latest versions of plugins: 

* [AuthMeReloaded](https://ci.codemc.org/job/AuthMe/job/AuthMeReloaded/)
* [Bluemap](https://www.spigotmc.org/resources/bluemap.83557/)
* [CraftBook](https://dev.bukkit.org/projects/craftbook)
* [CustomCreatures](https://www.spigotmc.org/resources/customcreatures.68711/)
* [CustomNukes](https://www.spigotmc.org/resources/customnukes.68710/)
* [CustomRecipes](https://www.spigotmc.org/resources/customrecipes.89435/)
* [CustomVillage](https://www.spigotmc.org/resources/customvillage.69170/)
* [GlobalGamerules](https://www.spigotmc.org/resources/global-gamerules-1-7-1-16.82310/)
* [LuckPerms](https://www.spigotmc.org/resources/luckperms.28140/)
* [Rails & Chests & Bazookas](https://www.spigotmc.org/resources/rails-chests-bazookas.121505/)
* [TakeAim](https://www.spigotmc.org/resources/takeaim.68713/)
* [TerraformGenerator](https://www.spigotmc.org/resources/terraformgenerator-1-16-5-1-20-1.75132/)
* [Vault](https://www.spigotmc.org/resources/vault.34315/)
* [WorldBorder](https://www.spigotmc.org/resources/worldborder.60905/)
* [WorldEdit](https://dev.bukkit.org/projects/worldedit)
* [WorldGuard](https://dev.bukkit.org/projects/worldguard)

For each plugin hosted outside of www.spigotmc.org, please check its existence on www.spigotmc.org.

In case any updates in links, please update this document and also the [CLIENT.md](CLIENT.md) document.

### Configure the basic params

Change LuckPerms storage-method in plugins/LuckPerms/config.yml:

    storage-method: YAML

Enable TerraformGenerator, **experimental** in bukkit.yml:

    worlds:
      world:
        generator: TerraformGenerator

#### Start the server 3rd time

Make your backup:

    cp -r . ../m-clean
    tar -zcf ../m-clean.tar.gz *

#### Configure all the params

Check previous configration differences in ./ctrl-linux/expected-diffs and the current differences generated in ./diffs via `./ctrl-linux/make-diff.sh`. Configure the game until the difference in differences is negotiated.

#### Start the server 4rd time

### Test Plugins

AuthMe
* Register on the server

Bluemap
* Open HTTP://\<server.properties:server-ip>:\<plugins/BlueMap/webserver.conf:port>

Commands
* /morning should work
* /ench_i @p should work

CraftBook
* Create a sign with "[Chunk]" on the second line. A message should appear.
* Create a regular piston, on it put a sign with "[Crush]" on the second line. The piston should break blocks.

CustomCreatures
* Once killed, you should have an apple and two modifiers.
* Change chainmail-zombie.filter.probability to 99.5, /customcreatures reload, the zombie should appear.

CustomNukes
* Put a TNT in center and 8 x SAND, forge a Toy bomb, trigger a chain of 8 Toy bombs via Flint & Steel

CustomRecipes
* Put an Egg in center and 8 x GUNPOWDER, forge a Creeper spawn egg.

CustomVillage
* Find the closest village via https://www.chunkbase.com/apps/village-finder, run /customvillage info

GlobalGamerules
* Check gamerule minecartMaxSpeed

TakeAim
* Summon a Skeleton and a Ghast, take a long distance from them, they should aim at you when you're simultaneously moving and jumping

WorldBorder
* Reach the world border

WorldEdit
* Take a wooden axe, pick start via left-click, pick end via right-click, //set sand

WorldGuard
* Take a wooden axe, pick start via left-click, pick end via right-click, /rg claim test

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
