FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

# Basic toolchain
RUN apt-get update && apt-get install -y \
        apt-utils \
        build-essential \
        git \
        wget \
        unzip \
        yasm \
        pkg-config \
        libcurl4-openssl-dev \
        zlib1g-dev \
        htop \
        cmake \
        nano && \
    apt-get autoremove -y

# Getting OpenCV dependencies available with apt
RUN apt-get update && apt-get install -y \
        libeigen3-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libjasper-dev \
        libswscale-dev \
        libavcodec-dev \
        libavformat-dev && \
    apt-get autoremove -y

# Getting other dependencies
RUN apt-get update && apt-get install -y \
        cppcheck \
        graphviz \
        doxygen \
        p7zip-full \
        libdlib18 \
        libdlib-dev && \
    apt-get autoremove -y

ENV PYTHON_VERSION="3.7"
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y \
        python${PYTHON_VERSION} && \
    apt-get autoremove -y    

ENV CGREEN_VERSION="1.2.0"
RUN mkdir -p /tmp && \
    cd /tmp && \
    wget --no-check-certificate -O cgreen.zip https://github.com/cgreen-devs/cgreen/archive/${CGREEN_VERSION}.zip && \
    unzip cgreen.zip && \
    cd cgreen && \
    make && \
    make test && \
    make install

# Install OpenCV + OpenCV contrib
ENV OPENCV_VERSION="4.3.0"
RUN mkdir -p /tmp && \
    cd /tmp && \
    wget --no-check-certificate -O opencv.zip https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
    wget --no-check-certificate -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip && \
    unzip opencv.zip && \
    unzip opencv_contrib.zip && \
    mkdir opencv-${OPENCV_VERSION}/build && \
    cd opencv-${OPENCV_VERSION}/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D WITH_CUDA=ON \
        -D CUDA_FAST_MATH=1 \
        -D WITH_CUBLAS=1 \
        -D WITH_FFMPEG=ON \
        -D WITH_OPENCL=ON \
        -D WITH_V4L=ON \
        -D WITH_OPENGL=ON \
        -D OPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib-${OPENCV_VERSION}/modules \
        .. && \
    make -j$(nproc) && \
    make install && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf && \
    ldconfig && \
    cd /tmp && \
    rm -rf opencv-${OPENCV_VERSION} opencv.zip opencv_contrib-${OPENCV_VERSION} opencv_contrib.zip && \
    cd /
