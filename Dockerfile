FROM arm64v8/ros:melodic

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        wget \
        libopencv-dev \
        python3-catkin-tools \
        build-essential \
        cmake \
        python-pip \
        ros-melodic-rviz \
        ros-melodic-tf-conversions \
        libsdl1.2-dev \
        libsdl-image1.2-dev \
        python-rosdep \
        libgl1-mesa-glx \
        libgl1-mesa-dri \
        mesa-utils \
        libx11-dev \
        libxrender-dev \
        libxtst-dev \
        libxi-dev \
        libglu1-mesa \
        libegl1-mesa \
        libeigen3-dev \
        libboost-all-dev \
        libvtk6-dev \
        libflann-dev \
        libqhull-dev \
        libusb-1.0-0-dev \
        libopenni-dev \
        libopenni2-dev \
        libpcap-dev \
        libpng-dev \
        libjpeg-dev \
        libtiff5-dev \
        libglew-dev \
        libgtest-dev \
        libboost-system-dev \
        libboost-thread-dev \
        libboost-program-options-dev \
        libboost-filesystem-dev \
        libboost-chrono-dev \
        libboost-date-time-dev \
        libboost-regex-dev \
        libboost-iostreams-dev \
        libboost-serialization-dev && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get purge -y 'libpcl*' && \
    rm -rf /var/lib/apt/lists/*

RUN rosdep update

ENV CATKIN_WS=/root/catkin_ws

RUN mkdir -p $CATKIN_WS/src

COPY mpl_ros $CATKIN_WS/src/mpl_ros

WORKDIR $CATKIN_WS

RUN git clone https://github.com/catkin/catkin_simple.git src/catkin_simple

RUN git clone https://github.com/ros-perception/perception_pcl.git src/pcl_ros

RUN rosdep update && \
    rosdep install --from-paths src --ignore-src -r -y && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/PointCloudLibrary/pcl.git /opt/pcl-src && \
    cd /opt/pcl-src && \
    git checkout pcl-1.8.1 && \  
    # Modify CMakeLists.txt to define FLANN_USE_SYSTEM_LZ4
    sed -i '/project(PCL CXX)/i add_definitions(-DFLANN_USE_SYSTEM_LZ4)' CMakeLists.txt && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc) && \
    make install && \
    ldconfig

RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && \
    catkin config --extend /opt/ros/melodic --cmake-args -DCMAKE_BUILD_TYPE=Release && \
    catkin clean -y && \
    catkin build -j1 --verbose"

RUN echo 'source /opt/ros/melodic/setup.bash' >> /root/.bashrc && \
    echo 'source /root/catkin_ws/devel/setup.bash' >> /root/.bashrc

ENTRYPOINT ["/bin/bash"]