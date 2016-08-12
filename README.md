## New installation
* `./ctrl-linux/distclean.sh`
* Update all the plugins
* `tar -zcf m-empty.tar.gz *`
* `./ctrl-linux/start-server.sh`
* `sed -i '' 's/=false/=true/' eula.txt`
* `./ctrl-linux/start-server.sh`
* `echo -e "worlds:\n  world:\n    generator: TerrainControl" >> bukkit.yml`
* `rm -rf world world_nether world_the_end world_herobrine_graveyard/`
* `./ctrl-linux/start-server.sh`
* Configure

## Cron
`0 2,14 * * * /root/m/ctrl-linux/backup.sh >> /tmp/cron.log 2>&1`
