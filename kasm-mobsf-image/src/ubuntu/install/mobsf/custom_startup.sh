#!/usr/bin/env bash
set -ex
START_COMMAND="chromium"
PGREP="chromium"
export MAXIMIZE="true"
export MAXIMIZE_NAME="Chromium"
MAXIMIZE_SCRIPT=$STARTUPDIR/maximize_window.sh
DEFAULT_ARGS=""
LAUNCH_URL="http://localhost:8000"

if [[ $MAXIMIZE == 'true' ]] ; then
    DEFAULT_ARGS+=" --start-maximized"
fi
ARGS=${APP_ARGS:-$DEFAULT_ARGS}

options=$(getopt -o gau: -l go,assign,url: -n "$0" -- "$@") || exit
eval set -- "$options"

while [[ $1 != -- ]]; do
    case $1 in
        -g|--go) GO='true'; shift 1;;
        -a|--assign) ASSIGN='true'; shift 1;;
        -u|--url) OPT_URL=$2; shift 2;;
        *) echo "bad option: $1" >&2; exit 1;;
    esac
done
shift

# Process non-option arguments.
for arg; do
    echo "arg! $arg"
done

FORCE=$2

check_web_server() {
    curl -s -o /dev/null $LAUNCH_URL && return 0 || return 1
}

kasm_startup() {
    if [ -n "$KASM_URL" ] ; then
        URL=$KASM_URL
    elif [ -z "$URL" ] ; then
        URL=$LAUNCH_URL
    fi

    if [ -z "$DISABLE_CUSTOM_STARTUP" ] ||  [ -n "$FORCE" ] ; then

        echo "Entering process startup loop"
        set +x
        while true
        do
            if ! pgrep -x $PGREP > /dev/null
            then
                /usr/bin/filter_ready
                /usr/bin/desktop_ready
                # Start dockerd first if not already active
                sudo dockerd > /var/log/dockerd.log 2>&1 &
                sleep 2
                # TODO: Figure out how to inject secrets into container, such as would be needed for `-e MOBSF_VT_ENABLED=1 -e MOBSF_VT_API_KEY={$VT_API_KEY}
                xfce4-terminal -x docker run -d --name mobsf --restart always -p 127.0.0.1:8000:8000 -e MOBSF_PLATFORM=docker -e MOBSF_DISABLE_AUTHENTICATION=1 opensecurity/mobile-security-framework-mobsf:latest &
                while ! check_web_server; do
                    sleep 1
                done
                set +e
                bash ${MAXIMIZE_SCRIPT} &
                $START_COMMAND $ARGS $URL
                set -e
            fi
            sleep 1
        done
        set -x
    fi
}

kasm_startup