FROM registry.gitlab.com/competitions4/sciroc/dockers/sciroc:1.5 as pal
FROM ros:melodic-ros-base-bionic

COPY --from=pal /opt/pal/ferrum/share/pal_interaction_msgs /opt/ros/melodic/share/pal_interaction_msgs

# necessary to pull from the competition image due to the needed interaction msgs

SHELL ["/bin/bash", "-c"]
ENV REPO_WS=/home/user/ws

WORKDIR ${REPO_WS}
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install git curl wget pulseaudio -y
# Install catkin_tools
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" \
        > /etc/apt/sources.list.d/ros-latest.list \
		&& wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
RUN sudo apt-get update \
		&& apt-get install python3-catkin-tools -y

RUN source /opt/ros/melodic/setup.bash \
		&& mkdir src && catkin init && catkin build \
    && echo "source ${REPO_WS}/devel/setup.bash" >> ${HOME}/.bashrc \
		&& echo "source /opt/ros/melodic/setup.bash" >> ${HOME}/.bashrc 

RUN source ${HOME}/.bashrc && rosdep update && rosdep install --from-paths src --rosdistro melodic --ignore-src -y 
WORKDIR ${REPO_WS}/src
RUN apt-get update && apt-get install python python3 -y
RUN git clone https://github.com/Omotoye/tiago_tts.git \
		&& git clone https://github.com/hypothe/sciroc_hri.git \
		&& chmod +x sciroc_hri/scripts/* \
		&& git clone https://github.com/hypothe/dialogflow_ros.git -b melodic_up \
		&& chmod +x dialogflow_ros/scripts/*

WORKDIR ${REPO_WS}/src/dialogflow_ros
COPY json_folder ${REPO_WS}/src/dialogflow_ros/
ENV  CLOUDSDK_CORE_DISABLE_PROMPTS=1
ENV export GOOGLE_APPLICATION_CREDENTIALS="${REPO_WS}/src/dialogflow_ros/json_folder/gentle-proton-252714-066b7ef02309.json"
RUN apt-get update && apt-get install python python3 -y \
	&& ./instructions.sh \
	&& source ${HOME}/.bashrc

WORKDIR ${REPO_WS}
RUN source ${HOME}/.bashrc \
    && catkin build 

ENTRYPOINT ["bash"]