FROM ros:noetic-ros-core-focal

RUN apt-get update && apt-get install -y git
RUN apt update && apt install -y wget
RUN apt-get install -y libopencv-dev

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" \
    > /etc/apt/sources.list.d/ros-latest.list' && \
    wget http://packages.ros.org/ros.key -O - | apt-key add -
RUN apt-get update

RUN apt-get install -y python3-catkin-tools

RUN apt-get install -y \
    python3-pip \
    ros-noetic-rviz \
    ros-noetic-pcl-ros \
    libsdl1.2-dev \
    libsdl-image1.2-dev

RUN apt-get update && apt-get install -y python3-rosdep
RUN rosdep init && rosdep update

# Create a catkin workspace
ENV CATKIN_WS = /root/catkin_ws
RUN mkdir -p $CATKIN_WS/src

COPY mpl_ros $CATKIN_WS/src/mpl_ros

WORKDIR $CATKIN_WS

RUN git clone https://github.com/catkin/catkin_simple.git src/catkin_simple

RUN rosdep update && \
    rosdep install --from-paths src --ignore-src -r -y

# Build the workspace using catkin tools
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && \
    catkin config -DCMAKE_BUILD_TYPE=Release && \
    catkin build"

# Source the workspace on container start
RUN echo "source /opt/ros/noetic/setup.bash && source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc

# Source the workspace on container start
RUN echo "source /opt/ros/noetic/setup.bash && source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc
