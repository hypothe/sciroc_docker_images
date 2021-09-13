FROM ros:noetic-ros-base-focal

LABEL maintainer="Marco Gabriele Fedozzi <5083365@studenti.unige.it>"

ENV REPO_WS=/home/user/ws
RUN mkdir -p $REPO_WS/src

SHELL ["/bin/bash", "-c"]
USER root

# Build and source your ros packages 
WORKDIR $REPO_WS
# Install catkin_tools
RUN apt-get update && apt-get install wget -y
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" \
        > /etc/apt/sources.list.d/ros-latest.list \
		&& wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
RUN sudo apt-get update \
		&& apt-get install python3-catkin-tools
# Initialize the workspace
RUN source /opt/ros/noetic/setup.bash && \
		catkin init \
    && echo "source ${REPO_WS}/devel/setup.bash" >> ${HOME}/.bashrc \
		&& echo "source /opt/ros/noetic/setup.bash" >> ${HOME}/.bashrc 
    # Add below line to automatically source your packages
    # && echo 'source $REPO_WS/devel/setup.bash' >> ~/.bashrc

# Install CUDA drivers
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin \
    && mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 \
		&& wget https://developer.download.nvidia.com/compute/cuda/11.4.2/local_installers/cuda-repo-ubuntu2004-11-4-local_11.4.2-470.57.02-1_amd64.deb   \
		&& dpkg -i cuda-repo-ubuntu2004-11-4-local_11.4.2-470.57.02-1_amd64.deb \
		&& apt-key add /var/cuda-repo-ubuntu2004-11-4-local/7fa2af80.pub \
		&& apt-get update \
    && apt-get install -y cuda-toolkit-11-4 \
    && echo -e 'if [ -d "/usr/local/cuda/bin/" ]; then \n\      
                export PATH=/usr/local/cuda/bin${PATH:+:${PATH}} \n\
                export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} \n\
            fi' >> ${HOME}/.bashrc \
    && rm cuda*.deb 


WORKDIR  ${REPO_WS}
# Install extra tools
RUN apt-get update && apt-get install -y gdb
RUN source ${HOME}/.bashrc \
    && source devel/setup.bash \
    && catkin build

ENTRYPOINT ["bash"]
