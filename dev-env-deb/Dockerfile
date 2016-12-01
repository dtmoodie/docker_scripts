from dtmoodie/dev-env:release

# ===========================================================
# build VTK from source to have qt integration and OpenGL2 rendering backend

RUN mkdir code/vtk/build_debug && \
    cd code/vtk/build_debug && \
    cmake -DVTK_Group_Qt=ON \
          -DVTK_QT_VERSION=5 \
          -DCMAKE_BUILD_TYPE=Debug \
          -DCMAKE_DEBUG_POSTFIX=d \
           -DModule_vtkGUISupportQtOpenGL=True .. && \
    make -j24 && \
    cp /code/vtk/build_release/lib/libQVTKWidgetPlugin.so /code/vtk/build_debug/lib/ && \
    sudo make install

# ===========================================================
# build OpenCV from source to have CUDA 8.0 support and pascal gpu support

RUN mkdir code/opencv/build_debug && \
    cd /code/opencv/build_debug && \
    cmake -DCMAKE_DEBUG_POSTFIX=d \
          -DWITH_CUBLAS=True \
          -DWITH_QT=True \
          -DWITH_VTK=True \
          -DWITH_OPENGL=True \
          -DCUDA_ARCH_BIN="3.0 3.5 5.0 6.0 6.1" \
          -DCUDA_ARCH_PTX="3.0 3.5 5.0 6.0" \
          -DCMAKE_BUILD_TYPE=Debug .. && \
    make -j24 && \
    sudo make install

# ===========================================================
# build caffe from source to have CUDA 8.0 support and pascal gpu support
# build caffe with boost log for exceptions and glog for aborts

RUN mkdir code/caffe/build_debug && cd code/caffe/build_debug && \
    cmake -DCMAKE_BUILD_TYPE=Debug \
          -DUSE_GLOG=true \
          -DCUDA_ARCH_NAME="Manual" \
          -DCUDA_ARCH_BIN="3.0 3.5 5.0 6.0 6.1" \
          -DCUDA_ARCH_PTX="3.0 3.5 5.0 6.0" \
          -DNCCL_INCLUDE_DIR=/code/nccl/build/include \
          -DNCCL_LIBRARY=/code/nccl/build/lib/libnccl.so .. && \
    make -j24 && \
    sudo make install

RUN mkdir code/caffe/build_blog_debug && cd code/caffe/build_blog_debug && \
    cmake -DCMAKE_BUILD_TYPE=Debug \
          -DUSE_GLOG=false \
          -DCMAKE_CXX_FLAGS_RELEASE="-fno-omit-frame-pointer" \
          -DCUDA_ARCH_NAME="Manual" -DCUDA_ARCH_BIN="3.0 3.5 5.0 6.0 6.1" \
          -DCUDA_ARCH_PTX="3.0 3.5 5.0 6.0" \
          -DNCCL_INCLUDE_DIR=/code/nccl/build/include \
          -DNCCL_LIBRARY=/code/nccl/build/lib/libnccl.so .. && \
    make -j24 && \
    sudo make install

RUN cd code/flann && mkdir build_debug && cd build_debug && \
    cmake .. -DCUDA_ARCH_NAME="Manual" \
        -DCUDA_ARCH_BIN="3.0 3.5 5.0 6.0 6.1" \
        -DCUDA_ARCH_PTX="3.0 3.5 5.0 6.0" \
        -DCMAKE_BUILD_TYPE=Debug \
        -DBUILD_CUDA_LIB=True && \
    make -j24 && \
    sudo make install


RUN cd code/pcl && mkdir build_debug && cd build_debug && cmake .. \
        -DCMAKE_BUILD_TYPE=Debug \
        -DCMAKE_DEBUG_POSTFIX=d \
        -DBUILD_CUDA=ON \
        -DBUILD_GPU=ON \
        -DCUDA_ARCH_BIN="3.0 3.5 5.0 5.2 6.0" \
        -DCUDA_ARCH_PTX="3.0 5.0 6.0" && \
    make -j24 && \
    sudo make install


