sudo docker run -it --rm \
    --volume=/tmp/.X11-unix:/tmp/.X11-unix:rw \
    --env="XAUTHORITY=/tmp/.X11-unix" \
    --env="DISPLAY" \
    --env="USERID=$UID" \
    dev-env bash
