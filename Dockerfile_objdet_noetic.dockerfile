FROM hypothe/sciroc:cuda11.4-noetic

ENV REPO_WS=/home/user/ws

SHELL ["/bin/bash", "-c"]

# Install ROS packages
COPY ./gpu_config.sh ${REPO_WS}/
WORKDIR ${REPO_WS}/src

RUN apt-get update\
    && apt-get install git curl python3.8 python3-pip ros-noetic-usb-cam ros-noetic-image-view ros-noetic-rqt ros-noetic-rqt-common-plugins -y 
RUN git clone --recursive https://github.com/hypothe/sciroc2021_objdet_meta.git -b yolov5-noetic
#RUN python -m pip install 'pip==20.3.4'
RUN pip3 install --upgrade setuptools \
    && pip3 install --upgrade pip
RUN pip install subprocess32\
    && pip3 install -r https://raw.githubusercontent.com/ultralytics/yolov5/master/requirements.txt \
    && pip3 install torch numpy
# cv_bridge \

RUN git clone https://github.com/hypothe/sciroc_image_bridge image_bridge \
    && chmod +x image_bridge/scripts/*.py
#RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list \
#	&& curl -sSL 'http://keyserver.ubuntu.com/pks/lookupop=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | apt-key add - \
#	&& rosdep update
#
#RUN apt update && apt install ros-melodic-movie-publisher -y
WORKDIR  ${REPO_WS}
RUN rosdep update && rosdep install --from-paths src --ignore-src --rosdistro noetic -y
RUN apt-get install ros-noetic-control-msgs
RUN source ${HOME}/.bashrc \
    && source devel/setup.bash \
    && catkin build

COPY catkin_build_vsconf.py ${REPO_WS}

ENTRYPOINT ["bash"]
