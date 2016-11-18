sudo nvidia-docker run -it --rm \
  --privileged --env="DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  -v /home/torc/docker/dev-env/build:/build \
  -p 8888:8888 \
  dev-env bash
