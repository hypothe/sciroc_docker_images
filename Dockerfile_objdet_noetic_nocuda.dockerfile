FROM ros:noetic-ros-base-focal

SHELL ["/bin/bash", "-c"]
ENV REPO_WS=/home/user/ws

WORKDIR ${REPO_WS}
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install dpkg git curl wget  -y
# Install catkin_tools

RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" \
        > /etc/apt/sources.list.d/ros-latest.list \
		&& wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
RUN sudo apt-get update \
		&& DEBIAN_FRONTEND=noninteractive apt-get install python3-catkin-tools -y
RUN source /opt/ros/noetic/setup.bash \
		&& mkdir src && catkin init && catkin build \
    && echo "source ${REPO_WS}/devel/setup.bash" >> ${HOME}/.bashrc \
		&& echo "source /opt/ros/noetic/setup.bash" >> ${HOME}/.bashrc 

RUN source ${HOME}/.bashrc && rosdep update && rosdep install --from-paths src --rosdistro noetic --ignore-src -y 
# Install ROS packages
WORKDIR ${REPO_WS}/src

RUN apt-get update\
    && DEBIAN_FRONTEND=noninteractive && apt-get install git curl python3.8 python3-pip -y 
RUN git clone --recursive https://github.com/hypothe/sciroc2021_objdet_meta.git -b yolov5-noetic

RUN pip3 install --upgrade setuptools \
    && pip3 install --upgrade pip
RUN pip install subprocess32\
    && pip3 install -r https://raw.githubusercontent.com/ultralytics/yolov5/master/requirements.txt \
    && pip3 install torch numpy

RUN git clone https://github.com/hypothe/sciroc_image_bridge image_bridge \
    && chmod +x image_bridge/scripts/*.py

WORKDIR  ${REPO_WS}
RUN rosdep update && rosdep install --from-paths src --ignore-src --rosdistro noetic -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install ros-noetic-control-msgs ros-noetic-usb-cam ros-noetic-image-view ros-noetic-rqt ros-noetic-rqt-common-plugins -y
RUN source ${HOME}/.bashrc \
    && source ${REPO_WS}/devel/setup.bash \
    && catkin build

ENTRYPOINT ["bash"]
