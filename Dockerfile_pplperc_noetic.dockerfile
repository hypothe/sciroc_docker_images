FROM ros:noetic-ros-base-focal

ENV HOME=/root
WORKDIR ${HOME}
RUN sudo apt-get update\
    && sudo apt-get install git python3.8 python3-pip ros-noetic-cv-bridge -y
    #&& sudo python3 -m pip install -U pip 
#RUN cd\
    #&& sudo python3 -m pip install -U setuptools

# RUN sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1\
#     && sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2
# 
# RUN sudo update-alternatives --config python3 \    
#     && sudo rm /usr/bin/python3 \
#     && sudo ln -s python3.8 /usr/bin/python3 
# RUN pip3 install --upgrade setuptools\
#     && pip3 install --upgrade pip\
#     && pip3 install opencv-python tensorflow 
RUN pip3 install opencv-python tensorflow cvlib 

WORKDIR ${REPO_WS}/src
RUN git clone https://github.com/AliceNardelli/images  \
    && cd images \
    && git checkout environment\
    && cd people_perception/scripts \
    && chmod +x *.py

WORKDIR ${HOME}
RUN git clone https://github.com/AliceNardelli/images  


WORKDIR  ${REPO_WS}
RUN rosdep update && rosdep install --from-paths src --ignore-src --rosdistro noetic -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install ros-noetic-usb-cam ros-noetic-image-view ros-noetic-rqt ros-noetic-rqt-common-plugins -y
RUN source ${HOME}/.bashrc \
    && catkin build

ENTRYPOINT ["bash"]