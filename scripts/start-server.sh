#!/bin/bash
LAT_V="$(wget -qO- https://api.github.com/repos/owncast/owncast/releases | jq -r '.[0].tag_name' | cut -d 'v' -f2)"
CUR_V="$(ls -l ${DATA_DIR}/owncastv-* 2>/dev/null | awk '{print $9}' | cut -d '-' -f2-)"

if [ -z $LAT_V ]; then
    if [ -z $CUR_V ]; then
        echo "---Can't get latest version of Owncast, putting container into sleep mode!---"
        sleep infinity
    else
        echo "---Can't get latest version of Owncast, falling back to v$CUR_V---"
        LAT_V=$CUR_V
    fi
fi

if [ "$OWNCAST_V" == "latest" ]; then
    OWNCAST_V="${LAT_V}"
fi

if [ -f ${DATA_DIR}/owncast-v$OWNCAST_V.zip ]; then
	rm -rf ${DATA_DIR}/owncast-v$OWNCAST_V.zip
fi

echo "---Version Check---"
if [ -z "$CUR_V" ]; then
    echo "---Owncast not found, downloading and installing v$OWNCAST_V...---"
    DL_URL="$(wget -qO- https://api.github.com/repos/owncast/owncast/releases/tags/v${OWNCAST_V} | jq -r '.assets' | grep "browser_download_url" | grep "linux-64bit" | cut -d '"' -f4)"
    if [ -z "$DL_URL" ]; then
        echo "---Something went wrong, can't get download URL of Owncast, putting container into sleep mode!---"
        sleep infinity
    fi
    cd ${DATA_DIR}
    if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/owncast-v$OWNCAST_V.zip "$DL_URL" ; then
        echo "---Successfully downloaded Owncast v$OWNCAST_V---"
    else
        echo "---Something went wrong, can't download Owncast v$OWNCAST_V, putting container into sleep mode!---"
        sleep infinity
    fi
    mkdir -p ${DATA_DIR}/Owncast
    unzip -o ${DATA_DIR}/owncast-v${OWNCAST_V}.zip -d ${DATA_DIR}/Owncast
	touch ${DATA_DIR}/owncastv-$OWNCAST_V
    rm ${DATA_DIR}/owncast-v${OWNCAST_V}.zip
elif [ "$CUR_V" != "$OWNCAST_V" ]; then
    echo "---Version missmatch, installed v$CUR_V, downloading and installing v$OWNCAST_V...---"
    DL_URL="$(wget -qO- https://api.github.com/repos/owncast/owncast/releases/tags/v${OWNCAST_V} | jq -r '.assets' | grep "browser_download_url" | grep "linux-64bit" | cut -d '"' -f4)"
    if [ -z "$DL_URL" ]; then
        echo "---Something went wrong, can't get download URL of Owncast, putting container into sleep mode!---"
        sleep infinity
    fi
    cd ${DATA_DIR}
    if [ "$(ls -ld ${DATA_DIR}/Backup-* 2>/dev/null)" ]; then
        rm -rf "$(ls -ld ${DATA_DIR}/Backup-* 2>/dev/null | awk '{print $9}')"
    fi
    mv ${DATA_DIR}/Owncast ${DATA_DIR}/Backup-v$CUR_V
    rm -rf ${DATA_DIR}/owncastv-*
    if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/owncast-v$OWNCAST_V.zip "$DL_URL" ; then
        echo "---Successfully downloaded Owncast v$OWNCAST_V---"
    else
        echo "---Something went wrong, can't download Owncast v$OWNCAST_V, putting container into sleep mode!---"
        sleep infinity
    fi
    mkdir -p ${DATA_DIR}/Owncast
    unzip -o ${DATA_DIR}/owncast-v${OWNCAST_V}.zip -d ${DATA_DIR}/Owncast
	touch ${DATA_DIR}/owncastv-$OWNCAST_V
    rm ${DATA_DIR}/owncast-v${OWNCAST_V}.zip
elif [ "$CUR_V" == "$OWNCAST_V" ]; then
    echo "---Owncast v$OWNCAST_V up-to-date---"
fi

echo "---Preparing Server---"
if [ ! -d ${DATA_DIR}/data ]; then
    cp -r ${DATA_DIR}/Owncast/data ${DATA_DIR}/
fi
chmod -R ${DATA_PERM} ${DATA_DIR}

echo "---Starting Server---"
cd ${DATA_DIR}/Owncast
${DATA_DIR}/Owncast/owncast -database ${DATA_DIR}/data/owncast.db ${START_PARAMS}