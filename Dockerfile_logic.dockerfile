FROM hypothe/sciroc:objdet-yolov5-devel

WORKDIR ${REPO_WS}

RUN apt-get install ros-melodic-smach ros-melodic-smach-ros ros-melodic-executive-smach ros-melodic-smach-viewer pulseaudio -y

WORKDIR ${REPO_WS}/src
RUN git clone https://github.com/Omotoye/tiago_tts \
		&& git clone https://github.com/Omotoye/sciroc_hri.git \
		&& git clone https://github.com/hypothe/dialogflow_ros.git -b melodic_custom \
		&& git clone --recursive https://github.com/Omotoye/SciRoc2EP1.git
		#&& git clone https://github.com/cakmakcan/dialogflow_ros.git -b melodic_custom \

WORKDIR ${REPO_WS}/src/dialogflow_ros
RUN ./instructions.sh \
	&& source ${HOME}/.bashrc

	#	&& git clone --recursive https://github.com/Omotoye/SciRoc2EP1.git

WORKDIR ${REPO_WS}
RUN source devel/setup.bash \
    && catkin build -DDISABLE_PAL_FLAGS=True -DCMAKE_BUILD_TYPE=Release

ENTRYPOINT ["bash"]