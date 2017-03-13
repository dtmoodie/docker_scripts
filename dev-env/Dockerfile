from dtmoodie/dev-env:deploy


# ===========================================================
# build VTK from source to have qt integration and OpenGL2 rendering backend

RUN mkdir code/vtk/build_release && \
    cd code/vtk/build_release && \
    cmake -DVTK_Group_Qt=ON \
          -DVTK_QT_VERSION=5 \
          -DCMAKE_DEBUG_POSTFIX=d \
          -DCMAKE_BUILD_TYPE=Release \
          -DModule_vtkGUISupportQtOpenGL=ON \
          -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer -g -O3 -DNDEBUG" \
          .. && \
    make -j24 && \
    sudo make install


# ===========================================================
# build OpenCV from source to have CUDA 8.0 support and pascal gpu support

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
          -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer -g -O3 -DNDEBUG" \
          -DCMAKE_SHARED_LINKER_FLAGS="-fPIC" \
          -DOPENCV_EXTRA_MODULES_PATH="/code/opencv_contrib/modules" \
          -DBUILD_opencv_python2=OFF \
          -DBUILD_PERF_TESTS=OFF \
          -DBUILD_opencv_text=off \
          -DBUILD_opencv_datasets=off \
          -DPROTOBUF_LIBRARY=/usr/local/lib/libprotobuf.a \
          -DPROTOBUF_LITE_LIBRARY=/usr/local/lib/libprotobuf-lite.a \
          -DPROTOBUF_PROTOC_EXECUTABLE=/usr/local/bin/protoc \
          -DPROTOBUF_PROTOC_LIBRARY=/usr/local/lib/libprotoc.a \
          -DPROTOBUF_INCLUDE_DIR=/usr/local/include \
          -DBUILD_TESTS=OFF .. && \
    make -j24 && \
    sudo make install


# ===========================================================
# build caffe from source to have CUDA 8.0 support and pascal gpu support
# build caffe with boost log for exceptions and glog for aborts

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
    make -j24 && \
    sudo make install


# ===========================================================
# build mxnet

#RUN sudo apt install libopenblas-dev -y
#RUN git clone https://github.com/dtmoodie/mxnet code/mxnet && cd code/mxnet && git submodule update --init --recursive
#RUN cd code/mxnet && mkdir build && cd build && \
#    cmake -DEXTRA_OPERATORS="example/ssd/operator" \
#          -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer -g -O3 -DNDEBUG" \
#          -DCUDA_ARCH_NAME="Manual" \
#          -DCUDA_ARCH_BIN="6.0 6.1" \
#          -DCUDA_ARCH_PTX="6.0" .. && \
#    make -j24


# ==========================================================
# build flann

RUN cd code/flann && mkdir build && cd build && \
    cmake -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer -g -DNDEBUG -O3" \
          -DCUDA_ARCH_NAME="Manual" \
          -DCUDA_ARCH_BIN="3.0 3.5 5.0 6.0 6.1" \
          -DCUDA_ARCH_PTX="3.0 3.5 5.0 6.0" \
          -DBUILD_CUDA_LIB=True .. && \
     make -j24 && sudo make install && \
     cd /code/flann


# ==========================================================
# build pcl
RUN cd code/pcl && mkdir build && cd build && \
    cmake -DBUILD_CUDA=ON \
          -DBUILD_GPU=ON \
          -DCUDA_ARCH_BIN="3.0 3.5 5.0 6.0" \
          -DCUDA_ARCH_PTX="3.0 3.5 5.0 6.0" \
          -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer -O3 -g -DNDEBUG" .. && \
    make -j24 && \
    sudo make install && \
    cd /code/pcl

# ==========================================================
# build tensorflow
#RUN git clone https://github.com/tensorflow/tensorflow /code/tensorflow && \
#    cd /code/tensorflow && \
#    git checkout r1.0 && \
#    echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list && \
#    curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add - && \
#    sudo apt-get update && sudo apt-get install bazel && \
#    sudo apt-get install python-numpy python-dev python-pip python-wheel


# ===========================================================
# basic debugging tools
#RUN sudo apt-get update
RUN sudo apt-get install -y gdb gdbserver python3-pil python3-matplotlib
RUN echo "source /home/developer/code/gdb-imagewatch/cv_imshow.py" > /home/developer/.gdbinit
add qt* /home/developer/
RUN sudo chown developer:developer /home/developer/qt-creator* && \
    chmod +x /home/developer/qt-creator*
