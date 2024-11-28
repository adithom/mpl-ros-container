FROM ros:noetic-ros-core-focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        wget \
        libopencv-dev \
        python3-catkin-tools \
        build-essential \      
        cmake \  
        python3-pip \
        ros-noetic-rviz \
        ros-noetic-pcl-ros \
        libsdl1.2-dev \
        libsdl-image1.2-dev \
        python3-rosdep \
        libgl1-mesa-glx \       
        libgl1-mesa-dri \       
        mesa-utils \            
        libx11-dev \
        libxrender-dev \        
        libxtst-dev \            
        libxi-dev \             
        libglu1-mesa \         
        libegl1-mesa && \  
    sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    wget http://packages.ros.org/ros.key -O - | apt-key add - && \
    apt-get update && \
    # Clean up to reduce image size
    rm -rf /var/lib/apt/lists/*

RUN rosdep init && rosdep update

ENV CATKIN_WS=/root/catkin_ws
RUN mkdir -p $CATKIN_WS/src

COPY mpl_ros $CATKIN_WS/src/mpl_ros

WORKDIR $CATKIN_WS

RUN git clone https://github.com/catkin/catkin_simple.git src/catkin_simple

RUN rosdep update && \
    rosdep install --from-paths src --ignore-src -r -y

RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && \
    catkin config -DCMAKE_BUILD_TYPE=Release && \
    catkin build"

RUN echo "source /opt/ros/noetic/setup.bash && source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc

ENTRYPOINT ["/bin/bash"]