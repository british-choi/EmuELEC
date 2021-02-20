#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

ASSETS="https://github.com/supertuxkart/stk-assets-mobile/releases/download/git20210208/stk-assets.zip"
DATA="https://github.com/EmuELEC/stk-code/archive/data_only.zip"
DATAFOLDER="/storage/roms/ports/supertuxkart"

mkdir -p "${DATAFOLDER}"
cd "${DATAFOLDER}"

if [ ! -e "${DATAFOLDER}/data" ]; then
    text_viewer -y -f 24 -t "Data does not exists!" -m "It seems this is the first time you are launching Super Tux Kart or the data folder does not exists\n\nData is about 250 MB total, and you need to be connected to the internet\n\nDownload and continue?"
        if [[ $? == 21 ]]; then
            ee_console enable
            wget "${DATA}" -q --show-progress > /dev/tty0 2>&1
            unzip "data_only.zip" > /dev/tty0
            mv "stk-code-data_only/data" "${DATAFOLDER}" > /dev/tty0
            rm -rf "stk-code-data_only"
            wget "${ASSETS}" -q --show-progress > /dev/tty0 2>&1
            unzip "stk-assets.zip" -d data > /dev/tty0
            rm "stk-assets.zip"
            rm "data_only.zip"
            ee_console disable
            mkdir -p /storage/.config/supertuxkart/config-0.10

cat > /storage/.config/supertuxkart/config-0.10/players.xml << EOF
<?xml version="1.0"?>
<players version="1" >
    <player name="EmuELEC" guest="false" use-frequency="0"
            icon-filename="1.png"
            unique-id="1" saved-session="false"
            saved-user="0" saved-token=""
            last-online-name="" last-was-online="false"
            remember-password="false"
            default-kart-color="0">
    </player>
</players>            
EOF
            SUPERTUXKART_DATADIR="${DATAFOLDER}" supertuxkart
        else
            exit 0
        fi
else
    SUPERTUXKART_DATADIR="${DATAFOLDER}" supertuxkart
fi

