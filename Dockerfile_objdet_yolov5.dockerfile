FROM hypothe/sciroc:cuda-devel

# Install ROS packages
COPY ./gpu_config.sh ${REPO_WS}
WORKDIR ${REPO_WS}/src

RUN git clone --recursive https://github.com/hypothe/sciroc2021_objdet_meta.git -b yolov5
RUN apt-get update\
    && apt-get install python3.8 python3-pip python-pip -y 
RUN pip3 install --upgrade setuptools\
    && pip3 install --upgrade pip
RUN pip install subprocess32\
    && pip install -r https://raw.githubusercontent.com/ultralytics/yolov5/master/requirements.txt \
    && pip3 install torch numpy
# cv_bridge \

RUN git clone https://github.com/hypothe/sciroc_image_bridge image_bridge \
    && chmod +x image_bridge/scripts/*.py

RUN apt-get install ros-melodic-movie-publisher -y

WORKDIR  ${REPO_WS}
RUN source ${HOME}/.bashrc \
    && source /opt/pal/ferrum/setup.bash \
    && source devel/setup.bash \
    && catkin build -DDISABLE_PAL_FLAGS=True -DCMAKE_BUILD_TYPE=Release

COPY catkin_build_vsconf.py ${REPO_WS}

ENTRYPOINT ["bash"]
