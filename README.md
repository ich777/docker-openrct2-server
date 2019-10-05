# OpenRCT2 Dedicated Server in Docker optimized for Unraid

This Docker will download and install the preferred version of OpenRCT2.

*** Manual Installation: You can also drop a custom version (even a develop version) into the root of the server and restart the Docker, it will automaticaly install it (don' forget to set the variable 'GAME_VERSION' to that version that you are installing - installing a develop version is also possible but you must download and place the file manually be sure that it is in this format: 'v0.2.3-develop-e4a2b1f9c' if the source file is named like this: 'OpenRCT2-0.2.3-develop-e4a2b1f9c-linux-x86_64.tar', start the container and wait for it to create the directory's and place the downloaded fily manually into it, eventually restart the docker).
Update Notice: If you want to update or downgrade the game simply change the version number.

## Env params

| Name | Value | Example |
| --- | --- | --- |
| SERVER_DIR | Folder for gamefiles | /serverdata/serverfiles |
| GAME_CONFIG | Commandline startup parameters | --password Docker |
| GAME_VERSION | Preferred game version | 0.2.2 |
| GAME_SAVE_NAME | Savegame to laod | docker.sv6 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| GAME_PORT | Port the server will be running on | 11753 |


## Run example

```
docker run --name OpenRCT2 -d \
    -p 11753:11753/tcp \
    --env 'GAME_CONFIG=--password Docker' \
    --env 'GAME_VERSION=0.2.2' \
    --env 'GAME_SAVE_NAME=docker.sv6' \
    --env 'UID=99' \
    --env 'GID=100' \
    --volume /mnt/user/appdata/openrct2:/serverdata/serverfiles \
    --restart=unless-stopped \
    ich777/openrct2server:latest
```

This Docker was mainly created for the use with Unraid, if you don’t use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/