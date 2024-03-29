# OpenRCT2 Dedicated Server in Docker optimized for Unraid

This Docker will download and install the preferred version of OpenRCT2.

*** Manual Installation: You can also drop a custom version (even a develop version) into the root of the server and restart the Docker, it will automaticaly install it (don' forget to set the variable 'GAME_VERSION' to that version that you are installing - installing a develop version is also possible but you must download and place the file manually be sure that it is in this format: 'OpenRCT2-0.4.2-linux-x86_64.AppImage', start the container and wait for it to create the directory's and place the downloaded fily manually into it, finaly restart the container once more).
Update Notice: If you want to update or downgrade the game simply change the version number.

## Env params

| Name | Value | Example |
| --- | --- | --- |
| SERVER_DIR | Folder for gamefiles | /serverdata/serverfiles |
| GAME_CONFIG | Commandline startup parameters | --password Docker |
| GAME_VERSION | Preferred game version, set to 'latest' to check on every start if a new version is available | latest |
| GAME_SAVE_NAME | Savegame to laod | docker.sv6 |
| ADMIN_NAME | The username that should become an admin if he connects | user |
| ADMIN_HASH | TThe hash of the admin user (you find it on the client computer in the 'user-data/keys' folder from OpenRCT2 - if nothing is in there try to connect to any server and the game will create the hash, it's the numbers and letters after the username without '-' and without the ending '.pubkey' or just turn on 'log_server_actions' in the 'config.ini' on the server and you'll find it in the logs) | *hash* |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| GAME_PORT | Port the server will be running on | 11753 |

>**ATTENTION:** The variables ADMIN_NAME & ADMIN_HASH will only work on the first time you enter these, after that you must change it manually in '/SERVER_DIR/user-data/users.json'.


## Run example

```
docker run --name OpenRCT2 -d \
    -p 11753:11753/tcp \
    --env 'GAME_CONFIG=--password Docker' \
    --env 'GAME_VERSION=latest' \
    --env 'GAME_SAVE_NAME=docker.sv6' \
    --env 'UID=99' \
    --env 'GID=100' \
    --volume /mnt/user/appdata/openrct2:/serverdata/serverfiles \
    --restart=unless-stopped \
    ich777/openrct2server:latest
```

This Docker was mainly created for the use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/