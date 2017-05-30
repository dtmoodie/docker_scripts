from nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04

RUN apt-get -y update

RUN apt-get install -y build-essential libboost1.58-all-dev git wget cmake cmake-gui libqt5*5 \
                       qttools5-dev libqt5x11extras5-dev sudo wget \
                       freeglut3-dev nano htop tmux cmake-curses-gui \
                       libavformat-dev libavcodec-dev libavdevice-dev libavfilter-dev \
                       libavresample-dev libavutil-dev libswscale-dev gstreamer1.0-plugins-bad \
                       gstreamer1.0-plugins-ugly gstreamer1.0-plugins-base \
                       gstreamer1.0-plugins-good gstreamer1.0-libav libgstreamer1.0-dev \
                       libeigen3-dev gstreamer1.0-plugins* libgstreamer1.0* gstreamer1.0* \
                       libgstreamer-plugins-base1.0-dev \
                       libatlas-base-dev libgflags-dev \
                       libgoogle-glog-dev liblmdb-dev \
                       dh-autoreconf autoconf automake libtool curl unzip \
                       libleveldb-dev libhdf5-serial-dev libsnappy-dev  \
                       python-dev python-numpy python-matplotlib python-skimage \
                       python-pip python-sklearn

RUN pip install ipython==5.0 setuptools jupyter

# the below code is for setting up a non root user acount in the docker image for exporting X11 sessions.
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

RUN git clone http://github.com/kitware/cmake code/cmake && \
    mkdir code/cmake/build && \
    cd code/cmake/build && \
    cmake .. -DBUILD_QtDialog=ON && \
    make -j$(nproc) && sudo make install && \
    cd .. && \
    rm -fr build

# ===========================================================
# build VTK from source to have qt integration and OpenGL2 rendering backend

RUN git clone http://github.com/kitware/vtk code/vtk

RUN mkdir code/vtk/build_release && \
    cd code/vtk/build_release && \
    cmake -DVTK_Group_Qt=ON \
          -DVTK_QT_VERSION=5 \
          -DCMAKE_DEBUG_POSTFIX=d \
          -DCMAKE_BUILD_TYPE=Release \
          -DModule_vtkGUISupportQtOpenGL=ON \
          -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer -g -O3 -DNDEBUG" \
          .. && \
    make -j$(nproc) && \
    sudo make install && \
    make clean

# build protobuf from source at a specific commit for caffe to work correctly.
# need source build to force some static compile flags to make it play nicely with
# ROS binary build
RUN git clone https://github.com/google/protobuf code/protobuf && \
    cd code/protobuf && \
    git checkout f8ca3acd2924421dc18f685c629a6e54875ac113  && \
    ./autogen.sh && ./configure --disable-shared && \
    sed -i 's,CXXFLAGS =  -g -DNDEBUG,CXXFLAGS = -g -DNDEBUG -fPIC,g' src/Makefile && \
    make -j$(nproc) && sudo make install \
    && cd python && python setup.py build \
    && sudo python setup.py install \
    && cd /code && sudo rm -fr protobuf

# ===========================================================
# build OpenCV from source to have CUDA 8.0 support and pascal gpu support

RUN git clone -b allocator_improvements \
        http://github.com/dtmoodie/opencv code/opencv && \
    git clone http://github.com/dtmoodie/opencv_contrib code/opencv_contrib && \
    mkdir code/opencv/build_release && \
    cd /code/opencv/build_release && \
    cmake -DCMAKE_DEBUG_POSTFIX=d \
          -DWITH_CUBLAS=True \
          -DWITH_QT=True \
          -DWITH_VTK=True \
          -DWITH_OPENGL=True \
          -DCUDA_ARCH_BIN="3.0 3.5 5.0 6.0 6.1" \
          -DCUDA_ARCH_PTX="3.0 3.5 5.0 6.0" \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_CXX_FLAGS="-std=c++11" \
          -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer -g -O3 -DNDEBUG" \
          -DCUDA_PROPAGATE_HOST_FLAGS=OFF \
          -DCUDA_NVCC_FLAGS="-std=c++11;--expt-relaxed-constexpr" \
          -DCMAKE_SHARED_LINKER_FLAGS="-fPIC" \
          -DBUILD_PERF_TESTS=OFF \
          -DBUILD_opencv_text=off \
          -DBUILD_opencv_datasets=off \
          -DPROTOBUF_LIBRARY=/usr/local/lib/libprotobuf.a \
          -DPROTOBUF_LITE_LIBRARY=/usr/local/lib/libprotobuf-lite.a \
          -DPROTOBUF_PROTOC_EXECUTABLE=/usr/local/bin/protoc \
          -DPROTOBUF_PROTOC_LIBRARY=/usr/local/lib/libprotoc.a \
          -DPROTOBUF_INCLUDE_DIR=/usr/local/include \
          -DBUILD_TESTS=OFF .. && \
    make -j$(nproc) && \
    sudo make install && \
    make clean


# ===========================================================
# build caffe from source to have CUDA 8.0 support and pascal gpu support
# build caffe with boost log for exceptions and glog for aborts

RUN git clone -b 8.0 https://github.com/nvidia/nccl code/nccl && \
    cd code/nccl && \
    make -j24

RUN git clone -b sanghoon-dev_pvanet https://github.com/dtmoodie/caffe code/caffe

RUN mkdir code/caffe/build_blog_release && cd code/caffe/build_blog_release && \
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_INSTALL_PREFIX=/usr/local \
          -DUSE_GLOG=false \
          -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer -g -O3 -DNDEBUG" \
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
    make -j$(nproc) && \
    sudo make install && \
    make clean

RUN mkdir code/caffe/build && cd code/caffe/build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_INSTALL_PREFIX=/usr/local \
          -DUSE_GLOG=true \
          -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer -g -O3 -DNDEBUG" \
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
    make -j$(nproc) && \
    sudo make install && \
    make clean

RUN sudo apt-get install -y libflann-dev
# ==========================================================
# build pcl with cuda
RUN git clone https://github.com/pointcloudlibrary/pcl code/pcl && \
    cd code/pcl && mkdir build && cd build && \
    cmake -DBUILD_CUDA=ON \
          -DBUILD_GPU=ON \
          -DCUDA_ARCH_BIN="3.0 3.5 5.0 6.0" \
          -DCUDA_ARCH_PTX="3.0 3.5 5.0 6.0" \
          -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer -O3 -g -DNDEBUG" .. && \
    make -j$(nproc) && \
    sudo make install && \
    make clean

# ===========================================================
# These lines makes the jupyter-notebook server accessible via a remote connection
EXPOSE 8888
RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.ip = '*'" >> /home/developer/.jupyter/jupyter_notebook_config.py
CMD jupyter-notebook

# ===========================================================
# build WT 
RUN cd code && git clone https://github.com/emweb/wt && \
    cd wt && mkdir build && \
    cd build && cmake .. && make -j$(nproc) && \
    sudo make install && make clean

# ===========================================================
# build mxnet
RUN sudo apt-get install -y libopenblas-dev python-dev python-setuptools python-numpy

RUN cd code && git clone --recursive -b gpu_access https://github.com/dtmoodie/mxnet && \
    cd mxnet && \
    mkdir build && cd build && \
    cmake .. -DOpenCV_DIR=/usr/local/share/OpenCV \
      -DBLAS=Open \
      -DUSE_CUDA=ON -DUSE_CUDNN=ON && \
    make -j$(nproc)

RUN cd code/mxnet/python && \
    mkdir /code/mxnet/lib && \
    cp /code/mxnet/build/libmxnet.so /code/mxnet/lib/ && \
    sudo python setup.py install

RUN pip install graphviz

# ==============================================================
# install ros binary
RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" \
             > /etc/apt/sources.list.d/ros-latest.list' && \
    sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116 && \
    sudo apt-get update && \
    sudo apt-get install ros-kinetic-desktop-full -y