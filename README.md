# Owncast in Docker optimized for Unraid
Owncast is a self-hosted live video and web chat server for use with existing popular broadcasting software.

Update Notice: Simply restart the container if a newer version of the game is available.


AMD Hardware transcoding (Please note that you have to be on Unraid 6.9.0beta35 to enable the moduel for AMD):

    Open up a Terminal from Unraid and type in: 'modprobe amdgpu' (without quotes or you edit your 'go' file to load it on every restart of Unraid - refer to the support thread)
    At 'Device' at the bottom here in the template add '/dev/dri'
    In Owncast open the admin page and go to 'Configuration' -> 'Video Configuration' -> 'Advanced Settins', select 'VA-API hardware encoding' from the dropdown and click 'Yes'

Intel Hardware transcoding:

    Download and install the Intel-GPU-TOP Plugin from the CA App
    At 'Device' at the bottom here in the template add '/dev/dri'
    In Owncast open the admin page and go to 'Configuration' -> 'Video Configuration' -> 'Advanced Settins', select 'VA-API hardware encoding' from the dropdown and click 'Yes'

Nvidia Hardware transcoding:

    Download and install the Nvidia-Driver Plugin from the CA App
    Turn on the 'Advanced View' here in the template and at 'Extra Parameters' add: '--runtime=nvidia'.
    At 'Nvidia Visible Devices' at the bottom here in the template add your GPU UUID.
    In Owncast open the admin page and go to 'Configuration' -> 'Video Configuration' -> 'Advanced Settins', select 'NVIDIA GPU acceleration' from the dropdown and click 'Yes'


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
	ich777/owncast
```

This Docker is mainly created for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/83786-support-ich777-application-dockers/