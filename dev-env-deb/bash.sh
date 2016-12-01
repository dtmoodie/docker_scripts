sudo nvidia-docker run -it --rm \
  --privileged --env="DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  -v /home/dan/docker/dev-env-deb/build:/build \
  -v /home/dan/code:/home/developer/code \
  -p 8888:8888 \
  dtmoodie/dev-env-deb:tmp bash
