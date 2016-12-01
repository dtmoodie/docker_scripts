sudo nvidia-docker run -it --rm -p 8888:8888 -v /mnt/data_local:/data:rw dtmoodie/dev-env:jupyter jupyter-notebook
