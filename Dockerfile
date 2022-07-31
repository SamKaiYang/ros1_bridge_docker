#要訪問CUDA開發工具，您應該使用devel映像。這些是相關的標籤：
# 1.nvidia/cuda:10.2-devel-ubuntu18.04
# 2.nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04
# docker pull nvidia/cuda:11.7.0-devel-ubuntu20.04
FROM nvidia/cuda:11.7.0-devel-ubuntu20.04
#指定docker image存放位置
VOLUME ["/storage"]
MAINTAINER sam tt00621212@gmail.com

# root mode
USER root
# environment
ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive
# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics


ARG SSH_PRIVATE_KEY

RUN mkdir -p /code
WORKDIR /code

RUN apt-get update &&  apt-get install -y --no-install-recommends make g++ && \
    apt-get update && \
        apt-get install -y \
        build-essential \
        git \
        wget \
        unzip \
        yasm \
        pkg-config \
        libcurl4-openssl-dev \
        zlib1g-dev \
        nano \
        gedit \
        vim

SHELL ["/bin/bash","-c"]

RUN apt-get -y upgrade

RUN apt update && apt install -y curl gnupg2 lsb-release
# install ros1-noetic-desktop-docker
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt update
RUN apt install -y ros-noetic-desktop-full
RUN source /opt/ros/noetic/setup.bash
RUN apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
RUN rosdep init && rosdep update


# install ros2-foxy-desktop use binary
RUN locale  && \
    apt update && apt -y install locales && \
    locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    locale 

RUN apt install -y software-properties-common && add-apt-repository universe


RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
RUN apt update && \
    apt -y upgrade
RUN mkdir -p /ros2_foxy
WORKDIR /ros2_foxy 
RUN apt update && wget https://github.com/ros2/ros2/releases/download/release-foxy-20220208/ros2-foxy-20220208-linux-focal-amd64.tar.bz2
RUN tar xf ros2-foxy-20220208-linux-focal-amd64.tar.bz2
RUN apt update && apt install -y python3-rosdep
# && rosdep init && rosdep update
RUN rm /etc/ros/rosdep/sources.list.d/20-default.list && \
    rosdep init && \
    rosdep update
RUN apt -y upgrade
RUN rosdep install --from-paths ros2-linux/share --os=ubuntu:focal --ignore-src -y --skip-keys "cyclonedds fastcdr fastrtps rti-connext-dds-5.3.1 urdfdom_headers"
RUN apt install -y libpython3-dev python3-pip
RUN pip3 install -U argcomplete



# install colcon
RUN apt install -y python3-colcon-common-extensions


# echo bashrc
# RUN echo "echo "ros noetic(1) or ros2 foxy(2)?"  \
# read edition && \
# if [ "$edition" -eq "1" ]; then && \
#   source /opt/ros/noetic/setup.bash && \
# else && \
#   source /opt/ros/foxy/setup.bash && \
# fi" >> ~/.bashrc 

# RUN mkdir -p ~/colcon_ws/src
# WORKDIR ~/colcon_ws/src
# RUN git clone https://github.com/ros2/ros1_bridge
# RUN colcon build --symlink-install --packages-skip ros1_bridge
# RUN source /opt/ros/noetic/setup.bash
# RUN source /ros2_foxy/ros2-linux/setup.bash
# RUN colcon build --symlink-install --packages-select ros1_bridge --cmake-force-configure

# 使用者新增
RUN useradd -ms/bin/bash iclab && echo "iclab:iclab" | chpasswd && \
adduser iclab sudo


USER iclab
WORKDIR /home/iclab
USER root
RUN mkdir -p /test_ws/src
WORKDIR /test_ws/src
WORKDIR ..
USER iclab
