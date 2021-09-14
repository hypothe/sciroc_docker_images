FROM registry.gitlab.com/competitions4/sciroc/dockers/sciroc:1.5 as pal
FROM ros:noetic-ros-base-focal

COPY --from=pal /opt/pal/ferrum/share/pal_interaction_msgs /opt/ros/noetic/share/pal_interaction_msgs

# necessary to pull from the competition image due to the needed interaction msgs

SHELL ["/bin/bash", "-c"]
ENV REPO_WS=/home/user/ws

WORKDIR ${REPO_WS}
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install git wget pulseaudio -y
# Install catkin_tools
RUN apt-get update && apt-get install wget -y
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" \
        > /etc/apt/sources.list.d/ros-latest.list \
		&& wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
RUN sudo apt-get update \
		&& apt-get install python3-catkin-tools -y

RUN source /opt/ros/noetic/setup.bash \
		&& mkdir src && catkin init && catkin build \
    && echo "source ${REPO_WS}/devel/setup.bash" >> ${HOME}/.bashrc \
		&& echo "source /opt/ros/noetic/setup.bash" >> ${HOME}/.bashrc 

RUN source ${HOME}/.bashrc && rosdep update && rosdep install --from-paths src --rosdistro noetic --ignore-src -y 
WORKDIR ${REPO_WS}/src
#		&& apt-get install ros-noetic-pal-msgs

RUN git clone https://github.com/Omotoye/tiago_tts.git \
		&& git clone https://github.com/hypothe/sciroc_hri.git \
		&& git clone https://github.com/cakmakcan/dialogflow_ros.git -b melodic_up 
		#&& git clone https://github.com/pal-robotics/pal_msgs.git \

WORKDIR ${REPO_WS}/src/dialogflow_ros
RUN ./instructions.sh \
	&& source ${HOME}/.bashrc

WORKDIR ${REPO_WS}
RUN source ${HOME}/.bashrc \
    && catkin build 

ENTRYPOINT ["bash"]