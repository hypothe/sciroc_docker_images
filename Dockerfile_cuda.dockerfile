FROM registry.gitlab.com/competitions4/sciroc/dockers/sciroc:1.5

LABEL maintainer="Marco Gabriele Fedozzi <5083365@studenti.unige.it>"

ENV REPO_WS=/home/user/ws
RUN mkdir -p $REPO_WS/src

SHELL ["/bin/bash", "-c"]


# Build and source your ros packages 
WORKDIR $REPO_WS
RUN source /opt/pal/ferrum/setup.bash \
    && catkin build \
    && echo 'source /opt/pal/ferrum/setup.bash' >> ${HOME}/.bashrc \
    && echo "source ${REPO_WS}/devel/setup.bash" >> ${HOME}/.bashrc \
    && echo "export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/home/user/ws/src/Sciroc2EP1-SimulatedEnv/models" >> ${HOME}/.bashrc
    # Add below line to automatically source your packages
    # && echo 'source $REPO_WS/devel/setup.bash' >> ~/.bashrc

# Install CUDA drivers
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin \
    && mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600 \
    && wget https://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb \
    && dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb \
    && apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub \
    && apt-get update \
    && apt-get install -y cuda-toolkit-10-2 \
    && echo -e 'if [ -d "/usr/local/cuda/bin/" ]; then \n\      
                export PATH=/usr/local/cuda/bin${PATH:+:${PATH}} \n\
                export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} \n\
            fi' >> ${HOME}/.bashrc \
    && rm cuda*.deb 


WORKDIR  ${REPO_WS}
# Install extra tools
RUN apt-get update && apt-get install -y gdb
RUN source ${HOME}/.bashrc \
    && source /opt/pal/ferrum/setup.bash \
    && source devel/setup.bash \
    && catkin build -DDISABLE_PAL_FLAGS=True

ENTRYPOINT ["bash"]
