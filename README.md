# Owncast in Docker optimized for Unraid
Owncast is a self-hosted live video and web chat server for use with existing popular broadcasting software.

Update Notice: Simply restart the container if a newer version of the game is available.

Also visit the Homepage of the creator and consider Donating: https://owncast.online/

## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Main Data folder | /owncast |
| OWNCAST_V | Preferred Owncast version goes here (set to ‘latest’ to download the latest and check on every startup if there is a newer version available) | latest |
| START_PARAMS | Extra startup Parameters if needed (leave empty if not needed) | |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| UMASK | Umask value | 0000 |
| DATA_PERM | Data permissions for /owncast folder | 770 |

## Run example
```
docker run --name Owncast -d \
	-p 8080:8080/tcp \
	-p 1935:1935/tcp \
	--env 'OWNCAST_V=latest' \
	--env 'UID=99' \
	--env 'GID=100' \
	--env 'UMASK=0000' \
	--env 'DATA_PERM=770' \
	--volume /mnt/cache/appdata/owncast:/owncast \
	ich777/docker-owncast
```

This Docker is mainly created for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/