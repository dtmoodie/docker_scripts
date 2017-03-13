DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

xhost +local:root

nvidia-docker run \
  -it \
  --rm \
  --privileged \
  --env="DISPLAY" \
  --user=$USER \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  -v $DIR/../dev-env-build:/build \
  -v /home/developer/code:/home/developer/code \
  -v /data:/data \
  -p 8888:8888 \
  -p 39999:39999 \
  -p 17815:17815 \
  --net=host \
  dtmoodie/dev-env:deploy bash

xhost -local:root
