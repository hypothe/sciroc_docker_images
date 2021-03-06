#FROM registry.gitlab.com/competitions4/sciroc/dockers/sciroc
FROM hypothe/sciroc:hri-logic-objdet-devel

ENV HOME=/root
WORKDIR ${HOME}
RUN sudo apt-get update\
    && sudo apt-get install python3.8 python3-pip -y
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
RUN source ${HOME}/.bashrc \
    && source /opt/pal/ferrum/setup.bash \
    && source devel/setup.bash \
    && catkin build -DDISABLE_PAL_FLAGS=True -DCMAKE_BUILD_TYPE=Release



ENTRYPOINT ["bash"]