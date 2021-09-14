FROM ros:noetic-ros-base-focal

SHELL ["/bin/bash", "-c"]
ENV REPO_WS=/home/user/ws
WORKDIR ${REPO_WS}
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install git wget ros-noetic-smach ros-noetic-smach-ros ros-noetic-executive-smach ros-noetic-smach-viewer -y
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" \
        > /etc/apt/sources.list.d/ros-latest.list \
		&& wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
RUN sudo apt-get update \
		&& apt-get install python3-catkin-tools -y
RUN source /opt/ros/noetic/setup.bash \
		&& mkdir src && catkin init && catkin build \
    && echo "source ${REPO_WS}/devel/setup.bash" >> ${HOME}/.bashrc \
		&& echo "source /opt/ros/noetic/setup.bash" >> ${HOME}/.bashrc 
RUN rosdep update && rosdep install --from-paths src --ignore-src --rosdistro noetic -y

WORKDIR ${REPO_WS}/src

RUN git clone https://github.com/hypothe/sciroc_meta.git -b load-nodep

## Do not build, as it depends on all the other containers
## one way to still do that would be to 
#WORKDIR ${REPO_WS}
RUN source ${HOME}/.bashrc \
    && catkin build 
WORKDIR ${REPO_WS}
ENTRYPOINT ["bash"]