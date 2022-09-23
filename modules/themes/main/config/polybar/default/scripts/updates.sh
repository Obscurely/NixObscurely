#!/usr/bin/env bash

get_total_updates() { UPDATES=$(checkupdates 2>/dev/null | wc -l); }

while true; do
    get_total_updates

    # when there are updates available
    # every half an hour another check for updates is done
    while (( UPDATES > 0 )); do
        if (( UPDATES == 1 )); then
            echo " $UPDATES"
        elif (( UPDATES > 1 )); then
            echo " $UPDATES"
        else
            echo " None"
        fi
        sleep 1800
        get_total_updates
    done

    # when no updates are available, use a longer loop, this saves on CPU
    # and network uptime, only checking once every hour for new updates
    while (( UPDATES == 0 )); do
        echo " None"
        sleep 3600
        get_total_updates
    done
done
