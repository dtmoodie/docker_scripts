from nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04

RUN apt-get  -y update

RUN apt-get install -y build-essential libboost1.58-all-dev git wget libqt5*5 cmake \
                       cmake-qt-gui qttools5-dev libqt5x11extras5-dev sudo wget \
                       freeglut3-dev nano htop tmux cmake-curses-gui \
                       libavformat-dev libavcodec-dev libavdevice-dev libavfilter-dev \
                       libavresample-dev libavutil-dev libswscale-dev \
                       x264 libx264-dev \
                       gstreamer1.0-plugins-bad \
                       gstreamer1.0-plugins-ugly \
                       gstreamer1.0-plugins-base \
                       gstreamer1.0-plugins-good \
                       gstreamer1.0-libav \
                       libgstreamer1.0-dev \
                       gstreamer1.0-plugins* \
                       libgstreamer1.0* gstreamer1.0* \
                       libgstreamer-plugins-base1.0-dev \
                       libeigen3-dev \
                       libatlas-base-dev \
                       libgflags-dev \
                       libgoogle-glog-dev \
                       liblmdb-dev \
                       libleveldb-dev libhdf5-serial-dev libsnappy-dev  \
                       dh-autoreconf autoconf automake libtool curl unzip \
                       python-dev python-numpy python-matplotlib python-skimage \
                       python-pip python-sklearn \
                       gdb gdbserver python3-pil python3-matplotlib python3-numpy

RUN pip install setuptools jupyter

# ===========================================================
# the below code is for setting up a non root user acount in the 
# docker image for exporting X11 sessions.
ENV USERNAME developer
ENV UID 1000

RUN useradd -m $USERNAME && \
        echo "$USERNAME:$USERNAME" | chpasswd && \
        usermod --shell /bin/bash $USERNAME && \
        usermod -aG sudo $USERNAME && \
        echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
        chmod 0440 /etc/sudoers.d/$USERNAME && \
        usermod  --uid $UID $USERNAME && \
        groupmod --gid $UID $USERNAME

ADD entrypoint.sh /tmp/entrypoint.sh
RUN sudo chmod 777 /tmp/entrypoint.sh
USER $USERNAME
ENTRYPOINT ["/tmp/entrypoint.sh"]

ENV HOME /home/developer

RUN sudo mkdir code && sudo chown developer:developer code

# ===========================================================
# build VTK from source to have qt integration and OpenGL2 rendering backend

RUN git clone http://github.com/kitware/vtk code/vtk

RUN mkdir code/vtk/build_release && \
    cd code/vtk/build_release && \
    cmake -DVTK_Group_Qt=ON \
          -DVTK_QT_VERSION=5 \
          -DCMAKE_DEBUG_POSTFIX=d \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer -g" .. && \
    make -j24 && \
    sudo make install

# ===========================================================
# build OpenCV from source to have CUDA 8.0 support and pascal gpu support

RUN git clone http://github.com/itseez/opencv code/opencv

RUN mkdir code/opencv/build_release && \
    cd /code/opencv/build_release && \
    cmake -DCMAKE_DEBUG_POSTFIX=d \
          -DWITH_CUBLAS=True \
          -DWITH_QT=True \
          -DWITH_VTK=True \
          -DWITH_OPENGL=True \
          -DCUDA_ARCH_BIN="3.0 3.5 5.0 6.0 6.1" \
          -DCUDA_ARCH_PTX="3.0 3.5 5.0 6.0" \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer -g" \
          -DBUILD_PERF_TESTS=OFF \
          -DBUILD_TESTS=OFF .. && \
    make -j24 && \
    sudo make install

# ===========================================================
# build caffe from source to have CUDA 8.0 support and pascal gpu support


RUN git clone -b 8.0 https://github.com/nvidia/nccl code/nccl && \
    cd code/nccl && \
	make -j24

RUN git clone https://github.com/google/protobuf code/protobuf && \
    cd code/protobuf && ./autogen.sh && ./configure --disable-shared && \
    sed -i 's,CXXFLAGS =  -g -DNDEBUG,CXXFLAGS = -g -DNDEBUG -fPIC,g' src/Makefile && \
    make -j24 && sudo make install

RUN git clone -b boostlog https://github.com/dtmoodie/caffe code/caffe

RUN mkdir code/caffe/build && cd code/caffe/build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DUSE_GLOG=true \
          -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer -g" \
          -DCUDA_ARCH_NAME="Manual" \
          -DCUDA_ARCH_BIN="3.0 3.5 5.0 6.0 6.1" \
          -DCUDA_ARCH_PTX="3.0 3.5 5.0 6.0" \
          -DNCCL_INCLUDE_DIR=/code/nccl/build/include \
          -DNCCL_LIBRARY=/code/nccl/build/lib/libnccl.so \
          -DPROTOBUF_LIBRARY=/usr/local/lib/libprotobuf.a \
          -DPROTOBUF_LITE_LIBRARY=/usr/local/lib/libprotobuf-lite.a \
          -DPROTOBUF_PROTOC_EXECUTABLE=/usr/local/bin/protoc \
          -DPROTOBUF_PROTOC_LIBRARY=/usr/local/lib/libprotoc.a \
          -DPROTOBUF_INCLUDE_DIR=/usr/local/include .. && \
    make -j24 && \
    sudo make install

# build caffe with boost log for exceptions and glog for aborts
RUN mkdir code/caffe/build_blog_release && cd code/caffe/build_blog_release && \
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DUSE_GLOG=false \
          -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer -g" \
          -DCUDA_ARCH_NAME="Manual" \
          -DCUDA_ARCH_BIN="3.0 3.5 5.0 6.0 6.1" \
          -DCUDA_ARCH_PTX="3.0 3.5 5.0 6.0" \
          -DNCCL_INCLUDE_DIR=/code/nccl/build/include \
          -DNCCL_LIBRARY=/code/nccl/build/lib/libnccl.so \
          -DPROTOBUF_LIBRARY=/usr/local/lib/libprotobuf.a \
          -DPROTOBUF_LITE_LIBRARY=/usr/local/lib/libprotobuf-lite.a \
          -DPROTOBUF_PROTOC_EXECUTABLE=/usr/local/bin/protoc \
          -DPROTOBUF_PROTOC_LIBRARY=/usr/local/lib/libprotoc.a .. && \
    make -j24 && \
    sudo make install

# ===========================================================
# build mxnet

RUN sudo apt install libopenblas-dev -y
RUN git clone https://github.com/dtmoodie/mxnet code/mxnet && cd code/mxnet && git submodule update --init --recursive
RUN cd code/mxnet && mkdir build && cd build && \
    cmake -DEXTRA_OPERATORS="example/ssd/operator" \
          -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer -g" \
          -DCUDA_ARCH_NAME="Manual" \
          -DCUDA_ARCH_BIN="3.0 3.5 5.0 6.0 6.1" \
          -DCUDA_ARCH_PTX="3.0 3.5 5.0 6.0" .. && \
    make -j24

# ==========================================================
# build flann with cuda support

RUN git clone https://github.com/dtmoodie/flann code/flann && \
    cd code/flann && mkdir build && cd build && \
    cmake -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer -g" \
          -DCUDA_ARCH_NAME="Manual" \
          -DCUDA_ARCH_BIN="3.0 3.5 5.0 6.0 6.1" \
          -DCUDA_ARCH_PTX="3.0 3.5 5.0 6.0" \
          -DBUILD_CUDA_LIB=True .. && \
     make -j24 && sudo make install


# ===========================================================
# These lines makes the jupyter-notebook server accessible via a remote connection
EXPOSE 8888
RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.ip = '*'" >> /home/developer/.jupyter/jupyter_notebook_config.py
CMD jupyter-notebook

# ===========================================================
# basic debugging tools

ADD cv_imshow.py /home/developer/code/cv_imshow.py
RUN echo "source /home/developer/code/cv_imshow.py" > /home/developer/.gdbinit

# ==========================================================
# build pcl
RUN git clone https://github.com/pointcloudlibrary/pcl code/pcl && \
    cd code/pcl && mkdir build && cd build && \
    cmake -DBUILD_CUDA=ON \
          -DBUILD_GPU=ON \
          -DCUDA_ARCH_BIN="3.0 3.5 5.0 5.2 6.0" \
          -DCUDA_ARCH_PTX="3.0 5.0 6.0" \
          -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer -g" .. && \
    make -j24 && \
    sudo make install


# ==========================================================
# install ROS
RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" \
             > /etc/apt/sources.list.d/ros-latest.list' && \
    sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116 && \
    sudo apt-get update && \
    sudo apt-get install ros-kinetic-desktop-full -y

# ==========================================================
# copy qtcreator and prep for install
add qt* /home/developer/
RUN sudo chown developer:developer /home/developer/qt-creator* && \
    chmod +x /home/developer/qt-creator*
