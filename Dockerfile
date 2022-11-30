FROM osrf/ros:noetic-desktop-full

# =========================================================
# =========================================================

# Are you are looking for how to use this docker file?
#   - https://docs.openvins.com/dev-docker.html
#   - https://docs.docker.com/get-started/
#   - http://wiki.ros.org/docker/Tutorials/Docker

# =========================================================
# =========================================================

# Dependencies we use, catkin tools is very good build system
# Also some helper utilities for fast in terminal edits (nano etc)
RUN apt-get update && apt-get install -y libeigen3-dev nano git
RUN sudo apt-get install -y python3-catkin-tools python3-osrf-pycommon

# Ceres solver install and setup
RUN sudo apt-get install -y cmake libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev libceres-dev
# ENV CERES_VERSION="2.0.0"
# RUN git clone https://ceres-solver.googlesource.com/ceres-solver && \
#     cd ceres-solver && \
#     git checkout tags/${CERES_VERSION} && \
#     mkdir build && cd build && \
#     cmake .. && \
#     make -j$(nproc) install && \
#     rm -rf ../../ceres-solver

# Seems this has Python 3.8 installed on it...
RUN apt-get update && apt-get install -y python3-dev python3-matplotlib python3-numpy python3-psutil python3-tk

RUN mkdir -p /catkin_ws/src/open_vins

ADD . /catkin_ws/src/open_vins/.

RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    cd catkin_ws && catkin build

RUN sed --in-place --expression \
      '$isource "/catkin_ws/devel/setup.bash"' \
      /ros_entrypoint.sh
      
CMD ["roslaunch", "/catkin_ws/src/open_vins/demo.launch"]

